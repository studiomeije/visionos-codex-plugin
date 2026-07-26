# Xcode Execution Boundaries

Use this file when choosing between the official Xcode MCP bridge and direct
first-party shell tools.

## Deterministic Path: Direct Tools

Use direct tools for a reproducible visionOS simulator loop that does not
depend on the state of an open Xcode window:

- project and workspace discovery
- scheme listing and app-producing scheme selection
- Apple Vision Pro simulator listing and selection
- build, install, launch, and relaunch
- launch logs and simulator log capture
- XCTest/XCUITest and result bundles
- direct LLDB attach when appropriate

Use `xcodebuild`, `xcrun simctl`, unified logging, and `lldb`, or a verified
project-local wrapper around those tools.

## Active Session Path: `xcode` / `mcpbridge`

Use the official Xcode MCP bridge when the task depends on a running Xcode
instance or Xcode-provided state.

Good fits:

- interacting with an already-running Xcode debug session
- invoking LLDB commands against Xcode's active debugger state
- using Xcode-owned device interaction or session state exposed by the bridge
- diagnosing behavior that only reproduces in the user's current Xcode session

Do not assume the bridge exposes every build, simulator, test, or logging
operation. Use direct tools for any missing capability.

## Direct Tool Set

Use:

- `xcodebuild` for builds, tests, and result bundles
- `xcrun simctl` for simulator boot/install/launch/capture/control
- `log stream` for focused runtime logs
- `lldb` when a direct debugger fallback is needed

If the bridge and shell see different SDK, simulator, or project state, report
the mismatch and use the path that exposes the state being verified.

## Summary Rule

Choose by ownership:

1. Direct tools for deterministic build, test, simulator, logging, and
   standalone debugger workflows.
2. `xcode` / `mcpbridge` for active Xcode session and Xcode-owned debugger
   state.
