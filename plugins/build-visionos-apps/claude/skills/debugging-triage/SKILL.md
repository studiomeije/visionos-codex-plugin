---
name: debugging-triage
description: Systematic five-step triage for visionOS issues. Reproduce on simulator, isolate to scene/entity/system, reduce to minimal repro, fix the root cause, and add a regression test. Covers ARKit session failures, RealityKit render loop timing bugs, hand tracking edge cases, and entitlement launch blockers.
---

# Debugging Triage

## Quick Start

Use this skill when something is broken or behaving unexpectedly in a visionOS
app.

Use it when:
- a build fails or the app crashes on the simulator
- ARKit sessions fail to start or lose tracking
- RealityKit render loop timing causes visual glitches or dropped frames
- hand tracking behaves incorrectly at 90Hz
- entitlement or capability issues block app launch
- scene lifecycle transitions produce unexpected state

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/arkit-sessions.md`](references/arkit-sessions.md) | When the failure involves world tracking, hand tracking, or provider sessions. |
| [`references/realitykit-render-loop.md`](references/realitykit-render-loop.md) | When the issue is timing-related, frame drops, or render loop ordering. |
| [`references/hand-tracking.md`](references/hand-tracking.md) | When hand tracking data is missing, delayed, or jittering at 90Hz. |
| [`references/entitlements.md`](references/entitlements.md) | When the app fails to launch due to missing entitlements or capabilities. |
| [`references/scene-lifecycle.md`](references/scene-lifecycle.md) | When the issue involves scene transitions or lifecycle callbacks. |

## Workflow

1. Reproduce the issue on the Apple Vision Pro simulator.
2. Classify the failure: ARKit session, RealityKit render loop, hand tracking,
   entitlement, scene lifecycle, or other.
3. Isolate to the specific scene, entity, system, or provider.
4. Reduce to a minimal reproduction case.
5. Fix the root cause (not the symptom).
6. Add a regression test.
7. Verify the fix on the simulator.

## When To Switch Skills

- Switch to `incremental-build` once the fix is verified and you are resuming
  feature work.
- Switch to `git-workflow` to commit the fix with a clear message referencing
  the root cause.
- Switch to `adr-spatial` if the fix reveals an architectural decision that
  should be recorded.
- Switch to `spec-driven-spatial` if the bug exposes a gap in the original spec.

## Guardrails

- Do not guess at fixes - reproduce first, then isolate, then fix.
- Do not fix symptoms while leaving the root cause in place.
- Do not skip the regression test - every fix must be verified against
  re-introduction.
- Do not apply fixes across multiple unrelated issues in a single pass.
- Always verify the fix on the simulator before marking it done.
