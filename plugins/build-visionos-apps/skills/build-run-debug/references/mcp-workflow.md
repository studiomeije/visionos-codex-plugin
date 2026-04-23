# MCP Workflow

Use this file when XcodeBuildMCP is available.

## Detect Availability

Try `mcp__XcodeBuildMCP__session-show-defaults`. If it succeeds, the MCP path
is available for this session.

## Core MCP Loop

1. `session-show-defaults`
2. `discover_projs` when the workspace or project path is unclear
3. `list_schemes`
4. Choose the app-producing scheme, not a helper package or test target
5. `list_sims`
6. Choose an Apple Vision Pro Simulator with a visionOS 26 runtime
7. `session-set-defaults`
8. `build_sim` or `build_run_sim`
9. `launch_app_logs_sim`, log capture, or debugger tools when diagnosis needs
   more than a normal run

## Session Defaults

Set defaults from inspected facts:

- `workspacePath` when the repo has an app workspace that owns the scheme.
- `projectPath` when the app is a plain `.xcodeproj`.
- `scheme` for the app-producing target.
- `platform: "visionOS"`.
- A simulator destination that resolves to Apple Vision Pro Simulator, not an
  iPhone, iPad, macOS, or generic unavailable destination.

If the MCP cannot see a visionOS 26 SDK or Apple Vision Pro Simulator that the
shell can see under `/Applications/Xcode-beta.app/Contents/Developer`, report
that as an MCP environment mismatch and use the shell fallback for the current
verification.

## Architecture Notes

On Apple silicon, some vendor frameworks ship only arm64 simulator slices. If
the failure is a missing `x86_64` slice for a simulator build, retry through
the shell fallback with `ARCHS=arm64 ONLY_ACTIVE_ARCH=YES` before changing app
code.

## Common Tool Set

- `mcp__XcodeBuildMCP__session-show-defaults`
- `mcp__XcodeBuildMCP__discover_projs`
- `mcp__XcodeBuildMCP__list_schemes`
- `mcp__XcodeBuildMCP__list_sims`
- `mcp__XcodeBuildMCP__session-set-defaults`
- `mcp__XcodeBuildMCP__build_run_sim`
- `mcp__XcodeBuildMCP__build_sim`
- `mcp__XcodeBuildMCP__launch_app_sim`
- `mcp__XcodeBuildMCP__launch_app_logs_sim`
- `mcp__XcodeBuildMCP__start_sim_log_cap`
- `mcp__XcodeBuildMCP__stop_sim_log_cap`
- `mcp__XcodeBuildMCP__debug_attach_sim`
- `mcp__XcodeBuildMCP__debug_stack`
- `mcp__XcodeBuildMCP__debug_variables`
