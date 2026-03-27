# visionOS Distribution Checks

Use this file when validating the archive or exported artifact.

## Required Checks

- `UIRequiredDeviceCapabilities` does not exclude visionOS.
- The archive was created for `generic/platform=visionOS`, not the simulator.
- The exported artifact contains the expected visionOS icon family.
- Distribution entitlements match the provisioning profile.
- Reality Composer Pro resources (`.rkassets`, `.usdz`, `.reality`) are copied
  into the app bundle.

## Enterprise And Managed Capabilities

If the app uses enterprise ARKit capabilities, confirm the managed entitlement
is present in the provisioning profile and not only enabled in the project.

## Practical Validation

- Inspect the `.xcarchive` contents.
- Inspect entitlements with `codesign -dvvv --entitlements :- <app>`.
- Confirm privacy usage strings via `Info.plist`.
- Verify the exported `.ipa` exists before calling `asc`.
