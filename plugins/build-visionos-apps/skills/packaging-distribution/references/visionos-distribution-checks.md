# visionOS Distribution Checks

Use this file when validating the archive or exported artifact.

## Required Checks

- The archive was created for `generic/platform=visionOS`, not the simulator.
- `CFBundleSupportedPlatforms` is `XROS` in the archive/exported app, not
  `XRSimulator`.
- `UIRequiredDeviceCapabilities` does not accidentally inherit iPhone/iPad-only
  requirements that make no sense for Apple Vision Pro.
- The exported artifact contains the expected visionOS app icon assets.
- Distribution entitlements match the provisioning profile.
- Privacy usage strings needed by ARKit providers are present in the final
  `Info.plist`.
- Reality Composer Pro resources (`.rkassets`, `.usdz`, `.reality`) are copied
  into the app bundle.
- Extension targets and embedded frameworks are signed and packaged with their
  own compatible identifiers and profiles.

## Enterprise And Managed Capabilities

If the app uses enterprise ARKit capabilities, confirm the managed entitlement
is present in the provisioning profile and not only enabled in the project.

## Practical Validation

Archive:

```bash
/usr/libexec/PlistBuddy -c "Print :ApplicationProperties" "<App.xcarchive>/Info.plist"
find "<App.xcarchive>/Products/Applications" -maxdepth 2 -print
plutil -p "<App.xcarchive>/Products/Applications/<App.app>/Info.plist"
codesign -dvv --entitlements :- "<App.xcarchive>/Products/Applications/<App.app>" 2>/dev/null
```

Exported `.ipa`:

```bash
test -f "<export>/<App.ipa>"
unzip -l "<export>/<App.ipa>" | rg "Payload/.*\\.app/(Info.plist|Assets.car|embedded.mobileprovision)"
```

Inspect after unpacking to a temporary directory:

```bash
plutil -p "<tmp>/Payload/<App.app>/Info.plist"
codesign -dvv --entitlements :- "<tmp>/Payload/<App.app>" 2>/dev/null
security cms -D -i "<tmp>/Payload/<App.app>/embedded.mobileprovision" > /tmp/visionos-profile.plist
plutil -extract Entitlements xml1 -o - /tmp/visionos-profile.plist
```

Assets and resources:

```bash
xcrun assetutil --info "<tmp>/Payload/<App.app>/Assets.car" | rg -n "AppIcon|vision"
find "<tmp>/Payload/<App.app>" -name "*.rkassets" -o -name "*.usdz" -o -name "*.reality"
```

Call `asc` only after the local archive/exported artifact exists and these
checks match the release goal.
