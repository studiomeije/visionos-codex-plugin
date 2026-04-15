# Distribution Workflow

Use this file for the archive, export, and upload sequence.

## Goals

- Local archive validation
- Ad-hoc or enterprise export
- TestFlight upload and distribution
- App Store submission

## Core Flow

1. Archive with a visionOS device destination:

```bash
xcodebuild archive \
  -scheme <scheme> \
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

## Failure Separation

- Local packaging error: wrong destination, export failure, bundle layout,
  resource copy, signing mismatch.
- App Store Connect error: `asc` command succeeds locally but returns remote
  validation or submission failures.
