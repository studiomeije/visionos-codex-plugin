# Xcode MCP Boundary

Use this file when choosing between the two MCP servers shipped by the plugin
and the shell fallback.

## Default Path: XcodeBuildMCP

Use XcodeBuildMCP for the plugin-owned, deterministic visionOS simulator loop:

- project and workspace discovery
- scheme listing and app-producing scheme selection
- Apple Vision Pro simulator listing and selection
- session defaults for project/workspace, scheme, platform, and destination
- build, install, launch, and relaunch
- launch logs and simulator log capture
- debugger-oriented simulator actions exposed by XcodeBuildMCP

This is the default because it does not depend on the user already having the
right Xcode window and session state open.

## Secondary Path: `xcode` / `mcpbridge`

Use the official Xcode MCP bridge only when the task depends on a running Xcode
instance or Xcode-provided state that the default path does not expose.

Good fits:

- interacting with an already-running Xcode debug session
- invoking LLDB commands against Xcode's active debugger state
- using Xcode-owned device interaction or session state exposed by the bridge
- diagnosing behavior that only reproduces in the user's current Xcode session

Do not use `xcode` / `mcpbridge` as the default build/run path unless it proves
the same project discovery, scheme, simulator, build, install, launch, logs,
tests, and debug-attach coverage as XcodeBuildMCP for the current task.

## Shell Fallback

Use direct shell tools when MCP is unavailable, incomplete, or sees different
SDK/runtime state than the local developer directory:

- `xcodebuild` for builds, tests, and result bundles
- `xcrun simctl` for simulator boot/install/launch/capture/control
- `log stream` for focused runtime logs
- `lldb` when a direct debugger fallback is needed

If XcodeBuildMCP cannot see the visionOS SDK or Apple Vision Pro simulator that
the shell can see under the selected developer directory, report the mismatch
and use the shell fallback for that verification.

## Summary Rule

Prefer this order:

1. XcodeBuildMCP for deterministic plugin-owned build/run/debug loops.
2. `xcode` / `mcpbridge` for active Xcode session state.
3. Shell tools for fallback, SDK/runtime mismatches, or explicit low-level
   control.
