# /build-and-run-visionos-app

Build, install, and launch a visionOS app using XcodeBuildMCP.

## Arguments

$ARGUMENTS - Optional: scheme name, workspace path, or mode (run/debug/logs)

## Workflow

1. Detect the project shape and choose the native visionOS app target
   - Prefer the app-producing scheme over helper targets
   - If the repo is ambiguous, explain the choice before running anything

2. Use XcodeBuildMCP as the build path
   - Set projectPath or workspacePath, scheme, platform visionOS
   - Target Apple Vision Pro simulator destination
   - Use build_run_sim for the normal build-install-launch loop

3. Choose the simulator deliberately
   - Prefer a booted Apple Vision Pro simulator
   - Otherwise choose the latest available Vision Pro simulator runtime

4. Use the narrowest MCP command for the job
   - Build-only for compile checks
   - Launch or log capture for runtime-focused tasks

5. Route follow-up failures to the right skill
   - Use skills/build-run-debug for full XcodeBuildMCP workflow
   - Use skills/signing-entitlements for privacy, capability, and signing failures
   - Use skills/debugging-triage for runtime issues

## Guardrails

- Prefer XcodeBuildMCP over shell fallbacks
- Do not treat macOS launch or iOS patterns as valid for visionOS
- Do not assume a simulator failure is a code-signing issue
- Do not invent a destination, scheme, or product name when the project can be inspected
