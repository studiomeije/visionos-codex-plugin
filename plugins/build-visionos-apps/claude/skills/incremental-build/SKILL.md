---
name: incremental-build
description: Implement visionOS features in thin vertical slices. Prove scene transitions work before adding entity hierarchies. One RealityKit component or system at a time. Each slice must build and run on the Apple Vision Pro simulator before expanding.
---

# Incremental Build

## Quick Start

Use this skill when implementing a feature that already has an approved spec.

Use it when:
- you are ready to start coding after a spec has been approved
- you need to break a feature into the smallest buildable slices
- you want to verify each slice on the simulator before moving on
- a feature touches multiple RealityKit components or systems

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/surface-selection.md`](references/surface-selection.md) | When verifying the scene model for the current slice. |
| [`references/realitykit-components.md`](references/realitykit-components.md) | When adding a new component or system to the entity hierarchy. |
| [`references/simulator-verification.md`](references/simulator-verification.md) | When running build-and-verify steps on the simulator. |
| [`references/scene-transitions.md`](references/scene-transitions.md) | When the slice involves moving between windows, volumes, or immersive spaces. |

## Workflow

1. Identify the thinnest vertical slice that proves the scene model works.
2. Implement only that slice - one RealityKit component or system at a time.
3. Build and run on the Apple Vision Pro simulator.
4. Verify the slice works before expanding.
5. Add the next component or system.
6. Repeat until the feature is complete.
7. Never add a second slice until the first one builds and runs clean.

## When To Switch Skills

- Switch to `spec-driven-spatial` if the spec is missing or incomplete.
- Switch to `debugging-triage` when a slice fails to build or behaves
  unexpectedly on the simulator.
- Switch to `git-workflow` when a slice is verified and ready to commit.
- Switch to `spatial-architecture` when the slice reveals an architecture
  concern that was not addressed in the spec.

## Guardrails

- Do not implement multiple components or systems in a single slice.
- Do not skip simulator verification between slices.
- Do not expand a slice before the previous one builds and runs clean.
- Do not refactor while building a new slice - finish the slice first, then
  refactor in a separate pass.
- Keep each slice small enough to reason about in isolation.
