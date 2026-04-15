---
name: adr-spatial
description: Record architecture decision records for visionOS. Every scene model decision, significant RealityKit architecture choice, and ARKit session strategy gets an ADR. Template covers context, decision, consequences, and alternatives rejected.
---

# ADR - Spatial Architecture Decisions

## Quick Start

Use this skill when an architectural decision needs to be recorded for future
reference.

Use it when:
- you are choosing between scene models (window, volume, immersive space)
- a significant RealityKit architecture choice is being made
- an ARKit session strategy is being decided
- you need to document why an alternative was rejected
- a future developer or agent needs to understand why a choice was made

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/surface-selection.md`](references/surface-selection.md) | When the ADR involves a scene model choice. |
| [`references/realitykit-components.md`](references/realitykit-components.md) | When the ADR involves RealityKit entity or component architecture. |
| [`references/arkit-sessions.md`](references/arkit-sessions.md) | When the ADR involves ARKit provider or session strategy. |
| [`references/adr-template.md`](references/adr-template.md) | When you need the standard ADR template format. |

## Workflow

1. Identify the architectural decision being made.
2. Document the context - what problem are we solving, what constraints exist.
3. Document the decision.
4. Document consequences (positive and negative).
5. Document alternatives that were considered and why they were rejected.
6. File the ADR in the project's `docs/adr/` directory.
7. Reference the ADR in relevant code comments.

## When To Switch Skills

- Switch to `spec-driven-spatial` when the ADR feeds into a new feature spec.
- Switch to `spatial-architecture` when you need to validate the decision
  against the broader app architecture.
- Switch to `incremental-build` when the decision is recorded and
  implementation can begin.

## Guardrails

- Do not skip documenting alternatives - every ADR must list what was considered
  and rejected.
- Do not write ADRs for trivial choices - reserve them for decisions that affect
  scene models, entity architecture, or session strategy.
- Do not modify an existing ADR - write a new ADR that supersedes the old one
  and link to it.
- Keep ADRs concise - context, decision, consequences, and alternatives. No
  implementation detail.
- Always include both positive and negative consequences of the decision.
