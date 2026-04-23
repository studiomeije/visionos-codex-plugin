# Distribution Workflow

Use this file for the archive, export, and upload sequence.

## Goals

- Local archive validation
- Release-testing or enterprise export
- TestFlight upload and distribution
- App Store submission

## Preflight

Confirm the project can resolve a visionOS device archive destination:

```bash
xcodebuild -showdestinations -scheme <scheme>
xcodebuild -showBuildSettings \
  -scheme <scheme> \
  -configuration Release \
  -destination 'generic/platform=visionOS' \
  -json
```

Reject `xrsimulator*` build settings for distribution. A distributable archive
must use the visionOS device SDK and `generic/platform=visionOS`.

## Core Flow

1. Archive with a visionOS device destination:

```bash
xcodebuild archive \
  -scheme <scheme> \
  -configuration Release \
  -destination 'generic/platform=visionOS' \
  -archivePath <path>.xcarchive
```

2. Inspect the archive before export.
3. Export with the correct method:

```bash
xcodebuild -exportArchive \
  -archivePath <path>.xcarchive \
  -exportPath <out> \
  -exportOptionsPlist ExportOptions.plist
```

4. Confirm the exported `.ipa` exists.
5. Use `asc` for TestFlight or App Store actions:
   - `asc builds next-build-number --app <appId>`
   - `asc builds upload --app <appId> --ipa <path>.ipa --output json`
   - `asc publish testflight --app <appId> --build <buildId> --group "<group>"`
   - `asc publish appstore --app <appId> --ipa <path>.ipa --version <semver> --submit --confirm`
   - `asc review doctor --app <appId>`
   - `asc status --app <appId> --watch`

## Export Methods

Use the current `xcodebuild -help` names when Xcode supports them:

- `app-store-connect`: App Store Connect upload or App Store/TestFlight
  distribution export.
- `release-testing`: device release-testing export for registered devices.
- `enterprise`: enterprise distribution when the account/profile supports it.
- `validation`: local validation export.

Older names such as `app-store`, `ad-hoc`, and `development` are deprecated in
current Xcode output. Use them only when an older Xcode requires them and note
the reason.

Minimal App Store Connect export options:

```xml
<dict>
  <key>method</key>
  <string>app-store-connect</string>
  <key>destination</key>
  <string>export</string>
  <key>teamID</key>
  <string><TEAM_ID></string>
  <key>uploadSymbols</key>
  <true/>
</dict>
```

For release-testing and enterprise exports, use the matching method and verify
whether manual signing requires a `provisioningProfiles` dictionary keyed by
bundle identifier.

## Archive Inspection

```bash
/usr/libexec/PlistBuddy -c "Print :ApplicationProperties" "<path>.xcarchive/Info.plist"
find "<path>.xcarchive/Products/Applications" -maxdepth 1 -name "*.app" -print
codesign -dvv --entitlements :- "<path>.xcarchive/Products/Applications/<App.app>" 2>/dev/null
plutil -p "<path>.xcarchive/Products/Applications/<App.app>/Info.plist"
```

If the archive was automatically signed and export needs to create or download
profiles, tell the user before adding `-allowProvisioningUpdates`.

## Failure Separation

- Local packaging error: wrong destination, export failure, bundle layout,
  resource copy, signing mismatch.
- App Store Connect error: `asc` command succeeds locally but returns remote
  validation or submission failures.
- Credential error: `asc` cannot authenticate or cannot see the app; refresh the
  local auth profile or CI secret before retrying upload.
- Review-state error: metadata, screenshots, age rating, agreements, or review
  submission state blocks distribution after a valid upload.
