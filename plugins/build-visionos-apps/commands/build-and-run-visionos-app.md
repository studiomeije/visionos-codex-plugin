# /build-and-run-visionos-app

Build, install, and launch a visionOS app using XcodeBuildMCP first. Use the
project-local `script/build_and_run.sh` fallback only when the user wants a
persistent Run button or the MCP cannot complete the workflow.

## Arguments

- `scheme`: Xcode scheme name, if known
- `workspace`: path to `.xcworkspace`, if known
- `project`: path to `.xcodeproj`, if known
- `product`: SwiftPM executable or app product name, if known
- `mode`: `run`, `debug`, `logs`, `telemetry`, or `verify` (optional, default: `run`)
- `app_name`: app or process name to stop before relaunching, if known

## Workflow

1. Detect the project shape and choose the native visionOS app target.
   - Prefer the app-producing scheme over helper targets.
   - If the repo is ambiguous, explain the choice before running anything.

2. Use XcodeBuildMCP as the default path.
   - Read the current session defaults.
   - Set `projectPath` or `workspacePath`, `scheme`, `platform: "visionOS"`,
     and a Vision Pro simulator destination when needed.
   - Prefer `build_run_sim` for the normal build-install-launch loop.

3. Choose the simulator deliberately.
   - Prefer a booted Apple Vision Pro simulator.
   - Otherwise choose the latest available Vision Pro simulator runtime.
   - Distinguish simulator work from device work if the user names a physical
     device or asks for signing-sensitive validation.

4. Use the narrowest MCP command for the job.
   - Use build-only flow for compile checks.
   - Use launch or log capture when the task is runtime-focused.
   - Use LLDB and simulator logs only when the failure is unclear from the
     build or launch result.

5. Fall back to the shell bootstrap only when needed.
   - Use `./script/build_and_run.sh` when the user wants a persistent Run
     button or the MCP path is unavailable.
   - Keep that script as a project-local entrypoint, not app source code.

6. Route follow-up failures to the right skill.
   - Use `../skills/build-run-debug/SKILL.md` for the full XcodeBuildMCP
     workflow, LLDB attach, log capture, and simulator debugging.
   - Use `../skills/signing-entitlements/SKILL.md` for privacy, capability, and
     signing failures.
   - Use `../skills/test-triage/SKILL.md` if the user is really asking about a
     failing test or a launch-time regression.

## Guardrails

- Prefer XcodeBuildMCP over the shell fallback.
- Do not treat macOS launch or iOS automation patterns as valid for visionOS.
- Do not assume a simulator failure is a code-signing issue.
- Keep the fallback script outside app source folders.
- Do not invent a destination, scheme, or product name when the project shape
  can be inspected directly.

