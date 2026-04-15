# Verification

Use this file when confirming that the instrumentation actually fired.

## Verification Loop

1. Build and run via `build-run-debug`.
2. Capture focused launch or runtime logs.
3. Stream unified logs for the app subsystem or process.
4. Confirm the expected event fired exactly once or in a bounded sequence.
5. Remove or demote noisy temporary instrumentation.

## Useful Commands

```bash
log stream --style compact --predicate 'subsystem == "com.example.app"'
```

```bash
xcrun simctl spawn <udid> log stream --style compact --predicate 'subsystem == "com.example.app"'
```

## Checklist

- The app still builds after telemetry changes.
- The event can be filtered by process, subsystem, or category.
- No sensitive payloads were written to unified logs.
