# Enterprise Entitlements

Use this file when the app depends on managed ARKit capabilities.

Enterprise ARKit APIs require a managed entitlement issued by Apple. A build
can still succeed without them, but the provider will fail authorization at
runtime.

Confirm the entitlement is present in the provisioning profile, not only in the
project capability pane.

## Inspect The Profile And Signed App

```bash
codesign -dvv --entitlements :- "<App.app>" 2>/dev/null
security cms -D -i "<App.app>/embedded.mobileprovision" > /tmp/visionos-profile.plist
plutil -extract Entitlements xml1 -o - /tmp/visionos-profile.plist
```

The target `.entitlements` file is only the request. The profile is the grant.
The signed app is the result that device install, archive export, and App Store
Connect validate.

## Common Managed ARKit Entitlements

- `com.apple.developer.arkit.main-camera-access.allow`
- `com.apple.developer.arkit.object-tracking-parameter-adjustment.allow`
- `com.apple.developer.arkit.barcode-detection.allow`
- `com.apple.developer.arkit.camera-region.allow`
- `com.apple.developer.arkit.shared-coordinate-space.allow`

This list is not permission to add keys blindly. Verify the exact entitlement
against Apple's current documentation, the developer-account capability, and the
generated provisioning profile. If a key appears in code comments or old docs
but not in the profile, treat it as unavailable for that team/profile.

## What Not To Misdiagnose

- `NSMainCameraUsageDescription` or another usage string missing from
  `Info.plist` is a privacy failure, not a signing failure.
- A missing enterprise license file or invalid license payload is a runtime or
  packaging problem after signing/profile checks pass.
- Simulator success does not prove the managed entitlement is valid for a
  physical Apple Vision Pro.
- Scene reconstruction and world tracking use `NSWorldSensingUsageDescription`;
  do not add a speculative scene-understanding entitlement unless Apple has
  granted a documented entitlement for the specific API.
