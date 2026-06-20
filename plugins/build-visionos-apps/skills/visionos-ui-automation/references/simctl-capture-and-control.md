# simctl Capture And Control

Use this file for official simulator operations after the app has been built,
installed, and launched on the intended Apple Vision Pro simulator.

## Local Help First

`simctl` support varies by Xcode and runtime. Check local help before using a
subcommand in a reusable recipe:

```bash
xcrun simctl help
xcrun simctl help io
xcrun simctl help ui
xcrun simctl help launch
xcrun simctl help openurl
```

## Resolve The Simulator

```bash
UDID=$(xcrun simctl list devices booted | awk -F '[()]' '/Apple Vision Pro/ {print $2; exit}')
test -n "$UDID"
```

Use the explicit UDID in evidence commands. `booted` is acceptable only when
you have confirmed that exactly one simulator is running.

## Screenshots

```bash
mkdir -p ./artifacts
xcrun simctl io "$UDID" screenshot --type=png --mask=black ./artifacts/main-window.png
```

Use `xcrun simctl io "$UDID" enumerate` to list displays before selecting a
non-default display with `--display`.

## Video

```bash
mkdir -p ./artifacts
xcrun simctl io "$UDID" recordVideo --codec=h264 --mask=black --force ./artifacts/flow.mp4 &
REC_PID=$!
sleep 10
kill -INT "$REC_PID"
wait "$REC_PID"
```

`simctl` writes "Recording started" to stderr after the first frame is
processed. For precise capture windows, redirect stderr and wait for that line
before starting the action under test.

## Simulator UI Settings

Use `simctl ui` for accessibility and appearance sweeps around a launched app:

```bash
xcrun simctl ui "$UDID" appearance dark
xcrun simctl ui "$UDID" increase_contrast enabled
xcrun simctl ui "$UDID" content_size accessibility-large
```

Record the values you changed and restore them when the task needs a clean
rerun.

## Launch Arguments And Environment

For app-designed automation paths, relaunch with explicit arguments or
environment variables:

```bash
SIMCTL_CHILD_AUTOMATION_SCENARIO=spatial-sweep \
  xcrun simctl launch --terminate-running-process "$UDID" com.example.App --ui-testing
```

Use `xcrun simctl appinfo "$UDID" com.example.App` when you need to confirm an
installed bundle identifier before launching.

## URLs And Pasteboard

URL schemes and universal links are useful debug hooks when the app owns the
automation route:

```bash
xcrun simctl openurl "$UDID" "example-app://automation/run-spatial-sweep"
```

Seed the simulator pasteboard when a flow intentionally consumes pasted text:

```bash
printf '%s' "Test input" | xcrun simctl pbcopy "$UDID"
```

Pasteboard setup does not type into the app by itself. Drive the consuming UI
through XCUITest or an app-authored hook.

## Hardware Buttons And HID-Style Operations

Use only operations shown by local `xcrun simctl help io` or another local
`simctl help` page. If the help output does not list a hardware-button or HID
operation for the active Xcode, do not invent one. Put the behavior in
XCUITest with `XCUIDevice` when supported by the runner, or call out the lack of
an unattended local path.
