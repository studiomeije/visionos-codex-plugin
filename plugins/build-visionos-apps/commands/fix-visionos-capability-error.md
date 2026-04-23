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

1. Route to the real plugin skill for the failure class.
   - Use `../skills/signing-entitlements/SKILL.md` as the primary skill.
   - Use `../skills/build-run-debug/SKILL.md` only when you need to reproduce
     the launch failure through XcodeBuildMCP before inspecting the artifact.

2. Inspect the artifact or project settings.
   - Prefer the built `.app` when one exists.
   - Read the built `Info.plist`, entitlements, and relevant target settings.
   - Useful artifact checks:
     - `/usr/libexec/PlistBuddy -c 'Print' <app>/Info.plist`
     - `codesign -d --entitlements :- <app>`
   - Useful project check:
     - `xcodebuild -showBuildSettings` with the same workspace/project, scheme,
       SDK, configuration, and destination used to build the app.

3. Determine the failure class.
   - Missing privacy key
   - Missing capability
   - Entitlement mismatch
   - Simulator-only signing behavior
   - Device signing or provisioning problem
   - Distribution-only trust issue

4. Pay attention to visionOS-specific privacy and capability keys.
   - Check for keys tied to world sensing, hands, camera, and other
     visionOS-relevant system access.
   - Distinguish simulator behavior from physical device behavior before
     blaming signing in general.

5. Give the smallest fix or validation sequence.
   - State what is wrong in plain language.
   - Show the shortest useful command or project setting change.
   - Route back to `../skills/build-run-debug/SKILL.md` for the verification
     build/run after signing, privacy, or capability state is known.

## Guardrails

- Do not invent entitlements or privacy keys.
- Do not conflate simulator signing with device provisioning.
- Do not describe a launch refusal as a generic code-signing issue when the
  real problem is a missing usage description or capability.
- If the failure is really caused by the app target configuration, say so
  directly.
