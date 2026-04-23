# Post-Build Test Verification

Use this file after the app builds and the question is whether the visionOS test
run actually passed, failed in product code, or failed in the simulator/test
infrastructure.

## Evidence Order

1. XcodeBuildMCP action output: scheme, destination, simulator UDID, build
   result, install result, test-host launch, and the first concrete test
   failure.
2. `xcodebuild test` output or `.xcresult` bundle: failing target, suite, test
   identifier, assertion text, attachments, and crash records.
3. Simulator logs: process, subsystem, category, privacy or entitlement denials,
   scene lifecycle messages, and test-host launch messages.

Do not treat "build succeeded" as "tests verified". The test action must run on
the intended Apple Vision Pro simulator and report a test result.

## Focused Command Shape

```bash
xcodebuild test \
  -scheme <Scheme> \
  -destination 'platform=visionOS Simulator,name=Apple Vision Pro' \
  -only-testing:<TestTarget>/<SuiteOrCase>/<testName> \
  -resultBundlePath ./artifacts/<Scheme>-tests.xcresult
```

For Swift Testing targets, copy the exact generated identifier from the test
report when the suite or test display name differs from the source spelling.

## Log Checks

Use simulator logs when the failure is a launch, host-app, privacy, entitlement,
or lifecycle problem rather than a plain assertion mismatch.

```bash
xcrun simctl spawn <udid> log show \
  --last 5m \
  --style compact \
  --predicate 'process == "<AppOrTestHostProcess>"'
```

For live investigation while rerunning:

```bash
xcrun simctl spawn <udid> log stream \
  --style compact \
  --predicate 'process == "<AppOrTestHostProcess>"'
```

## Classification Notes

- "No tests found" is usually a harness or filter mismatch, not a passing test.
- Test-host launch failures belong with `build-run-debug` unless the test log
  already proves a missing entitlement or privacy key.
- A simulator crash before the first test body runs is not the same class as an
  assertion failure inside the test body.
- If XcodeBuildMCP provides the action log and result bundle path, cite those
  artifacts directly instead of broadening the test run first.
