---
name: spatial-swiftui-developer
description: Design and implement visionOS 27 SwiftUI scenes and 3D data visualizations. Use when building spatial UI with RealityView, Model3D, attachments, volumetric windows, ImmersiveSpace, spatial gestures, windowing, spatial layout, Chart3D, SurfacePlot, 3D chart marks, or Chart3DPose.
---

# Spatial SwiftUI Developer

## Quick Start

If the task is really about surface choice, scene ownership, or file
structure, switch to `spatial-app-architecture` first.

Pick the rendering track early: `Model3D` for simple asset display,
`RealityView` for custom entity graphs and attachments.

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`swiftui-spatial-overview.md`](references/swiftui-spatial-overview.md) | When you need the general feature map, examples, and routing guidance for this skill. |
| [`model3d.md`](references/model3d.md) | When using `Model3D` for async model loading, assets, animation, or manipulation. |
| [`realityview.md`](references/realityview.md) | When setting up `RealityView`, attachments, or RealityKit integration patterns. |
| [`interaction.md`](references/interaction.md) | When implementing gestures or manipulation patterns for spatial input. |
| [`buttons-and-controls.md`](references/buttons-and-controls.md) | When implementing visible SwiftUI buttons, links styled as buttons, toolbars, forms, or control surfaces. |
| [`swiftui-scene-lifecycle.md`](references/swiftui-scene-lifecycle.md) | When checking official `Window`, `WindowGroup`, `ImmersiveSpace`, open/dismiss, restoration, and launch contracts. |
| [`windowing-immersion.md`](references/windowing-immersion.md) | When managing windows, volumetric surfaces, or immersive space transitions. |
| [`spatial-layout.md`](references/spatial-layout.md) | When using SwiftUI spatial layout APIs, sizing, or debug tools. |
| [`charts-3d.md`](references/charts-3d.md) | When implementing Chart3D, SurfacePlot, 3D marks, axes, scales, or camera pose. |

## Workflow

1. Confirm the architecture and scene ownership are already settled.
2. Choose the rendering surface: `Model3D`, `RealityView`, window, volume,
   or immersive scene.
3. Load only the matching reference files.
4. Implement the smallest viable scene, keeping loading async and RealityKit
   mutations inside their intended entry points.
5. Build to verify, then summarize the chosen SwiftUI-to-RealityKit
   integration path. Route build, launch, simulator, and test problems to
   `build-run-debug`.

## Guardrails

- Every visible button gets an explicit `.buttonBorderShape(...)` (`.capsule`
  for labeled actions, `.circle` for icon-only,
  `.roundedRectangle(radius:)` matching the background for card-like
  buttons - on visionOS this is also what shapes the button's hover
  highlight). Non-button hover surfaces pair `.hoverEffect()` with a matching
  `.contentShape(.hoverEffect, ...)`. Load
  [`buttons-and-controls.md`](references/buttons-and-controls.md) before
  writing any control code - this applies even when buttons are incidental to
  a larger task.
- Keep RealityKit loads async; do not block the main actor with asset or entity loading.
- Mutate RealityKit content in `RealityView` make or update closures or in a
  system, not in SwiftUI body code.
- Use `Model3D` only when you need simple display and layout, not a custom ECS graph.
- Treat `ImmersiveSpace` as a separate scene with its own lifecycle and environment actions.
- Use `defaultSize` as an initial hint only; the system can clamp or restore geometry.
- Use [`charts-3d.md`](references/charts-3d.md) for Chart3D and spatial data visualization.
- Switch to `build-run-debug` when the question is about launch, build,
  simulator, codesign, or debugging workflow.
- Use `spatial-app-architecture` when the question is about scene boundaries,
  ownership, or feature decomposition rather than API usage.
- visionOS 27 SwiftUI adds no new scene, volume, or immersion APIs; the
  guidance here is current for visionOS 27. New in 27: gesture `inputKinds:`
  filtering (see `interaction.md`) plus cross-platform toolbar and navigation
  refinements that also apply on visionOS.
- Verify written Swift by building. SwiftUI/RealityKit API on visionOS 27
  is beta and shifts between seeds; do not report a change as done until the
  scheme compiles. Route the build through `build-run-debug`.
- Apply `coding-standards-enforcer` to Swift you write here: Swift 6.2 strict
  concurrency, actor isolation, `Sendable`, and `@Observable` ownership.

## Output Expectations

Provide:
- the chosen rendering and scene path
- which references were used
- the API surface involved (`Model3D`, `RealityView`, `Chart3D`, windowing,
  interaction, or layout)
- the main implementation constraint or pitfall
- routing back to architecture or build/debug if needed
