# Failure Categories

Use this file when classifying a failing result.

- Build failure: compile, link, module import, generated source, or build
  setting failure before tests execute. Route to `build-run-debug`.
- Test discovery or filter mismatch: no tests found, wrong scheme, wrong
  destination, or stale `-only-testing:` identifier.
- Test-host launch failure: app install, runner attach, process start, or host
  scene bootstrapping failure before the first test body executes.
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

## Evidence Map

- XcodeBuildMCP action logs prove scheme, destination, install, launch, and the
  first failing test action.
- `.xcresult` bundles prove the failing test identifier, assertion text,
  attachments, and crash records.
- Simulator `log show` or `log stream` output proves privacy, entitlement,
  process launch, and app lifecycle messages that may not appear in the test
  assertion.
