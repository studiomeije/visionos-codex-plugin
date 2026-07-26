# XCTest And XCUITest Flows

Use this file for repeatable UI flows, accessibility assertions, and evidence
that should be owned by the test runner.

## Runner Choice

Use `xcodebuild test` with a visionOS simulator destination:

```bash
xcodebuild test \
  -workspace App.xcworkspace \
  -scheme App \
  -destination 'platform=visionOS Simulator,name=Apple Vision Pro' \
  -only-testing:AppUITests/LaunchFlowUITests/testLaunchFlow \
  -resultBundlePath ./artifacts/AppUITests.xcresult
```

Use the smallest target, suite, or test filter that can answer the question.
Route failing scopes through `test-triage`.

## App Launch

Make automation explicit with launch arguments and environment:

```swift
let app = XCUIApplication()
app.launchArguments += ["--ui-testing", "--scenario", "launch-flow"]
app.launchEnvironment["AUTOMATION_FIXTURE"] = "happy-path"
app.launch()
```

Keep launch flags deterministic and isolated from production behavior.

## Accessibility Assertions

Prefer accessibility identifiers for test lookup and labels for user-facing
accessibility semantics:

```swift
let start = app.buttons["startExperienceButton"]
XCTAssertTrue(start.waitForExistence(timeout: 5))
XCTAssertEqual(start.label, "Start Experience")
XCTAssertTrue(start.isEnabled)
```

Use XCUITest assertions for existence, hittability, enabled state, labels,
values, focusable controls, and modal/window transitions. Avoid relying on
external tree dumps as the source of truth.

## Screenshots In Test Results

Attach runner-owned screenshots when the test assertion needs visual context:

```swift
let screenshot = app.screenshot()
let attachment = XCTAttachment(screenshot: screenshot)
attachment.name = "Launch flow ready state"
attachment.lifetime = .keepAlways
add(attachment)
```

Use `simctl io screenshot` or `recordVideo` when you need artifacts outside the
test bundle or around a manually launched app.

## Spatial And Immersive Flows

For spatial gestures, immersive-space entry, entity motion, or scene resets,
prefer app-authored automation hooks that call the same application state
paths as the user-facing interaction:

```swift
#if DEBUG
Button("Run Spatial Sweep") {
    automationController.runSpatialSweep()
}
.accessibilityIdentifier("runSpatialSweepButton")
#endif
```

Then assert the resulting state through XCUITest, app logs, or a stable
debug-only status view. Do not use host-side coordinate gestures as proof of
spatial interaction behavior.

## Output To Capture

When reporting a UI test run, include:

- runner used: `xcodebuild`
- simulator destination or UDID
- focused target/filter
- assertion result and failure text, if any
- screenshot or result bundle path, when produced
