# Reality Composer Pro Packages

Use this file when the package contains scene or asset bundles.

## Common Shape

A Reality Composer Pro package typically exposes a module such as
`RealityKitContent` with `realityKitContentBundle`.

Entity loading typically looks like:

```swift
let entity = try await Entity(named: "Scene", in: realityKitContentBundle)
```

## Official Package Resource APIs

- `PackageDescription.Target.resources`: the explicit resource list for one
  Swift package target.
- `PackageDescription.Resource`: a resource bundled with a Swift package target.
- `PackageDescription.Resource.process(_:localization:)`: applies
  platform-specific processing recursively to the resource path. Swift Package
  Manager may optimize supported resource types and copies unsupported file
  types when no optimization is available.
- `PackageDescription.Resource.copy(_:)`: copies the resource as-is. If the path
  is a directory, Swift Package Manager preserves that directory structure.

Swift Package Manager scopes resources to targets, like source files. A
resource declared for a target must live under that target's folder, or under
the target's custom `path`, and should be declared relative to that target
folder. Do not declare resources by reaching into a sibling app bundle or a
different package target.

## `.process` vs `.copy`

Use `.process` when platform resource processing is acceptable, such as for
ordinary images or asset folders that do not depend on an exact authored folder
layout.

Use `.copy` when authored Reality Composer Pro or USD resources must remain
untouched, when the loader depends on a stable directory name, or when folder
identity is part of the asset contract. This is the safer rule for preserving
authored `.rkassets`, `.realitycomposerpro`, `.usda`, or other USD-related files
and directories whose layout must survive bundling exactly.

Example target-scoped declaration:

```swift
.target(
  name: "RealityKitContent",
  resources: [
    .copy("Resources/AuthoringFolder")
  ]
)
```

## Practical Checks

- Confirm the target declares the asset resources.
- Confirm each declared resource path is inside the owning target folder.
- Confirm the resource rule matches the loader contract: `.process` for normal
  platform processing, `.copy` for authored folders that must keep their exact
  structure and names.
- Confirm the consuming app or package imports the generated module.
- Confirm `Package.swift` carries the expected visionOS minimum, usually
  `.visionOS(.v26)` for visionOS 26 plugin work.
- Use `xcodebuild` with an Apple Vision Pro Simulator destination when asset
  package code depends on generated RealityKit or visionOS SDK symbols.
- If asset edits do not appear, clean DerivedData or the package build products.
