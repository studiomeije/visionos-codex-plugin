# Build Matrix

Use this file when selecting the right build or test command.

## Choose The Narrowest Path

- `swift build`: fastest compile validation for host-runnable, platform-agnostic
  code.
- `swift test`: unit tests that do not need a visionOS runtime.
- `xcodebuild build -scheme <scheme> -destination 'platform=visionOS Simulator,name=Apple Vision Pro'`:
  when the code imports SwiftUI, RealityKit, ARKit, or other visionOS SDK
  symbols.

Prefer `build-run-debug` and XcodeBuildMCP once the task becomes an interactive
simulator loop instead of a package-shape or compile-target question.
