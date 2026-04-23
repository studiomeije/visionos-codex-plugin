# Simulator Vs Device Behavior

Use this file when the same capability behaves differently on simulator and
device.

## Important Distinctions

- Simulator apps are built with `xrsimulator*` SDKs and `XRSimulator` platform
  metadata. They are not signed or provisioned like physical-device builds and
  cannot prove distribution readiness.
- Physical-device and archive builds use `xros*` SDKs and `XROS` platform
  metadata. They must be signed by an identity and profile that permit the
  requested entitlements.
- World tracking, hand tracking, room tracking, scene reconstruction, image
  tracking, object tracking, and main camera access may authorize on simulator
  yet return empty or stub data.
- Enterprise entitlements are not enforced the same way on simulator as on a
  physical Apple Vision Pro.
- Privacy usage strings are required on both simulator and device.

If the expected entitlements are embedded and the API still fails, the likely
causes are usually privacy configuration or simulator-versus-device behavior,
not a broken code signature.

## Classification Matrix

| Symptom | Likely Class | Next Check |
|---------|--------------|------------|
| Simulator install fails before launch | simulator bundle/build issue | Use `build-run-debug`; do not change distribution profiles first. |
| Simulator launches but provider returns no real data | simulator limitation or privacy state | Reset simulator privacy and test on device if the feature needs real sensors. |
| Device install fails before launch | device signing/profile issue | Inspect signed entitlements and embedded profile. |
| Device launches but ARKit authorization fails | privacy string, managed entitlement, user authorization, or provider support | Inspect `Info.plist`, signed entitlements, profile, and runtime authorization status. |
| Archive/export fails while Debug device build works | Release signing/export mismatch | Inspect archive app, export options, and distribution profile. |
| TestFlight upload rejects entitlements | distribution profile or App Store capability mismatch | Switch to `packaging-distribution` after collecting exported `.ipa` and validation output. |

## Commands

Simulator:

```bash
xcrun simctl install booted "<App.app>"
xcrun simctl privacy booted reset all <bundle-id>
```

Physical device:

```bash
xcrun devicectl list devices --json-output /tmp/visionos-devices.json
xcrun devicectl device install app \
  --device <device-id-or-name> \
  "<App.app>" \
  --json-output /tmp/visionos-install.json \
  --log-output /tmp/visionos-install.log
```

Build metadata:

```bash
plutil -p "<App.app>/Info.plist"
codesign -dvv --entitlements :- "<App.app>" 2>/dev/null
```

## Decision Rule

If simulator and device disagree, trust the physical-device or archive result
for entitlement and profile diagnosis. Trust simulator only for fast checks of
bundle shape, privacy prompt wiring, and local launch regressions.
