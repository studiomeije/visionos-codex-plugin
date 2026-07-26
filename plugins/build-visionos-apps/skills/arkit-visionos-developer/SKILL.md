---
name: arkit-visionos-developer
description: Build and debug ARKit features on visionOS 27, including ARKitSession setup, authorization, provider selection, anchor processing, and RealityKit integration. Use for spatial tracking, hand tracking, reference tracking, camera access, environment lighting, stereo properties, visual fidelity, or multi-provider ARKit lifecycle work.
---

# ARKit visionOS Developer

## Quick Start

1. Load the provider index, then open only the provider guides needed by the
   task.
2. If the task spans provider families, load the shared session and anchor
   references first.
3. Add only the usage strings, entitlements, and authorizations required by the
   providers you actually use.
4. Keep anchor state in a model layer, and bridge into RealityKit only when you
   have a rendering target.
5. If the issue is app launch, test flow, simulator behavior, or signing,
   switch to `build-run-debug` or `signing-entitlements`.

## Load Shared References When

| Reference | When to Use |
|-----------|-------------|
| [`references/provider-index.md`](references/provider-index.md) | When you need the provider map and routing guidance. |
| [`references/session-basics.md`](references/session-basics.md) | When setting up `ARKitSession`, authorization, or shared lifecycle rules. |
| [`references/anchor-processing.md`](references/anchor-processing.md) | When reconciling `anchorUpdates`, IDs, and model-layer state. |
| [`references/realitykit-bridge.md`](references/realitykit-bridge.md) | When ARKit data needs to become visible RealityKit scene content. |

## Workflow

1. Choose the provider family.
2. Load the shared session and lifecycle guidance first.
3. Add only the provider references that match the task.
4. Keep anchor reconciliation in a model layer.
5. Bridge into RealityKit only after the model layer has stable state.

## Guardrails

- Keep a strong reference to `ARKitSession` for the full lifetime of the
  experience.
- Request authorization before running providers that need it.
- Do not block the main actor while awaiting provider updates.
- Do not assume every provider has the same presentation, privacy, entitlement,
  or provisioning requirements.
- Route launch, build, simulator, and codesign problems out to the execution
  skills instead of expanding this skill with run-loop detail.

## Output Expectations

Provide:
- the provider set chosen
- which shared and provider references were used
- the session and anchor-processing model
- the RealityKit bridge plan if applicable
- the next skill to use if the blocker is execution, signing, or scene work
