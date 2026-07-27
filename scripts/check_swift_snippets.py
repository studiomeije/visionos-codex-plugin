#!/usr/bin/env python3
"""Typecheck every ```swift block in the plugin docs against the installed visionOS SDK.

The plugins document beta API. Without a mechanical check, a renamed or moved
symbol silently turns into an agent writing code that does not compile.

Usage:
    python3 scripts/check_swift_snippets.py                # check everything
    python3 scripts/check_swift_snippets.py plugins/build-realitykit
    python3 scripts/check_swift_snippets.py --list-only    # just count snippets

Requires Xcode with a visionOS SDK. Skips (exit 0) when no SDK is present so the
script stays runnable on Linux CI and non-Apple machines.

Only "API-level" diagnostics fail the build: a snippet naming a type, member,
argument label, or availability that the SDK disagrees with. Errors caused by a
snippet being a fragment (undefined app-specific types, top-level statements)
are reported as skipped, not failed - documentation snippets are illustrative
and are not expected to compile standalone.
"""

from __future__ import annotations

import argparse
import concurrent.futures as cf
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_TARGET = "arm64-apple-xros{version}"

# Diagnostics that mean the DOC is wrong about the SDK.
API_ERROR_PATTERNS = [
    # A base type of 'Any' means inference failed on an undeclared placeholder,
    # so the diagnostic says nothing about the SDK - require a concrete type.
    re.compile(r"value of type '(?!Any')[^']+' has no member '[A-Za-z0-9_]+'"),
    re.compile(r"type '(?!Any')[A-Za-z0-9_.]+' has no member '[A-Za-z0-9_]+'"),
    re.compile(r"incorrect argument label in call"),
    re.compile(r"extra argument '[A-Za-z0-9_]+' in call"),
    re.compile(r"argument '[A-Za-z0-9_]+' must precede argument"),
    re.compile(r"is unavailable in visionOS"),
    re.compile(r"cannot find type '(AR|AV|NS|UI|RK|USD|Widget|Group|Chart|Reality|Spatial|Immersive|Portal|Model3D)[A-Za-z0-9_]*' in scope"),
    # Uppercase only: a lowercase `meshResource` is a snippet placeholder, an
    # uppercase `MeshResource` is a type the doc claims the SDK has.
    re.compile(r"cannot find '[A-Z][A-Za-z0-9_]*(Component|Provider|Resource|Session|Anchor|Material|Descriptor)' in scope"),
]

# Extra modules imported only when the snippet mentions them.
OPTIONAL_MODULES = [
    "USDKit", "GroupActivities", "WidgetKit", "AppIntents", "AVKit",
    "AVFoundation", "Charts", "Spatial", "simd", "Metal", "Observation",
    "UniformTypeIdentifiers", "CoreGraphics", "QuartzCore", "ComputeGraph",
]

BASE_IMPORTS = "import Foundation\nimport SwiftUI\nimport RealityKit\nimport ARKit\nimport Combine\nimport os\n"

# A snippet that already declares something is compiled as-is; a bare sequence
# of statements gets wrapped so top-level-code rules do not fire.
DECL_START = re.compile(
    r"^\s*(import|@|public|internal|private|fileprivate|open|final|struct|class|enum|extension|protocol|actor|func|typealias|#)",
    re.M,
)

SNIPPET_RE = re.compile(r"```swift\n(.*?)```", re.S)

# Types/helpers a doc defines in one snippet and uses in another. Snippets are
# typechecked in isolation, so these must not count as SDK mismatches.
LOCAL_DECL_RE = re.compile(
    r"^\s*(?:public |private |internal |fileprivate |final )*"
    r"(?:struct|class|enum|protocol|actor|typealias)\s+([A-Za-z_][A-Za-z0-9_]*)",
    re.M,
)
LOCAL_FUNC_RE = re.compile(
    r"^\s*(?:public |private |internal |fileprivate |final |static |mutating )*"
    r"func\s+([A-Za-z_][A-Za-z0-9_]*)",
    re.M,
)
LOCAL_MEMBER_RE = re.compile(
    r"^\s*(?:public |private |internal |fileprivate )*"
    r"static\s+(?:let|var)\s+([A-Za-z_][A-Za-z0-9_]*)",
    re.M,
)


def local_symbols(markdown_text: str) -> set[str]:
    """Names the document declares for itself, across all of its snippets."""
    names: set[str] = set()
    for m in SNIPPET_RE.finditer(markdown_text):
        code = m.group(1)
        names.update(LOCAL_DECL_RE.findall(code))
        names.update(LOCAL_FUNC_RE.findall(code))
        names.update(LOCAL_MEMBER_RE.findall(code))
    return names


QUOTED_NAME_RE = re.compile(r"'([A-Za-z_][A-Za-z0-9_]*)'")


