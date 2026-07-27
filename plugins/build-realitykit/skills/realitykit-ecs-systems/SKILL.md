---
name: realitykit-ecs-systems
description: Design, implement, and debug custom RealityKit components, systems, ECS queries, component registration, update loops, Codable component state, and per-frame multi-entity behavior on visionOS. Use for ECS architecture, correctness, or implementing a measured fix. Route hot System.update work, high CPU, contention, task storms, and trace-backed ECS profiling to realitykit-performance-triage.
---

# RealityKit ECS Systems

## Quick Start

1. First verify that a documented RealityKit component cannot solve the
   problem; use `realitykit-visionos-developer` component selection when
   unsure.
2. Use a custom `Component` for per-entity state and a custom `System` for
   continuous or multi-entity behavior.
3. Register custom components and systems once during app startup before any
   scene, asset, or Reality Composer Pro content that depends on them loads.
4. Keep per-frame work in systems, not SwiftUI body code or ad hoc timers.
5. Load the full ECS guide only when implementing or debugging real custom ECS
   code.

## Load References When

| Reference | When to Use |
|---|---|
| [`references/systemandcomponentcreation.md`](references/systemandcomponentcreation.md) | Implement a complete custom component/system registration, query, and update-order pattern. |
| [`references/custom-components.md`](references/custom-components.md) | Define custom per-entity data and registration behavior. |
| [`references/custom-systems.md`](references/custom-systems.md) | Implement custom systems, queries, per-frame behavior, and update loops. |

## Cross-Routing

- Use `realitykit-visionos-developer` for general component choice, entity
  loading, input, attachments, anchoring, portals, sync, and local
  `USDStageComponent`.
- Use `realitykit-rendering-materials` when custom ECS only exists to drive
  materials, lights, post-processing, LOD, splats, or other visual state.
- Use `realitykit-animation-physics` when custom ECS interacts with animation,
  character motion, navigation, collision, physics, particles, or cloth.
- Use `realitykit-audio-spatial` when systems coordinate entity-owned audio.
- Use `scriptgraph-editor` when the behavior is authored inside Reality
  Composer Pro Script Graphs rather than app-owned Swift systems.
- Use `realitykit-performance-triage` when ECS cost, query cadence, scheduling,
  or CPU impact needs measurement.

## Guardrails

- Prefer documented components before custom ECS.
- Register before loading scenes that reference the custom types.
- Keep system queries narrow and update only the entities that need work.
- Do not store SwiftUI-only state in RealityKit components unless entity
  ownership is intentional.
- Summarize registration order and query shape when changing ECS code.
- Verify written Swift by building before reporting done. Route the build
  through `build-run-debug`.
- Apply `coding-standards-enforcer` to Swift you write here: Swift 6.2 strict
  concurrency, actor isolation, `Sendable`, and `@Observable` ownership.


## Skills In Other Plugins

These routes live in other plugins from this marketplace. If one is not
installed, say so plainly and continue with the best available path rather
than stalling or inventing the missing skill's guidance.

| Skill | Plugin |
|---|---|
| `build-run-debug` | Build visionOS 27 apps |
| `coding-standards-enforcer` | Build visionOS 27 apps |
| `realitykit-performance-triage` | Profile & Optimize RealityKit |
| `scriptgraph-editor` | Build with Reality Composer Pro 3 |

## Output Expectations

Provide:

- why custom ECS is needed
- which ECS reference was used
- the component data model
- the system query and update cadence
- the registration location and runtime validation step
