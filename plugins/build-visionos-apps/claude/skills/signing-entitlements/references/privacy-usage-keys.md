# visionOS Privacy Usage Keys

Use this file when the failure involves missing or incorrect `Info.plist`
strings.

Add only the keys that match the providers and APIs the app actually uses, and
each key must contain a human-readable purpose string.

- `NSWorldSensingUsageDescription`: world tracking, plane detection, scene
  reconstruction, image tracking, room tracking, and anchor data.
- `NSHandsTrackingUsageDescription`: hand tracking via
  `HandTrackingProvider`.
- `NSMainCameraUsageDescription`: consumer main-camera access on Apple Vision
  Pro.
- `NSCameraUsageDescription`: general camera access flows that still apply.
- `NSAccessoryTrackingUsageDescription`: accessory tracking on Apple Vision Pro.
- `NSEnterpriseMCAMUsageDescription`: enterprise main-camera access when the
  managed entitlement is granted.
