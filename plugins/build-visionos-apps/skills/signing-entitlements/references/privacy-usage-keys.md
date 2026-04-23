# visionOS Privacy Usage Keys

Use this file when the failure involves missing or incorrect `Info.plist`
strings.

Add only the keys that match the providers and APIs the app actually uses, and
each key must contain a human-readable purpose string.

## Inspect The Built Bundle

```bash
plutil -p "<App.app>/Info.plist"
/usr/libexec/PlistBuddy -c "Print :NSWorldSensingUsageDescription" "<App.app>/Info.plist"
```

If Xcode generates `Info.plist`, source files can lie. Always inspect the built
app or the app inside the archive.

## Key Map

- `NSWorldSensingUsageDescription`: world tracking, plane detection, scene
  reconstruction, image tracking, room tracking, object tracking, world anchors,
  and other ARKit world-sensing data.
- `NSHandsTrackingUsageDescription`: hand skeleton, wrist, and forearm data via
  `HandTrackingProvider`.
- `NSAccessoryTrackingUsageDescription`: accessory position and orientation data
  via accessory tracking providers.
- `NSMainCameraUsageDescription`: main-camera frame access on Apple Vision Pro.
  Main-camera access also requires the managed entitlement and an enterprise
  license path when the API requires one.
- `NSEnterpriseMCAMUsageDescription`: legacy main-camera usage string used by
  visionOS 2.0 through 2.3. Include it only when the app supports those
  runtimes or the built artifact is being validated for them.
- `NSCameraUsageDescription`: only for camera APIs that still use the general
  camera permission. Do not substitute it for `NSMainCameraUsageDescription`.

## Diagnosis Notes

- Missing usage strings usually fail at first access or authorization time, not
  at compile time.
- Placeholder text such as `TODO`, empty strings, or internal jargon should be
  treated as invalid for release even if local launch succeeds.
- Simulator prompts and physical-device prompts can diverge after prior grants.
  Reset simulator privacy state before concluding that a fixed key is ignored.
- A usage string does not grant capability access. If the provider requires a
  managed entitlement, inspect the signed entitlements and provisioning profile
  after confirming the string exists.
