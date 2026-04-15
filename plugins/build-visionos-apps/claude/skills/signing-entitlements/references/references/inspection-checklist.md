# Signing And Entitlements Reference Map

Load this file first when you need the inspection order or the core command set.

## Inspection Order

1. Identify the target: simulator, device, or distribution artifact.
2. Inspect built entitlements:

```bash
codesign -dvvv --entitlements :- <app-or-binary>
```

3. Inspect `Info.plist` privacy strings:

```bash
plutil -p <path-to-info-plist>
```

4. Check local identities:

```bash
security find-identity -p codesigning -v
```

5. Cross-check build settings when needed:

```bash
xcodebuild -showBuildSettings -scheme <scheme> -configuration Debug
```

## Failure Classes

- Simulator signing issue
- Device or distribution signing issue
- Capability mismatch
- Privacy mismatch
- Non-signing issue that should route to `build-run-debug`
