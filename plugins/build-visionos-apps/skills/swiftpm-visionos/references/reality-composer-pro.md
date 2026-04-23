# Reality Composer Pro Packages

Use this file when the package contains scene or asset bundles.

## Common Shape

A Reality Composer Pro package typically exposes a module such as
`RealityKitContent` with `realityKitContentBundle`.

Entity loading typically looks like:

```swift
let entity = try await Entity(named: "Scene", in: realityKitContentBundle)
```

## Practical Checks

- Confirm the target declares the asset resources.
- Confirm the consuming app or package imports the generated module.
- Confirm `Package.swift` carries the expected visionOS minimum, usually
  `.visionOS(.v26)` for visionOS 26 plugin work.
- Use `xcodebuild` with an Apple Vision Pro Simulator destination when asset
  package code depends on generated RealityKit or visionOS SDK symbols.
- If asset edits do not appear, clean DerivedData or the package build products.
