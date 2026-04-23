---
name: swiftpm-visionos
description: Build, run, and test Swift packages that target visionOS, including pure-SwiftPM libraries, cross-platform packages with a visionOS condition, and Reality Composer Pro (`RealityKitContent`) asset packages. Use when the work is package-first, when Xcode is overkill, or when `xcodebuild` needs a Swift package destination.
---

# SwiftPM for visionOS

## Quick Start

Use this skill when `Package.swift` is the primary entrypoint, when a library
has visionOS-specific behavior behind a platform condition, or when a Reality
Composer Pro package is the artifact of interest. For app projects driven by
an `.xcodeproj` or `.xcworkspace`, stay in `build-run-debug` instead.

1. Decide whether the work is package structure, build command selection,
   Reality Composer Pro packaging, or diagnostics.
2. Load only the matching reference files.
3. Use package-native SwiftPM checks for host-compatible code, and use an
   Apple Vision Pro Simulator `xcodebuild` destination for visionOS SDK checks.
4. Route back to `build-run-debug` once the task becomes app-runner or
   simulator-launch focused.

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/package-shape.md`](references/package-shape.md) | When checking `Package.swift`, products, targets, resources, or `platforms`. |
| [`references/build-matrix.md`](references/build-matrix.md) | When deciding between `swift build`, `swift test`, and `xcodebuild` against a package. |
| [`references/reality-composer-pro.md`](references/reality-composer-pro.md) | When the package exposes `RealityKitContent`, `.rkassets`, `.usdz`, or other Reality Composer Pro assets. |
| [`references/diagnostics.md`](references/diagnostics.md) | When classifying failures such as platform mismatch, module resolution, resource bundling, linker issues, or runtime-only problems. |

## Workflow

1. Inspect `Package.swift` and identify products, targets, tests, and resource
   bundles.
2. Choose the narrowest build or test path that answers the question.
3. Load the Reality Composer Pro reference only if the package actually owns
   scene or asset bundles.
4. Classify the result precisely before escalating out of the skill.

## When To Switch Skills

- Switch to `build-run-debug` when the work moves from package shape to
  running the app in the Apple Vision Pro simulator.
- Switch to `shadergraph-editor` or `usd-editor` when a Reality Composer Pro
  asset needs authoring or inspection rather than package wiring.
- Switch to `signing-entitlements` when entitlements or privacy keys must be
  propagated through package-declared target dependencies to the host app.

## Guardrails

- Do not assume an app bundle exists in a pure package workflow.
- Do not silently downgrade or remove `.visionOS(.v26)` from the `platforms:`
  list unless the repo intentionally supports an older minimum.
- Explain when the package is library-only and therefore not directly
  runnable on visionOS.
- Keep resource paths inside the package instead of reaching into app-level
  bundles.
- Treat arm64 simulator and Xcode beta requirements as build-environment facts,
  not reasons to rewrite package code first.

## Output Expectations

Provide:
- the package products you found and their platform list
- the command you ran (`swift build`, `swift test`, or `xcodebuild` against
  the package)
- any Xcode beta or arm64 simulator override used
- whether build, run, or test succeeded
- the top blocker if not
- explicit routing back to `build-run-debug` or a spatial skill for the next
  step
