# Build Matrix

Use this file when selecting the right build or test command.

## Choose The Narrowest Path

- `swift build`: fastest compile validation for host-runnable, platform-agnostic
  code.
- `swift test`: unit tests that do not need a visionOS runtime.
- `xcodebuild build -scheme <scheme> -destination 'platform=visionOS Simulator,name=Apple Vision Pro'`:
  when the code imports SwiftUI, RealityKit, ARKit, or other visionOS SDK
  symbols.
- `xcodebuild test -scheme <scheme> -destination 'platform=visionOS Simulator,name=Apple Vision Pro'`:
  package tests that must compile or run against the visionOS simulator SDK.

## Developer Directory

Use the active Xcode by default. If `swift build` or `xcodebuild` cannot see
visionOS 26 APIs, verify the SDK set and use the beta developer directory as a
per-command fallback:

```bash
xcodebuild -showsdks | grep -i -E 'vision|xros'
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcodebuild -showsdks | grep -i -E 'vision|xros'
```

## Arm64 Simulator Validation

If a package build reaches the simulator linker and fails on missing `x86_64`
slices from a dependency, retry the visionOS simulator build with:

```bash
xcodebuild build \
  -scheme <PackageOrProductScheme> \
  -destination 'platform=visionOS Simulator,name=Apple Vision Pro' \
  ARCHS=arm64 ONLY_ACTIVE_ARCH=YES
```

Prefer `build-run-debug` and XcodeBuildMCP once the task becomes an interactive
simulator loop instead of a package-shape or compile-target question.
