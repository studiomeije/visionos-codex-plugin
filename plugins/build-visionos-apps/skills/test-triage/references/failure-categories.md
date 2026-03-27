# Failure Categories

Use this file when classifying a failing result.

- Build failure: compile, link, module import, generated source, or build
  setting failure before tests execute. Route to `build-run-debug`.
- Assertion or expectation failure: deterministic mismatch once the app runs.
- Crash or signal: `SIGABRT`, `EXC_BAD_ACCESS`, `fatalError`, or abrupt
  termination. Route to `build-run-debug` for richer crash context.
- Async timing or flake: timeout or ordering issue that may pass on retry.
- Simulator or environment issue: boot, install, or service instability not
  explained by product logic.
- Missing privacy key or entitlement: route to `signing-entitlements`.
- Capability unavailable on simulator: classify as device-only when evidence
  matches.
- Host-app or scene lifecycle problem: route to `build-run-debug`, and to
  `telemetry` if event ordering needs proof.
