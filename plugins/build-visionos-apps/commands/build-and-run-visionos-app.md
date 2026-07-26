# /build-and-run-visionos-app

Build, install, launch, or debug a local visionOS app. Start with the
`build-run-debug` skill. Use the official Xcode bridge for active Xcode session
state, direct `xcodebuild` and `simctl` for deterministic shell work, and a
project-local `script/build_and_run.sh` for a persistent Codex `Run` button.

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
     simulator choice, build, install, launch, logs, and LLDB.
   - Use `../skills/swiftpm-visionos/SKILL.md` only for package-first work that
     does not have an app-producing Xcode scheme.

2. Detect the project shape and choose the native visionOS app target.
   - Prefer the app-producing scheme over helper targets.
   - If the repo is ambiguous, explain the choice before running anything.

3. Choose the first-party execution path.
   - Use `xcode` / `mcpbridge` when the task depends on active Xcode session or
     debugger state.
   - Use `xcodebuild` for compile and test actions.
   - Use `xcrun simctl` for simulator boot, install, launch, termination,
     screenshots, video, and focused simulator control.
   - Use unified logging and LLDB only when the requested mode or failure needs
     runtime evidence.

4. Choose the simulator deliberately.
   - Prefer a booted Apple Vision Pro simulator.
   - Otherwise choose the latest available Apple Vision Pro simulator runtime.
   - Distinguish simulator work from device work if the user names a physical
     device or asks for signing-sensitive validation.

5. Use the shell bootstrap when a repeatable entrypoint is useful.
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
   - Use `realitykit-observability` when a running RealityKit app needs
     structured logs, signposts, or runtime-event verification.
   - Use `../skills/visionos-ui-automation/SKILL.md` when a launched app needs
     screenshots, video, accessibility inspection, or keyboard-driven flows.

## Guardrails

- Prefer first-party Xcode tools and keep the selected path explicit.
- Do not treat macOS launch or iOS automation patterns as valid for visionOS.
- Do not assume a simulator failure is a code-signing issue.
- Keep the run script outside app source folders and do not rewrite an
  existing project run script unless the user asks for replacement.
- Do not invent a destination, scheme, or product name when the project shape
  can be inspected directly.
