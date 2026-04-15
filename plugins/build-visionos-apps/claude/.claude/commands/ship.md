# /ship

Run the pre-launch checklist for a visionOS app. Covers signing, entitlements, privacy, and TestFlight readiness.

## Arguments

$ARGUMENTS - Optional: app name, target environment (testflight/appstore), or specific check to run

## Checklist

### Signing and Identity
- [ ] Signing identity is valid and not expired
- [ ] Provisioning profile matches the bundle identifier
- [ ] Distribution certificate is available for the target environment

### Entitlements
- [ ] All required entitlements are present in the .entitlements file
- [ ] No development-only entitlements are included in release builds
- [ ] Entitlements match between Xcode project and provisioning profile

### Privacy
- [ ] All privacy usage description keys are present in Info.plist
- [ ] Privacy descriptions are human-readable and accurate
- [ ] No unnecessary privacy keys are included

### visionOS Specific
- [ ] Scene model is correct (window/volume/immersive space declarations)
- [ ] ARKit session entitlements match provider usage
- [ ] Hand tracking entitlement is present if hand tracking is used
- [ ] World sensing entitlement is present if world sensing is used

### Build Verification
- [ ] Release build compiles without warnings
- [ ] App launches successfully on simulator
- [ ] No debug-only code paths in release configuration

### TestFlight Readiness
- [ ] Build number is incremented
- [ ] Version string is set correctly
- [ ] App icon is present at all required sizes
- [ ] Archive builds successfully

Invoke the xcode-build-agent for any build or signing issues found.
Refer to skills/signing-entitlements for entitlement resolution.
