---
name: spec-driven-spatial
description: Gate every visionOS feature on a scene model decision before writing code. The spec must answer scene ownership, entity lifecycle, ARKit session requirements, SharePlay needs, and privacy entitlements. No code until the spec is complete and reviewed.
---

# Spec-Driven Spatial Development

## Quick Start

Use this skill before any implementation begins on a new visionOS feature.

Use it when:
- you are starting a new feature and no specification exists yet
- you need to decide between window, volume, immersive space, or a mixed flow
- the feature involves ARKit sessions, SharePlay, or privacy entitlements
- you want to ensure all spatial concerns are addressed before writing code

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/surface-selection.md`](references/surface-selection.md) | When choosing the scene model for the feature. |
| [`references/state-ownership.md`](references/state-ownership.md) | When defining entity lifecycle and ownership boundaries. |
| [`references/arkit-sessions.md`](references/arkit-sessions.md) | When the feature requires world tracking, hand tracking, or plane detection. |
| [`references/shareplay-requirements.md`](references/shareplay-requirements.md) | When the feature involves group activities or shared presence. |
| [`references/entitlements.md`](references/entitlements.md) | When listing privacy entitlements and capabilities. |

## Workflow

1. Name the feature and its user-facing job.
2. Choose the scene model: window, volume, immersive space, or mixed.
3. Define entity lifecycle and ownership.
4. Identify ARKit session requirements (if any).
5. Identify SharePlay requirements (if any).
6. List privacy entitlements needed.
7. Write the spec document with acceptance criteria.
8. Review spec with `spatial-architecture` skill for consistency.
9. Only after spec approval, hand off to `incremental-build`.

## When To Switch Skills

- Switch to `spatial-architecture` when you need to validate the scene model
  choice against app-wide architecture.
- Switch to `incremental-build` once the spec is approved and you are ready to
  implement.
- Switch to `adr-spatial` when a decision in the spec is significant enough to
  warrant an architecture decision record.

## Guardrails

- Do not write any implementation code until the spec is complete and reviewed.
- Do not skip the scene model decision - every feature must declare its surface.
- Do not assume entitlements are available - list them explicitly and verify.
- Do not combine multiple features into a single spec - one spec per feature.
