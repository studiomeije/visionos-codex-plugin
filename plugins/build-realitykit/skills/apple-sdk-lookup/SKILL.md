---
name: apple-sdk-lookup
description: Look up exact Apple API facts in the installed SDK instead of recalling them - does a type or member exist, what is its precise signature and defaults, which platforms and OS versions it is available on, and whether it is deprecated or unavailable. Use before writing code against RealityKit, SwiftUI, ARKit, USDKit, or any Apple framework on a beta SDK, and whenever a symbol fails to compile or a doc and the compiler disagree.
---

# Apple SDK Lookup

Signatures are not worth remembering on a beta SDK. The installed `.swiftinterface`
files are the ground truth and they are greppable in under a second. Check them
instead of trusting recall, a blog, or a reference page.

This answers: *does this symbol exist, what is its exact shape, and where is it
available?* It does **not** answer *what does it do* - the interfaces carry no
doc comments, and Xcode 27 ships no local `.doccarchive`. For semantics, use the
owning skill's notes or Apple's online documentation.

## Workflow

1. Resolve the SDK path once, then reuse it.
2. Grep the interfaces for the symbol.
3. Read the declaration, its extensions, and its availability attributes.
4. If the symbol is missing, search for the modern spelling before concluding it
   does not exist - visionOS often drops the `AR` prefix (`ARPlaneAnchor` on iOS
   is `PlaneAnchor` on visionOS).
5. When still unsure, compile a three-line probe. A typecheck is definitive.

## Resolve The SDK

```bash
SDK=$(xcrun --sdk xros --show-sdk-path)
xcrun --sdk xros --show-sdk-version
```

Collect every Swift interface once; most lookups are a grep over this list:

```bash
find -L "$SDK" -name "*.swiftinterface" > /tmp/ifaces.txt
wc -l < /tmp/ifaces.txt
```

`-L` is required. `--show-sdk-path` returns a versioned **symlink**
(`XROS27.0.sdk` -> `XROS.sdk`), and plain `find` will not descend it - it
returns zero results and looks like an empty SDK. If the count is 0, that is the
reason.

Interfaces live in three places, so search all of them rather than guessing:
`System/Library/Frameworks/<Name>.framework/Modules/`,
`System/Library/SubFrameworks/<Name>.framework/Modules/`, and
`usr/lib/swift/<Name>.swiftmodule/`.

## Does A Symbol Exist, And Where

```bash
grep -l "\bClothBodyComponent\b" $(cat /tmp/ifaces.txt) | sed 's|.*/||'
```

A hit in a **SubFramework** or an underscored module still means the symbol is
public and reachable - it is usually re-exported. `ClothBodyComponent` lives in
`RealityFoundationCloth`, and `ComputeNodeGraph` in `_RealityKit_ComputeGraph`,
yet both compile under plain `import RealityKit`. Confirm with a probe rather
than assuming an extra import is needed.

An underscored `_A_B` module name is a **cross-import overlay**: the symbol
appears only when both `A` and `B` are imported. `USDStageComponent` needs
`import RealityKit` *and* `import USDKit`.

## Get The Exact Signature

```bash
RF="$SDK/System/Library/Frameworks/RealityFoundation.framework/Modules/RealityFoundation.swiftmodule/arm64e-apple-xros.swiftinterface"
grep -n -A12 "public struct OpacityComponent" "$RF"
```

Members are frequently added in **extensions far from the main declaration**, so
a range-limited read of the struct body will miss them. Grep the whole file for
the member name before concluding a property does not exist:

```bash
grep -n "var shadow" "$RF"
```

That distinction matters: `shadow` exists, but on the `HasSpotLight` entity
protocol, not on `SpotLightComponent`.

## Check Availability And Deprecation

Availability attributes sit on the lines *above* a declaration:

```bash
grep -B6 "public struct BodyTrackingComponent" "$RF" | grep "@available"
```

Read them literally. `@available(visionOS, unavailable)` means the code will not
compile for an Apple Vision Pro target no matter what the docs say. Deprecation
renames usually name their replacement in the message.

## Enumerate A Type's Cases Or Static Values

```bash
grep -oE "static let [a-zA-Z]+: [A-Za-z:]*Reverb.[A-Za-z:]*Preset" "$RF" | sort -u
```

Use this before writing any `.someCase` - invented enum cases are the most common
way a plausible-looking snippet fails to compile.

## Definitive Check: Compile A Probe

```bash
cat > /tmp/probe.swift <<'EOF'
import RealityKit

@MainActor func probe(entity: Entity) throws {
    var shadow = SpotLightComponent.Shadow()
    shadow.depthBias = 0.01
    entity.components.set(shadow)
}
EOF
xcrun swiftc -typecheck -target arm64-apple-xros27.0 -sdk "$SDK" /tmp/probe.swift
```

Silence means the API is real and the call shape is right. This is the same check
`scripts/check_swift_snippets.py` runs over the documented snippets in this repo.

## Full Symbol Inventory

When a grep is not enough - to list every member of a large module - extract the
symbol graph. It is slow (tens of seconds), so prefer grep first:

```bash
xcrun swift-symbolgraph-extract -module-name RealityFoundation \
  -target arm64-apple-xros27.0 -sdk "$SDK" -output-dir /tmp/sg
```

## Guardrails

- Never report a signature from memory when the SDK is installed. Look it up.
- A missing grep hit is not proof of absence until you have tried the modern
  spelling, the SubFramework and `usr/lib/swift` locations, and a compile probe.
- The interfaces have no doc comments. Do not infer behavior or ordering
  semantics from a signature.
- Interface files show `Module::Type` qualification; write plain `Type` in code.
- Do not edit anything inside the SDK.
- Report the SDK version alongside any API claim, because a different Xcode beta
  can disagree.

## Output Expectations

Provide the SDK version checked, the exact declaration found (or the evidence of
absence), the availability line, and whether a compile probe confirmed it.
