# Signing And Entitlements Reference Map

Load this file first when you need the inspection order or the core command set.

The goal is to inspect the artifact that failed, not a nearby target setting.
For visionOS, the first fork is always simulator, physical device, archive, or
exported `.ipa`.

## Inspection Order

1. Capture the exact failure text and boundary:
   - simulator install or launch
   - physical-device install or launch
   - ARKit authorization/provider runtime failure
   - `xcodebuild archive`
   - `xcodebuild -exportArchive`
   - App Store Connect upload, TestFlight, or App Review validation
2. Identify the built target:

```bash
xcodebuild -showBuildSettings \
  -scheme <scheme> \
  -configuration <Debug-or-Release> \
  -destination '<destination>' \
  -json
```

Look for `SDK_NAME`, `EFFECTIVE_PLATFORM_NAME`, `PRODUCT_BUNDLE_IDENTIFIER`,
`DEVELOPMENT_TEAM`, `CODE_SIGN_STYLE`, `CODE_SIGN_ENTITLEMENTS`,
`PROVISIONING_PROFILE_SPECIFIER`, and `PROVISIONING_PROFILE`.

3. Inspect the built `Info.plist`:

```bash
plutil -p "<App.app>/Info.plist"
```

Confirm `CFBundleSupportedPlatforms` says `XROS` for a device/archive build and
`XRSimulator` only for simulator builds. Check usage-description keys from the
final bundle, not only the source plist or generated build setting.

4. Inspect signed entitlements:

```bash
codesign -dvv --entitlements :- "<App.app>" 2>/dev/null
```

5. For device, archive, and exported artifacts, inspect the embedded profile
   when it exists:

```bash
security cms -D -i "<App.app>/embedded.mobileprovision" > /tmp/visionos-profile.plist
plutil -p /tmp/visionos-profile.plist
plutil -extract Entitlements xml1 -o - /tmp/visionos-profile.plist
```

The signed app may request only entitlements allowed by the profile. A managed
enterprise entitlement missing from the profile is a profile/account issue even
when it appears in the target `.entitlements` file.

6. Check local identities only when the failing target needs a device,
   archive, or export signature:

```bash
security find-identity -p codesigning -v
```

7. For archives, inspect the archive metadata and then the app inside it:

```bash
/usr/libexec/PlistBuddy -c "Print :ApplicationProperties" "<App.xcarchive>/Info.plist"
find "<App.xcarchive>/Products/Applications" -maxdepth 1 -name "*.app" -print
```

## Failure Classes

- Simulator-only issue: `SDK_NAME` is `xrsimulator*`, platform is
  `XRSimulator`, and there is no useful provisioning-profile diagnosis.
- Device install/signing issue: physical device install fails before launch, or
  `devicectl`/Xcode reports an invalid signature, missing profile, wrong team,
  or entitlement not permitted by the profile.
- Managed capability mismatch: app requests an enterprise ARKit entitlement,
  but the provisioning profile does not contain the same key and value.
- Privacy mismatch: the app reaches launch or provider authorization, but
  `Info.plist` lacks the needed usage description or contains placeholder text.
- Archive/export mismatch: Debug or simulator builds work, but Release archive
  or export changes the signing identity, profile, supported platform, resource
  copy phase, or entitlements.
- Non-signing issue: entitlements, profile, and privacy strings match the
  artifact; route to `build-run-debug`, ARKit, or RealityKit diagnostics.

## Useful Device Commands

Use `devicectl` for physical-device diagnostics when available. Its JSON output
must go to a file; stdout is for humans.

```bash
xcrun devicectl list devices --json-output /tmp/visionos-devices.json
xcrun devicectl device install app \
  --device <device-id-or-name> \
  "<App.app>" \
  --json-output /tmp/visionos-install.json \
  --log-output /tmp/visionos-install.log
```

For simulator-only checks, use `simctl` and keep the result out of distribution
diagnosis:

```bash
xcrun simctl install booted "<App.app>"
xcrun simctl privacy booted reset all <bundle-id>
```

## Minimum Fix Rule

Fix the layer that disagrees with the failed artifact:

- Project entitlements missing but profile supports it: update the target
  capability or `.entitlements` file, rebuild, and reinspect the signed app.
- Profile missing a managed entitlement: update the developer-account
  capability/profile outside the codebase, then rebuild or re-export.
- Signed app has the entitlement but provider still fails on simulator: switch
  to simulator/device behavior checks.
- Signed app and profile match, but App Store Connect rejects the upload: switch
  to `packaging-distribution` with the exported `.ipa` and validation output.
