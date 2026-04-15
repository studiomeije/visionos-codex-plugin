# Manual Fallback

Use this file when `asc` is unavailable and the user still wants to complete as
much of the workflow as possible.

## What Can Still Be Automated

- `xcodebuild archive`
- `xcodebuild -exportArchive`
- local archive inspection and export validation

## What Moves To The User Or UI

- Upload to App Store Connect via Transporter
- TestFlight distribution in App Store Connect
- metadata, screenshots, and review submission in the browser

Apple's current upload guidance points JWT or API-key users to Transporter
instead of older `altool` flows. Do not run credential-bearing Transporter or
fallback upload commands on the user's behalf.

Be explicit that the workflow is partial when you use this fallback.
