# Official Tooling Boundaries

Load this file first when choosing the automation path or checking local
tool availability.

## Preflight

Start from the same simulator and app instance used by the build/run evidence.
Use `xcodebuild` and `xcrun simctl` for deterministic build, test, simulator,
and capture workflows. Use `xcode` / `mcpbridge` when the task depends on
active Xcode session or debugger state.

Confirm the selected Xcode and local simulator commands before documenting a
flow:

```bash
xcode-select -p
xcrun xcodebuild -version
xcrun simctl list devices booted
xcrun simctl help io
xcrun simctl help ui
```

Resolve a specific Apple Vision Pro simulator UDID. Do not rely on `booted`
when multiple simulators are running.

```bash
UDID=$(xcrun simctl list devices booted | awk -F '[()]' '/Apple Vision Pro/ {print $2; exit}')
test -n "$UDID"
```

If more than one Apple Vision Pro simulator is booted, stop and choose the UDID
explicitly from `xcrun simctl list devices booted`.

## Preferred Path

- XCTest/XCUITest: UI flows, accessibility labels, focusability, element state,
  screenshots attached to test results, and repeatable assertions.
- `xcode` / `mcpbridge`: active Xcode debugger or device/session state that is
  already owned by a running Xcode instance.
- `xcodebuild`: builds and XCTest/XCUITest execution with result bundles.
- `xcrun simctl`: screenshots, video, display enumeration, UI appearance and
  content-size settings, URL opens, pasteboard setup, app launch arguments, and
  any hardware-button or HID-style operations shown by local `simctl help`.
- App-designed debug hooks: deterministic spatial gestures, immersive-space
  state changes, motion sweeps, scene resets, and other behaviors that the
  simulator cannot drive reliably from outside the app.

## Boundary

What works well:

- UI and accessibility assertions inside XCTest/XCUITest.
- Visual evidence from `xcrun simctl io screenshot` and `recordVideo`.
- Simulator setting sweeps with `xcrun simctl ui`.
- Launch-argument, environment-variable, pasteboard, and URL-scheme hooks.
- App-authored test controls for spatial or immersive state.

What does not map well:

- Host-side coordinate taps and swipes as proof of visionOS spatial behavior.
- Treating a screenshot as proof that a reducer, gesture, or telemetry event
  ran; pair visual evidence with tests or logs.
- Assuming hardware-button commands exist across Xcode releases. Check the
  local `xcrun simctl help io` output and use only operations listed there.
- External accessibility-tree dumps as the primary assertion source. Put those
  checks in XCUITest or use Accessibility Inspector manually during diagnosis.

## Manual Fallback

When an operation is not exposed by XCUITest, the official Xcode bridge, or local `simctl`,
say so directly. Use the Simulator UI or Accessibility Inspector only as a
manual diagnostic step, and record that the step was manual in the summary.