def find_sdk() -> tuple[str, str] | None:
    """Return (sdk_path, target_triple) for the newest installed visionOS SDK."""
    for sdk_name in ("xros", "xrsimulator"):
        try:
            path = subprocess.run(
                ["xcrun", "--sdk", sdk_name, "--show-sdk-path"],
                capture_output=True, text=True, timeout=60,
            )
            version = subprocess.run(
                ["xcrun", "--sdk", sdk_name, "--show-sdk-version"],
                capture_output=True, text=True, timeout=60,
            )
        except (FileNotFoundError, subprocess.TimeoutExpired):
            return None
        if path.returncode == 0 and path.stdout.strip():
            ver = version.stdout.strip() or "27.0"
            triple = DEFAULT_TARGET.format(version=ver)
            if sdk_name == "xrsimulator":
                triple += "-simulator"
            return path.stdout.strip(), triple
    return None


def collect_snippets(roots: list[Path]) -> list[tuple[Path, int, str, frozenset[str]]]:
    out: list[tuple[Path, int, str, frozenset[str]]] = []
    for root in roots:
        files = sorted(root.rglob("*.md")) if root.is_dir() else [root]
        for md in files:
            text = md.read_text(encoding="utf-8")
            local = frozenset(local_symbols(text))
            for m in SNIPPET_RE.finditer(text):
                line = text.count("\n", 0, m.start()) + 1
                out.append((md, line, m.group(1), local))
    return out


def is_package_manifest(code: str) -> bool:
    """Package.swift manifests use PackageDescription, not the visionOS SDK."""
    return "PackageDescription" in code or re.search(r"^\s*let package = Package\(", code, re.M) is not None


def build_source(code: str) -> str:
    imports = BASE_IMPORTS
    for mod in OPTIONAL_MODULES:
        if re.search(rf"\b{mod}\b", code) and f"import {mod}" not in code:
            imports += f"#if canImport({mod})\nimport {mod}\n#endif\n"
    body = code if DECL_START.search(code) else (
        "@MainActor func __snippet() async throws {\n" + code + "\n}\n"
    )
    return imports + "\n" + body


def check_one(args) -> dict:
    idx, (md, line, code, local), sdk, triple, workdir = args
    if is_package_manifest(code):
        return {"file": str(md.relative_to(REPO_ROOT)), "line": line,
                "api_errors": [], "had_any_error": False, "skipped": True}
    src = build_source(code)
    path = Path(workdir) / f"snippet_{idx}.swift"
    path.write_text(src, encoding="utf-8")
    try:
        proc = subprocess.run(
            ["xcrun", "swiftc", "-typecheck", "-target", triple, "-sdk", sdk, str(path)],
            capture_output=True, text=True, timeout=300,
        )
        stderr = proc.stderr
    except subprocess.TimeoutExpired:
        stderr = "error: typecheck timed out"

    api_errors = []
    for diag in stderr.splitlines():
        if ": error: " not in diag:
            continue
        message = diag.split(": error: ", 1)[1]
        if not any(p.search(message) for p in API_ERROR_PATTERNS):
            continue
        # Skip diagnostics whose subject is a symbol this document defines for
        # itself in another snippet. The subject is the last quoted name:
        # "value of type 'Image' has no member 'debugBorder3D'" is about
        # debugBorder3D, a helper this doc declares.
        names = QUOTED_NAME_RE.findall(message)
        if local and names and names[-1] in local:
            continue
        api_errors.append(message.strip())

    return {
        "file": str(md.relative_to(REPO_ROOT)),
        "line": line,
        "api_errors": api_errors,
        "had_any_error": ": error: " in stderr,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("paths", nargs="*", default=None,
                        help="files or directories to check (default: plugins/)")
    parser.add_argument("--list-only", action="store_true",
                        help="count snippets and exit without typechecking")
    parser.add_argument("--jobs", type=int, default=min(10, (os.cpu_count() or 4)),
                        help="parallel typecheck jobs")
    args = parser.parse_args()

    roots = [Path(p) for p in args.paths] if args.paths else [REPO_ROOT / "plugins"]
    roots = [r if r.is_absolute() else REPO_ROOT / r for r in roots]

    snippets = collect_snippets(roots)
    print(f"found {len(snippets)} swift snippets")
    if args.list_only:
        return 0
    if not snippets:
        return 0

    sdk_info = find_sdk()
    if sdk_info is None:
        print("no visionOS SDK found (needs Xcode) - skipping typecheck")
        return 0
    sdk, triple = sdk_info
    print(f"typechecking against {triple}\n  sdk: {sdk}\n")

    with tempfile.TemporaryDirectory() as workdir:
        work = [(i, s, sdk, triple, workdir) for i, s in enumerate(snippets)]
        results = []
        with cf.ThreadPoolExecutor(max_workers=args.jobs) as pool:
            for i, res in enumerate(pool.map(check_one, work), 1):
                results.append(res)
                if i % 50 == 0:
                    print(f"  {i}/{len(work)}")

    failures = [r for r in results if r["api_errors"]]
    fragments = sum(1 for r in results if r["had_any_error"] and not r["api_errors"])
    clean = len(results) - fragments - len(failures)

    print(f"\nclean: {clean}   fragment-only diagnostics: {fragments}   API mismatches: {len(failures)}")

    if failures:
        print("\nAPI mismatches - the docs disagree with the installed SDK:\n")
        for r in sorted(failures, key=lambda r: (r["file"], r["line"])):
            print(f"  {r['file']}:{r['line']}")
            for err in dict.fromkeys(r["api_errors"]):
                print(f"      {err}")
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
