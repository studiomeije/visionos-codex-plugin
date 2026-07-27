---
name: realitykit-visionos-developer
description: Pick the right owner for a RealityKit task on visionOS 27 - which focused RealityKit skill, which documented component, or which other plugin. Use when a RealityKit request is broad, ambiguous, or spans several areas, or when choosing between a built-in component, custom ECS, SwiftUI, and ARKit. Routes implementation to realitykit-entities-scenes, rendering, animation/physics, audio, or ECS, and measured performance work to realitykit-performance-triage.
---

# RealityKit visionOS Developer (Router)

This skill decides **who owns the work**. It carries no implementation guidance
of its own - once the owner is clear, switch to it.

## Workflow

1. Classify the request: scene/entity setup, rendering, animation or physics,
   audio, custom ECS, USD, SwiftUI, ARKit providers, build plumbing, or measured
   performance.
2. If it is a component-choice question, open
   [`component-selection.md`](references/component-selection.md) - it covers
   built-in component vs SwiftUI gesture vs `SpatialTrackingSession` vs ARKit vs
   custom ECS.
3. If you know the component but not where it is documented, use
   [`component-index.md`](references/component-index.md).
4. Hand off to the owning skill and stop. Do not re-explain its content here.

## RealityKit Routing

| Task | Use |
|---|---|
| Entity loading, `RealityView` setup, input targets, gestures, hover, manipulation, accessibility, SwiftUI attachments, text/image/video presentation, anchoring, portals, worlds, environment blending, synchronization, `USDStageComponent` bridge | `realitykit-entities-scenes` |
| Mesh display, materials, cameras, lights, shadows, post-processing, Gaussian splats, decals, LOD, occlusion, lightmaps, probes | `realitykit-rendering-materials` |
| Animation clips, character controllers, skeletal poses, IK, body tracking, retargeting, navigation, behavior trees, collision, physics, joints, forces, particles, cloth | `realitykit-animation-physics` |
| Spatial audio, ambient or channel audio, audio libraries, mix groups, reverb, acoustic simulation | `realitykit-audio-spatial` |
| Custom components, systems, ECS queries, registration, update ordering, per-frame multi-entity behavior | `realitykit-ecs-systems` |
| Exact API signatures, whether a symbol exists, platform availability, deprecation | `apple-sdk-lookup` |
| Swift USDKit stage/layer/prim APIs | `usdkit-runtime-developer` |
| Reality Composer Pro 3 Animation Graph / Animator Graph state machines, transitions, clip bindings, and authored graph package inspection | `animationgraph-editor` |
| Reality Composer Pro 3 Script Graph behavior, triggers, action nodes, and authored event logic | `scriptgraph-editor` |
| ShaderGraph or RealityKit material graph editing in USDA | `shadergraph-editor` |
| Authored USD edits or command-line USD inspection | `usd-editor` |
| ARKitSession providers, permissions, and direct anchor stream reconciliation | `arkit-visionos-developer` |
| SwiftUI layout, ornaments, windows, immersive spaces, or targeted gesture ergonomics | `spatial-swiftui-developer` |
| Building, installing, launching, startup logs, or debugger attachment | `build-run-debug` |
| RealityKit profiling, Instruments traces, frame/CPU/GPU/memory bottlenecks, or optimization verification | `realitykit-performance-triage` |

## Load References When

| Reference | When to Use |
|---|---|
| [`references/component-selection.md`](references/component-selection.md) | Choosing between documented RealityKit components, SwiftUI targeted gestures, `SpatialTrackingSession`, ARKit, focused RealityKit skills, and custom ECS work. |
| [`references/component-index.md`](references/component-index.md) | Finding the component category and the owning skill/reference to open next. |

## Guardrails

- Route; do not implement. If you are writing more than a few lines of Swift
  here, the owner was chosen wrong.
- Use `RealityView`; `ARView` is not available on visionOS.
- Prefer documented components before custom ECS.
- Do not describe a component's signature from memory - the owning reference has
  the semantics, and `apple-sdk-lookup` has the exact shape.
- Name the owning skill explicitly in the handoff so the next step is
  unambiguous.

## Skills In Other Plugins

These routes live in other plugins from this marketplace. If one is not
installed, say so plainly and continue with the best available path rather
than stalling or inventing the missing skill's guidance.

| Skill | Plugin |
|---|---|
| `animationgraph-editor` | Build with Reality Composer Pro 3 |
| `arkit-visionos-developer` | Build visionOS 27 apps |
| `build-run-debug` | Build visionOS 27 apps |
| `realitykit-performance-triage` | Profile & Optimize RealityKit |
| `scriptgraph-editor` | Build with Reality Composer Pro 3 |
| `shadergraph-editor` | Build with Reality Composer Pro 3 |
| `spatial-swiftui-developer` | Build visionOS 27 apps |
| `usd-editor` | Build with Reality Composer Pro 3 |

## Output Expectations

State the task category, the owning skill, and why the alternatives were
rejected. Keep it to a few lines.
