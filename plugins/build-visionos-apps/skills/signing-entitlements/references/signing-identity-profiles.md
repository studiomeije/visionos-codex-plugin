# Signing Identities And Profiles

Use this file when the issue is identity selection, provisioning, or team
configuration.

## What To Check

- Development vs distribution identity matches the target and release goal.
- The provisioning profile belongs to the expected team and bundle identifier.
- The built entitlements are supported by the profile.
- Archive/export signing uses a visionOS device or distribution identity rather
  than simulator assumptions.
- Extension targets, App Intents, widgets, and embedded frameworks use profiles
  compatible with their own bundle identifiers.

## Commands

Local identities:

```bash
security find-identity -p codesigning -v
```

Build settings:

```bash
xcodebuild -showBuildSettings \
  -scheme <scheme> \
  -configuration <Debug-or-Release> \
  -destination 'generic/platform=visionOS' \
  -json
```

Built app:

```bash
codesign -dvv "<App.app>" 2>&1
codesign -dvv --entitlements :- "<App.app>" 2>/dev/null
plutil -p "<App.app>/Info.plist"
```

Embedded provisioning profile:

```bash
security cms -D -i "<App.app>/embedded.mobileprovision" > /tmp/visionos-profile.plist
plutil -p /tmp/visionos-profile.plist
plutil -extract Entitlements xml1 -o - /tmp/visionos-profile.plist
```

Archive metadata:

```bash
/usr/libexec/PlistBuddy -c "Print :ApplicationProperties" "<App.xcarchive>/Info.plist"
```

## Fix Sequence

1. Decide whether the failing artifact needs development, release-testing,
   enterprise, or App Store Connect distribution signing.
2. Repair team, bundle ID, profile, or identity configuration for that target.
3. Rebuild and re-sign the artifact.
4. Reinspect the built entitlements, `Info.plist`, and embedded profile.
5. Retry install, launch, archive validation, or export.

## Common visionOS Pitfalls

- Building for `generic/platform=visionOS Simulator` or an `xrsimulator` SDK and
  treating that output as device-ready.
- Fixing the project `.entitlements` file while the provisioning profile still
  lacks the managed ARKit entitlement.
- Archiving with one team and exporting with another team.
- Using a development profile for TestFlight or App Store export.
- Leaving a companion target, widget, or app extension on a stale profile while
  the app target is fixed.
- Passing `-allowProvisioningUpdates` without telling the user it may contact
  Apple Developer services and create or update signing assets.
