---
name: signing-entitlements
description: Inspect signing, entitlements, and privacy-configuration issues for visionOS apps. Use when asked to diagnose launch refusals, missing privacy keys, entitlement mismatches, capability problems, or code-signing failures on simulator or device builds.
---

# Signing & Entitlements

## Quick Start

Use this skill when the main question is configuration and trust, not app
logic:
- launch refusal after a successful build
- missing or invalid entitlement
- missing privacy usage string
- capability mismatch between project settings and built output
- wrong signing identity or provisioning profile for device or archive
- App Store Connect or export rejection that names an entitlement, profile,
  privacy key, or unsupported capability

1. Classify the target first: simulator, device, or distribution artifact.
2. Capture the exact failing boundary: install, launch, ARKit authorization,
   archive, export, upload validation, or App Review metadata check.
3. Load only the reference files that match the failure class.
4. Inspect built output before proposing changes to project settings.
5. Switch back to `build-run-debug` once signing and privacy state are known
   good and the failure is still present.

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/inspection-checklist.md`](references/inspection-checklist.md) | When you need the inspection order, command set, or failure classification workflow. |
| [`references/privacy-usage-keys.md`](references/privacy-usage-keys.md) | When the failure involves missing or incorrect visionOS privacy strings. |
| [`references/enterprise-entitlements.md`](references/enterprise-entitlements.md) | When the app uses enterprise or managed ARKit capabilities. |
| [`references/simulator-device-behavior.md`](references/simulator-device-behavior.md) | When the same feature behaves differently on simulator and physical device. |
| [`references/signing-identity-profiles.md`](references/signing-identity-profiles.md) | When the issue is identity, provisioning, team selection, or archive signing. |

## Workflow

1. Determine whether the artifact is simulator-only, physical-device, archive,
   or exported distribution.
2. Inspect the built app, embedded entitlements, `Info.plist`, and provisioning
   profile when present.
3. Compare three sources before changing anything: project entitlements file,
   provisioning-profile entitlements, and signed app entitlements.
4. Classify the failure precisely: identity/profile, managed capability,
   privacy usage string, simulator/device mismatch, archive/export mismatch, or
   non-signing issue.
5. Apply the smallest fix that matches that class.
6. Rebuild and verify against built output, not just source configuration.

## Guardrails

- Never invent missing entitlements or privacy keys.
- Do not conflate simulator signing with device or App Store distribution signing.
- Do not prescribe distribution signing fixes for simulator-only failures.
- Do not use macOS sandbox, hardened runtime, notarization, or Developer ID
  advice unless the visionOS project embeds a macOS helper target.
- Do not add managed enterprise ARKit entitlements unless Apple has granted the
  entitlement and the provisioning profile contains it.
- If the real issue is a missing usage string or target capability, say so directly instead of blaming code signing in general.
- Always validate fixes against built output, not only project source files.

## Output Expectations

Provide:
- what artifact or project setting was inspected
- whether the failure is simulator-only or device/distribution
- the exact failure class and why alternatives were rejected
- the minimum fix or validation sequence
- explicit next-skill routing (`build-run-debug` or stay in this skill)
