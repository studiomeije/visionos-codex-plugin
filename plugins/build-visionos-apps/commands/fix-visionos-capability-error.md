# /fix-visionos-capability-error

Inspect a visionOS capability, privacy, or signing failure and explain the
minimum fix path. Use this when launch is blocked by missing usage strings,
entitlement mismatch, capability configuration, or simulator versus device
differences.

## Arguments

- `app`: path to `.app` bundle or binary, if available
- `identity`: signing identity hint, if available
- `mode`: `inspect` or `repair-plan` (optional, default: `inspect`)

## Workflow

1. Inspect the artifact or project settings.
   - Prefer the built `.app` when one exists.
   - Read the built `Info.plist`, entitlements, and relevant target settings.

2. Determine the failure class.
   - Missing privacy key
   - Missing capability
   - Entitlement mismatch
   - Simulator-only signing behavior
   - Device signing or provisioning problem
   - Distribution-only trust issue

3. Pay attention to visionOS-specific privacy and capability keys.
   - Check for keys tied to world sensing, hands, camera, and other
     visionOS-relevant system access.
   - Distinguish simulator behavior from physical device behavior before
     blaming signing in general.

4. Give the smallest fix or validation sequence.
   - State what is wrong in plain language.
   - Show the shortest useful command or project setting change.
   - Prefer `../skills/signing-entitlements/SKILL.md` when a deeper read is
     needed.

## Guardrails

- Do not invent entitlements or privacy keys.
- Do not conflate simulator signing with device provisioning.
- Do not describe a launch refusal as a generic code-signing issue when the
  real problem is a missing usage description or capability.
- If the failure is really caused by the app target configuration, say so
  directly.

