# Workflow Recipes

Use this file for end-to-end capture patterns.

Start each recipe only after the build/run step has launched the app on an
Apple Vision Pro simulator and you have the matching UDID.

## Resolve UDID

```bash
UDID=$(xcrun simctl list devices booted | awk -F '[()]' '/Apple Vision Pro/ {print $2; exit}')
test -n "$UDID"
```

## Screenshot

```bash
axe screenshot --udid "$UDID" --output ./artifacts/main-window.png
```

## Video

```bash
axe record-video --udid "$UDID" --output ./artifacts/flow.mp4 &
PID=$!
sleep 10
kill "$PID"
```

## Accessibility Dump

```bash
axe describe-ui --udid "$UDID" > ./artifacts/a11y.json
```

Check that the dump contains the expected visible labels before claiming the UI
is reachable. If the app has no stable accessibility labels, route to
`visionos-automation-app-design` guidance before adding brittle automation.

## Batch Keyboard Flow

```bash
axe batch --udid "$UDID" \
  --step 'key-combo --modifiers 227 --key 4' \
  --step 'type "Untitled"' \
  --step 'key 40'
```

## Motion-Aware Sweep

For spatial regressions, include at least one motion-exercising step driven by
an in-app debug hook or keyboard shortcut, then capture screenshot, video, and
logs around that sweep.

Use `telemetry` for the log proof; AXe should provide the visual or
accessibility artifact, not the unified-log assertion.
