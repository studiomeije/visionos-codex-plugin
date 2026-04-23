# /build-and-run-visionos-app

Build, install, launch, or debug a local visionOS app. Start with the
`build-run-debug` skill and use XcodeBuildMCP as the primary path. Use the
project-local `script/build_and_run.sh` fallback only when the user wants a
persistent Codex `Run` button or XcodeBuildMCP is unavailable.

## Arguments

- `scheme`: Xcode scheme name, if known
- `workspace`: path to `.xcworkspace`, if known
- `project`: path to `.xcodeproj`, if known
- `product`: SwiftPM executable or app product name, if known
- `mode`: `run`, `debug`, `logs`, `telemetry`, or `verify` (optional, default: `run`)
- `app_name`: app or process name to stop before relaunching, if known

## Workflow

1. Route through the real plugin skill first.
   - Use `../skills/build-run-debug/SKILL.md` for project discovery,
     XcodeBuildMCP defaults, simulator choice, build, install, launch, logs,
     and LLDB.
   - Use `../skills/swiftpm-visionos/SKILL.md` only for package-first work that
     does not have an app-producing Xcode scheme.

2. Detect the project shape and choose the native visionOS app target.
   - Prefer the app-producing scheme over helper targets.
   - If the repo is ambiguous, explain the choice before running anything.

3. Use XcodeBuildMCP as the default path.
   - Read current session defaults, then set `projectPath` or `workspacePath`,
     `scheme`, `platform: "visionOS"`, and an Apple Vision Pro simulator
     destination when needed.
   - Prefer `build_run_sim` for the normal build-install-launch loop.
   - Use `build_sim` for compile-only checks.
   - Use launch, log capture, or debug attach only when the requested mode or
     failure needs runtime evidence.

4. Choose the simulator deliberately.
   - Prefer a booted Apple Vision Pro simulator.
   - Otherwise choose the latest available Apple Vision Pro simulator runtime.
   - Distinguish simulator work from device work if the user names a physical
     device or asks for signing-sensitive validation.

5. Fall back to the shell bootstrap only when needed.
   - If a project-local `./script/build_and_run.sh` already exists and clearly
     matches the active app target, use it.
   - Otherwise generate it with
     `plugins/build-visionos-apps/scripts/bootstrap_build_and_run.sh`.
   - Pass `--project` or `--workspace`, `--scheme`, and `--app-name` when the
     built app bundle name differs from the scheme.
   - Keep the generated script as a project-local entrypoint, not app source
     code.

6. Route follow-up failures to the right skill.
   - Use `../skills/signing-entitlements/SKILL.md` for privacy, capability, and
     signing failures.
   - Use `../skills/test-triage/SKILL.md` if the user is really asking about a
     failing test or a launch-time regression.
   - Use `../skills/telemetry/SKILL.md` when the task is to add or verify
     unified logging, signposts, or runtime instrumentation.
   - Use `../skills/visionos-ui-automation/SKILL.md` when a launched app needs
     screenshots, video, accessibility inspection, or keyboard-driven flows.

## Guardrails

- Prefer XcodeBuildMCP over the shell fallback.
- Do not treat macOS launch or iOS automation patterns as valid for visionOS.
- Do not assume a simulator failure is a code-signing issue.
- Keep the fallback script outside app source folders and do not rewrite an
  existing project run script unless the user asks for replacement.
- Do not invent a destination, scheme, or product name when the project shape
  can be inspected directly.
