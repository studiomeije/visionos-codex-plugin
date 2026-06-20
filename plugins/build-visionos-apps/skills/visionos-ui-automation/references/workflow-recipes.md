# Workflow Recipes

Use this file for end-to-end capture patterns.

Start each simulator-artifact recipe only after the build/run step has launched
the app on an Apple Vision Pro simulator and you have the matching UDID. For UI
assertions, prefer launching from XCUITest instead.

## Resolve UDID

```bash
UDID=$(xcrun simctl list devices booted | awk -F '[()]' '/Apple Vision Pro/ {print $2; exit}')
test -n "$UDID"
```

## Screenshot

```bash
mkdir -p ./artifacts
xcrun simctl io "$UDID" screenshot --type=png --mask=black ./artifacts/main-window.png
```

## Video

```bash
mkdir -p ./artifacts
xcrun simctl io "$UDID" recordVideo --codec=h264 --mask=black --force ./artifacts/flow.mp4 &
REC_PID=$!
sleep 10
kill -INT "$REC_PID"
wait "$REC_PID"
```

## XCUITest Accessibility Check

```swift
func testLaunchSurfaceAccessibility() {
    let app = XCUIApplication()
    app.launchArguments += ["--ui-testing"]
    app.launch()

    let start = app.buttons["startExperienceButton"]
    XCTAssertTrue(start.waitForExistence(timeout: 5))
    XCTAssertEqual(start.label, "Start Experience")
    XCTAssertTrue(start.isEnabled)
}
```

If the app has no stable identifiers or labels, route to
`visionos-automation-app-design` guidance before adding brittle tests.

## XCUITest Flow With Screenshot Attachment

```swift
func testLaunchFlowReadyState() {
    let app = XCUIApplication()
    app.launchArguments += ["--ui-testing", "--scenario", "ready-state"]
    app.launch()

    app.buttons["startExperienceButton"].tap()
    XCTAssertTrue(app.staticTexts["readyStateLabel"].waitForExistence(timeout: 10))

    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "Ready state"
    attachment.lifetime = .keepAlways
    add(attachment)
}
```

## Motion-Aware Sweep

For spatial regressions, include at least one motion-exercising step driven by
an in-app debug hook, URL route, launch flag, or XCUITest-visible control, then
capture screenshot, video, and logs around that sweep.

```bash
xcrun simctl openurl "$UDID" "example-app://automation/run-spatial-sweep"
```

Use `telemetry` for the log proof; simulator screenshots or videos provide the
visual artifact, not the unified-log assertion.

## Simulator Settings Sweep

```bash
xcrun simctl ui "$UDID" appearance dark
xcrun simctl ui "$UDID" increase_contrast enabled
xcrun simctl ui "$UDID" content_size accessibility-extra-large
xcrun simctl io "$UDID" screenshot --type=png --mask=black ./artifacts/high-contrast.png
```

Restore settings before a baseline rerun when the task depends on default
simulator state.
