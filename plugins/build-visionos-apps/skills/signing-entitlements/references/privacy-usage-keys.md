# visionOS Privacy Usage Keys

Use this file when the failure involves missing or incorrect `Info.plist`
strings.

Add only the keys that match the providers and APIs the app actually uses, and
each key must contain a human-readable purpose string.

## Official API Anchors

- `NSWorldSensingUsageDescription`: Apple Info.plist key for world-sensing
  data. Apple documents this as image tracking, plane detection, and scene
  reconstruction.
- `NSHandsTrackingUsageDescription`: Apple Info.plist key for hand-tracking
  data, including hand skeleton, wrist, and forearm position and location.
- `ARKitSession.AuthorizationType.worldSensing`: authorization for plane
  detection, scene reconstruction, and image tracking.
- `ARKitSession.AuthorizationType.handTracking`: authorization for detailed
  hand-tracking data.
- `ARKitSession.requestAuthorization(for:)` and
  `ARKitSession.queryAuthorization(for:)`: use the provider
  `requiredAuthorizations` values instead of guessing from feature names.

## Inspect The Built Bundle

```bash
plutil -p "<App.app>/Info.plist"
/usr/libexec/PlistBuddy -c "Print :NSWorldSensingUsageDescription" "<App.app>/Info.plist"
```

If Xcode generates `Info.plist`, source files can lie. Always inspect the built
app or the app inside the archive.

## Key Map

- `NSWorldSensingUsageDescription`: world-sensing data that requires
  `.worldSensing` authorization, including `PlaneDetectionProvider`,
  `SceneReconstructionProvider`, and `ImageTrackingProvider` usage. Do not add
  this key solely because the app uses `WorldTrackingProvider`, `WorldAnchor`,
  or device-pose queries; Apple states that world tracking, unlike world
  sensing, does not require authorization.
- `NSHandsTrackingUsageDescription`: hand skeleton, wrist, and forearm position
  and location data via `HandTrackingProvider` and `.handTracking`
  authorization.
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
- `ARKitSession.run(_:)` can trigger the authorization prompt if the supplied
  providers require authorization and the app has not already called
  `requestAuthorization(for:)`.
- Check `DataProvider.requiredAuthorizations` for the concrete provider types in
  use. Treat `.worldSensing` and `.handTracking` as separate authorization
  classes with separate usage strings.
- Placeholder text such as `TODO`, empty strings, or internal jargon should be
  treated as invalid for release even if local launch succeeds.
- Simulator prompts and physical-device prompts can diverge after prior grants.
  Reset simulator privacy state before concluding that a fixed key is ignored.
- A usage string does not grant capability access. If the provider requires a
  managed entitlement, inspect the signed entitlements and provisioning profile
  after confirming the string exists.
