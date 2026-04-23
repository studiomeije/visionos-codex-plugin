# Verification

Use this file when confirming that the instrumentation actually fired.

## Verification Loop

1. Build and run via `build-run-debug`, preferably through XcodeBuildMCP.
2. Record the scheme, destination, simulator UDID, launch result, and any app
   stdout/stderr surfaced by the build/run tool.
3. Stream unified logs for the app process, subsystem, or category.
4. Confirm the expected event fired exactly once or in a bounded sequence.
5. Check whether missing events are explained by launch failure, entitlement or
   privacy denial, scene lifecycle, or code path not reached.
6. Remove or demote noisy temporary instrumentation.

## XcodeBuildMCP Evidence

When XcodeBuildMCP launched the app, use its action output as the first source
of truth for:

- the selected scheme and Apple Vision Pro simulator destination
- build, install, and launch status
- simulator UDID
- launch arguments and environment, if supplied
- app stdout/stderr surfaced by the runner

Then use unified logs for `Logger` / `OSLog` events. XcodeBuildMCP launch
success does not prove that a specific unified-log event fired.

## Useful Commands

```bash
log stream \
  --style compact \
  --predicate 'subsystem == "com.example.app"'
```

```bash
xcrun simctl spawn <udid> log stream \
  --style compact \
  --predicate 'subsystem == "com.example.app"'
```

Narrow by process and category when multiple processes share the subsystem:

```bash
xcrun simctl spawn <udid> log stream \
  --style compact \
  --predicate 'process == "<AppProcess>" AND subsystem == "com.example.app" AND category == "ImmersiveSpace"'
```

Use recent history after a short reproduction:

```bash
xcrun simctl spawn <udid> log show \
  --last 2m \
  --style compact \
  --predicate 'process == "<AppProcess>" AND subsystem == "com.example.app"'
```

## Checklist

- The app still builds after telemetry changes.
- The event can be filtered by process, subsystem, or category.
- The log count and order match the lifecycle being verified.
- Missing logs were checked against launch output and simulator denials.
- No sensitive payloads were written to unified logs.
