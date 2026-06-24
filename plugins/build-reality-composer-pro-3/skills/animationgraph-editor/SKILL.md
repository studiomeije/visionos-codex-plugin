---
name: animationgraph-editor
description: Author, inspect, and troubleshoot Reality Composer Pro 3 Animation Graph and Animator Graph content for visionOS assets. Use when editing authored RCP3 animation state machines, blend transitions, graph parameters, animation clip bindings, animation graph components, `.realitycomposerpro` package graph files, or when deciding whether animation behavior belongs in an authored Animation Graph, RealityKit runtime animation APIs, Script Graph, Behavior Tree, SwiftUI, or app code.
---

# AnimationGraph Editor

## Quick Start

Default to Reality Composer Pro 3 for creating and refining Animation Graphs.
Use package inspection only to locate, compare, explain, or minimally repair
authored graph data.

1. Identify whether the task is authored graph state, transition behavior,
   clip binding, parameter/tag state, package inspection, runtime validation,
   or cross-skill routing.
2. Confirm the owner: the editable RCP3 project always ends in
   `.realitycomposerpro`. Treat `RealityKitContent`, `.rkassets`, and
   `.reality` as downstream packaging or runtime artifacts, not as the
   Animation Graph project to modify.
3. Load only the matching reference files.
4. Prefer RCP UI edits for graph structure; use text/package edits only when
   you have a small known-good diff or the user explicitly needs package
   repair.
5. Validate by reopening the project in Reality Composer Pro and, when runtime
   behavior matters, by building or launching the visionOS app.

## Load References When

| Reference | When to Use |
|---|---|
| [`references/rcp3-animationgraph-workflow.md`](references/rcp3-animationgraph-workflow.md) | When authoring, changing, repairing, or validating Animation Graph behavior. |
| [`references/schema-and-package-inspection.md`](references/schema-and-package-inspection.md) | When checking installed RCP3 schema handles, package internals, graph files, or component references. |
| [`references/runtime-and-skill-boundaries.md`](references/runtime-and-skill-boundaries.md) | When deciding whether animation behavior belongs in RCP3 Animation Graphs, RealityKit runtime APIs, Script Graph, Behavior Tree, SwiftUI, USD, or app code. |

## Workflow

1. Inspect the repo state before touching package content.
2. Locate the `.realitycomposerpro` project, scene, entity, animation graph,
   and clip/resource names the user means.
3. Classify the graph work as state machine, transition, blend, parameter,
   tag, clip binding, root motion, IK/pose integration, or runtime handoff.
4. Use installed RCP3 schema/package handles to verify available graph
   concepts before proposing a concrete package edit.
5. Make the smallest graph or package change that preserves existing object
   identifiers, animation resources, entity references, and authored layout.
6. Validate the package in Reality Composer Pro, then validate app behavior
   through the relevant build/run/test skill if needed.

## When To Switch Skills

- Switch to `realitykit-animation-physics` for runtime
  `AnimationGraphResource`, `AnimationGraphComponent`, animation libraries,
  retargeting, root motion, IK, skeletal poses, body tracking, blendshapes,
  behavior trees, particles, physics, or cloth.
- Switch to `scriptgraph-editor` for authored RCP3 event/action behavior that
  triggers animations but does not define animation state machines.
- Switch to `realitykit-ecs-systems` when animation state is app-owned Swift
  ECS, requires tests, or coordinates many entities at runtime.
- Switch to `usd-editor` for authored USD prims, transforms, time samples, or
  composition outside RCP3 graph data.
- Switch to `swiftpm-visionos` when the issue is package wiring rather than
  graph behavior.
- Switch to `build-run-debug` for Xcode project discovery, build, launch,
  runtime logs, or debugger validation.

## Guardrails

- Do not treat Animation Graph as Script Graph. Animation Graph owns authored
  animation state and transitions; Script Graph owns event/action behavior.
- Do not treat Animation Graph as Shader Graph. Material shading belongs in
  `shadergraph-editor`.
- Treat Reality Composer Pro package internals as implementation details. Use
  them for inspection and small repairs, not broad hand-authored rewrites.
- Do not invent a public Swift API for editing authored RCP3 Animation Graphs.
  If the behavior must be generated or controlled at runtime, route to
  RealityKit animation APIs or ECS code.
- Preserve package object identifiers, animation clip resource names, entity
  references, graph parameter names, and authored file layout unless a
  known-good diff proves a specific change is safe.
- Direct `.realitycomposerpro` package edits may not hot-reload in Reality
  Composer Pro. Reopen the project or validate through the generated app
  artifact instead of assuming the editor picked up filesystem changes.

## Output Expectations

Provide:
- the Animation Graph task category
- which RCP project, scene, entity, graph, clip, parameter, or schema handle
  was inspected
- which references were used
- the exact graph or package change proposed or made
- how the change was validated in RCP and, if relevant, in the app runtime
- explicit routing to another skill when Animation Graph is not the right owner
