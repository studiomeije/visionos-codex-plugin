# Failure Categories

Use this file when classifying a failing result.

- Build failure: compile, link, module import, generated source, or build
  setting failure before tests execute. Route to `build-run-debug`.
- Test discovery or filter mismatch: no tests found, wrong scheme, wrong
  destination, stale `-only-testing:` identifier, or mismatch between the
  generated XCTest `XCTestCase` identifier and the Swift Testing `Test`
  identifier Xcode reports.
- Test-host launch failure: app install, runner attach, process start, or host
  scene bootstrapping failure before the first test body executes.
- Assertion or expectation failure: deterministic mismatch once the app runs.
  In XCTest, classify from the first assertion failure or `XCTIssue` associated
  with the failing `XCTestCase`; in Swift Testing, classify from the first
  `#expect` failure or thrown `#require`.
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
  `XCTIssue` records, `XCTAttachment` artifacts, Swift Testing expectation
  failures, and crash records.
- Simulator `log show` or `log stream` output proves privacy, entitlement,
  process launch, and app lifecycle messages that may not appear in the test
  assertion.
- XCTest `XCTContext.runActivity(named:block:)` entries help separate long
  simulator flows into the step that failed; inspect the activity name before
  blaming unrelated product logic.
- XCTest `XCTAttachment` entries can carry screenshots, files, and logs; inspect
  them before rerunning a visionOS Simulator UI or integration failure.
- Swift Testing `#require` failures are stop points. Treat later missing
  evidence as a consequence of the requirement throwing unless another log
  proves a separate issue.

## VisionOS Simulator Classification Rules

- If boot, install, runner attach, process start, or scene setup fails before
  the first `XCTestCase` method or Swift Testing `Test` function executes,
  classify as simulator, host-app, destination, privacy, entitlement, or
  lifecycle evidence.
- If a test body starts and then fails through an XCTest assertion, `XCTIssue`,
  Swift Testing `#expect`, or Swift Testing `#require`, classify as assertion,
  data setup, async timing, capability gap, or product logic based on that
  official test API evidence.
- If the same `-only-testing:` scope alternates between passing and timing out
  without a stable `XCTIssue` or Swift Testing expectation failure, mark it as
  async timing or flake and rerun with narrower logging.

## API Anchor Pointer

For XCTest and Swift Testing documentation identifiers, load
[`harness-detection.md`](harness-detection.md). Keep this file focused on
classification.
