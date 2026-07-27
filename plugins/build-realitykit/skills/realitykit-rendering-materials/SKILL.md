---
name: realitykit-rendering-materials
description: Implement and debug RealityKit rendering, materials, lighting, cameras, visual effects, post-processing, render cost controls, Gaussian splats, decals, lightmaps, probes, LOD, and occlusion on visionOS 27. Use for visual correctness, component choice, or implementing a measured rendering fix. Route frame pacing, high GPU cost, missed frames, Metal traces, and performance measurement to realitykit-performance-triage.
---

# RealityKit Rendering Materials

## Quick Start

1. Confirm the issue is visual: mesh display, material assignment, camera
   projection, lighting, shadows, post-processing, splats, decals, LOD,
   occlusion, or probes.
2. Load the narrowest rendering reference that matches the feature.
3. Route ShaderGraph or USDA material graph editing to `shadergraph-editor`.
   Route Reality Composer Pro Script Graph behavior to `scriptgraph-editor`.
4. Route local USD stage rendering through
   `realitykit-visionos-developer`; route USD authoring to `usd-editor`.
5. Validate on device or simulator with concrete visual checks, because many
   rendering issues are asset-, lighting-, or hardware-dependent.

## Load References When

| Reference | When to Use |
|---|---|
| [`references/models-and-cameras.md`](references/models-and-cameras.md) | Mesh rendering, mesh instancing, opacity inheritance, draw-order/z-fighting, debug visualization, adaptive resolution, and cameras. |
| [`references/lighting-and-shadows.md`](references/lighting-and-shadows.md) | Choosing between IBL and analytic lights, what each light responds to, shadow components, grounding shadows, and environment probes. |
| [`references/render-layers-and-shadows.md`](references/render-layers-and-shadows.md) | visionOS 27 named render layers, per-light layer masks, cascaded shadows, projective spotlight textures, surroundings lights. |
| [`references/lightmaps-and-probes.md`](references/lightmaps-and-probes.md) | Baked lightmaps and diffuse probes. |
| [`references/levelofdetailcomponent.md`](references/levelofdetailcomponent.md) | Select content by distance, screen area, or resolution metric. |
| [`references/occlusioncullingcomponent.md`](references/occlusioncullingcomponent.md) | Skip rendering geometry hidden behind opaque occluders. |
| [`references/clippingcomponent.md`](references/clippingcomponent.md) | Clip rendered geometry to a box volume, with optional feathered edges. |
| [`references/tonemappingcomponent.md`](references/tonemappingcomponent.md) and [`references/bloomcomponent.md`](references/bloomcomponent.md) | Tune the filmic tone curve and bloom. |
| [`references/gaussiansplatcomponent.md`](references/gaussiansplatcomponent.md) | Render Gaussian splat captures. |
| [`references/physicallybaseddecalcomponent.md`](references/physicallybaseddecalcomponent.md) | Project physically based decals onto geometry. |

For exact signatures, property lists, enum cases, and availability, query the
installed SDK with `apple-sdk-lookup` rather than relying on recall.

## Cross-Routing

- Use `realitykit-visionos-developer` for entity loading, input, attachments,
  anchoring, portals, synchronization, and local `USDStageComponent`.
- Use `realitykit-animation-physics` when the visual issue is caused by
  animation, blendshape, particle, cloth, collision, or physics state.
- Use `realitykit-ecs-systems` when rendering state is driven by a custom
  component or per-frame system.
- Use `shadergraph-editor` for material graph source edits.
- Use `scriptgraph-editor` for authored RCP behavior that triggers visual
  changes without changing the material graph itself.
- Use `realitykit-performance-triage` when rendering cost has not yet been
  measured or the task requires trace-backed before-and-after verification.

## Guardrails

- Treat visionOS 27 rendering additions as beta API; re-verify symbols against
  the installed SDK before shipping.
- Keep expensive material, mesh, and texture loading asynchronous.
- Validate visual changes with screenshots or simulator/device inspection when
  possible.
- Prefer documented RealityKit components before custom draw or update logic.
- Verify written Swift by building before claiming a rendering fix works.
  Route the build through `build-run-debug`.
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
| `shadergraph-editor` | Build with Reality Composer Pro 3 |
| `usd-editor` | Build with Reality Composer Pro 3 |

## Output Expectations

Provide:

- the rendering category
- which rendering reference files were used
- the chosen component or asset path
- the visual/performance constraint
- the next screenshot, simulator, or device validation step
