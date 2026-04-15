# /fix-visionos-capability-error

Inspect a visionOS capability, privacy, or signing failure and explain the minimum fix path.

## Arguments

$ARGUMENTS - Optional: path to .app bundle, signing identity hint, or mode (inspect/repair-plan)

## Workflow

1. Inspect the artifact or project settings
   - Prefer the built .app when one exists
   - Read the built Info.plist, entitlements, and relevant target settings

2. Determine the failure class
   - Missing privacy key
   - Missing capability
   - Entitlement mismatch
   - Simulator-only signing behaviour
   - Device signing or provisioning problem
   - Distribution-only trust issue

3. Check visionOS-specific privacy and capability keys
   - Keys tied to world sensing, hands, camera, and other visionOS system access
   - Distinguish simulator behaviour from physical device behaviour

4. Give the smallest fix or validation sequence
   - State what is wrong in plain language
   - Show the shortest useful command or project setting change
   - Refer to skills/signing-entitlements for deeper investigation

## Guardrails

- Do not invent entitlements or privacy keys
- Do not conflate simulator signing with device provisioning
- Do not describe a launch refusal as a generic signing issue when the real problem is a missing usage description
