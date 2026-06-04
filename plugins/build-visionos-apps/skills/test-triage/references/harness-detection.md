# Harness Detection

Use this file when identifying how the target is tested.

Start by checking source imports and the test action output. A target can mix
XCTest and Swift Testing files, but filters still need the generated test
identifier that Xcode reports.

```bash
rg -n 'import (XCTest|Testing)|XCTestCase|@Test|@Suite' <test-path>
```

## XCTest

- Files import `XCTest`
- Test types subclass `XCTestCase`
- Methods are named `test...`
- Assertions and recorded failures appear as XCTest issues in the result
  bundle; use `XCTIssue` details to classify the first failure.
- Long UI or integration tests may group simulator steps with
  `XCTContext.runActivity(named:block:)`.
- Simulator screenshots, logs, files, and other proof should be attached with
  `XCTAttachment` when the test creates evidence.
- Filter shape:

```text
-only-testing:MyTargetTests/MyClass/testMethod
```

## Swift Testing

- Files import `Testing`
- Tests use the `Test` macro through `@Test` and optional suite grouping with
  `@Suite`
- Assertions use `#expect` when the test can keep running and `#require` when
  the failed condition should stop the test or unwrap a required value
- Filter shape:

```text
-only-testing:MyTargetTests/MySuite/myTest()
```

Both harnesses still run through `xcodebuild test` against the visionOS
simulator unless the project deliberately split them into separate schemes.
Do not mix XCTest assertions, `XCTContext`, `XCTAttachment`, or `XCTIssue` into
a Swift Testing `@Test` body, and do not use Swift Testing macros inside an
`XCTestCase` method.

## VisionOS Simulator Triage

- Capture the exact Xcode destination and simulator UDID before rerunning; a
  filter that passes on one visionOS Simulator runtime can still fail to
  discover tests on another destination.
- If the test runner fails before an `XCTestCase` method or Swift Testing
  `@Test` function starts, classify the failure as build, install, launch,
  destination, privacy, entitlement, or scene lifecycle evidence rather than an
  assertion failure.
- If the first concrete failure is an XCTest assertion or `XCTIssue`, classify
  from that issue and inspect any `XCTAttachment` entries before rerunning.
- If the first concrete failure is a Swift Testing `#expect` or `#require`,
  classify from the expectation text and generated test identifier that Xcode
  reports.

## Result Clues

- XCTest failures usually report a class and method.
- Swift Testing failures usually report a suite and test function or generated
  display name.
- If `-only-testing:` reports no matching tests, copy the identifier from the
  last successful discovery or result report before changing code.

## Official Apple API Anchors

- XCTest: `XCTestCase`, `XCTContext.runActivity(named:block:)`,
  `XCTAttachment`, `XCTIssue`
- Swift Testing: `Testing`, `Test`, `Suite`, `#expect`, `#require`
- Test execution: `xcodebuild test`, `-only-testing:`, `.xcresult`
