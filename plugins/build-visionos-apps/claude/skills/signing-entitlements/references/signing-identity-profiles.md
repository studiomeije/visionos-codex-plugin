# Signing Identities And Profiles

Use this file when the issue is identity selection, provisioning, or team
configuration.

## What To Check

- Development vs distribution identity matches the target.
- The provisioning profile belongs to the expected team.
- The built entitlements are supported by the profile.
- Archive signing uses a device or distribution identity rather than simulator
  assumptions.

## Fix Sequence

1. Repair team, profile, or identity configuration.
2. Rebuild and re-sign the artifact.
3. Reinspect the built entitlements and `Info.plist`.
4. Retry install, launch, archive validation, or export.
