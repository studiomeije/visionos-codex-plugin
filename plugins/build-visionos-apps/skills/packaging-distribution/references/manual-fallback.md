# Manual Fallback

Use this file when `asc` is unavailable and the user still wants to complete as
much of the workflow as possible.

This fallback is partial. It can prove the local visionOS artifact is shaped
correctly, but it cannot complete App Store Connect state changes from the
agent.

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

## Safe Agent Output

When using this fallback, provide:

- archive path and export path
- local validation commands and results
- exact reason `asc` could not be used
- the manual step the user must perform in Xcode Organizer, Transporter, or App
  Store Connect

Do not ask the user to paste App Store Connect credentials, Transporter logs
with secrets, or private-key contents into the conversation.
