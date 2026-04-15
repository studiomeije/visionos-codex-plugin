---
name: packaging-distribution
description: Prepare and troubleshoot archive, signing, and distribution workflows for visionOS apps (TestFlight, ad-hoc, App Store) using xcodebuild archive plus the App Store Connect CLI (asc). Use when asked to archive a visionOS app, upload a build to TestFlight, submit for App Store review, validate bundle structure, reason about TestFlight readiness, or automate App Store Connect metadata and screenshots from the command line.
---

# Packaging & Distribution (visionOS)

## Quick Start

Use this skill when the work is about shipping the app rather than building or
debugging it locally: archive creation, export, TestFlight, App Store review,
or release-readiness checks.

1. Confirm the goal first:
   - validate an archive locally
   - export an ad-hoc or enterprise build
   - upload to TestFlight
   - submit to the App Store
2. Load the narrowest reference files that match the task.
3. Keep local build/debug issues in `build-run-debug`, privacy/capability
   issues in `signing-entitlements`, and failing tests in `test-triage`.

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/asc-preflight.md`](references/asc-preflight.md) | When you need to confirm `asc` installation, auth, or profile health before upload or submission. |
| [`references/distribution-workflow.md`](references/distribution-workflow.md) | When you need the archive/export/upload flow by release goal. |
| [`references/asc-cli-reference.md`](references/asc-cli-reference.md) | When you need current `asc` command families for builds, review, metadata, screenshots, signing assets, or Xcode Cloud. |
| [`references/manual-fallback.md`](references/manual-fallback.md) | When `asc` is unavailable and the user needs the Xcode or Transporter fallback path. |
| [`references/visionos-distribution-checks.md`](references/visionos-distribution-checks.md) | When validating visionOS-specific bundle, entitlement, icon, or resource packaging concerns. |
| [`references/credentials.md`](references/credentials.md) | When the task touches App Store Connect API keys, CI secrets, or auth-profile handling. |

## Workflow

1. Confirm the release target and artifact path.
2. Run the `asc` preflight once if the task needs App Store Connect.
3. Archive and export with the appropriate method.
4. Validate the archive and exported artifact with the visionOS-specific checks.
5. Upload, distribute, or submit only after the local artifact is confirmed.
6. Separate local packaging failures from App Store Connect failures in the
   summary.

## When To Switch Skills

- Switch to `signing-entitlements` when the failure is about identity,
  profile, capability toggles, or privacy usage strings.
- Switch to `build-run-debug` when the archive itself won't build, or a
  simulator run is the fastest reproduction path.
- Switch to `test-triage` when distribution is blocked by failing tests.

## Guardrails

- Do not present notarization as required for visionOS distribution; Apple
  Vision Pro apps are distributed via TestFlight and the App Store, not via
  developer-ID notarized pkgs the way macOS apps are.
- Do not present simulator archives as distributable.
- If this skill and `asc --help` disagree on a flag, prefer `asc --help` and
  note the divergence in your response.
- Do not run `asc publish appstore --submit` without explicit user
  confirmation; it changes App Store Connect state. `--dry-run` or `asc
  validate` first when unsure.
- Call out when you lack the actual exported artifact and are inferring from
  project settings.

## Output Expectations

Provide:
- the distribution goal and artifact path
- which reference tracks were used
- the local packaging state
- the App Store Connect state if relevant
- the smallest next validation or release step
