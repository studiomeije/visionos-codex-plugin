---
name: scriptgraph-editor
description: Author, inspect, and troubleshoot Reality Composer Pro 3 Script Graph behavior for visionOS assets. Use when editing RCP Script Graph event/action logic, triggers, state-machine-like behavior, scene interactions, entity references, node metadata, `.realitycomposerpro` package graph files, or when deciding whether authored behavior belongs in Script Graph, RealityKit ECS, Shader Graph, Compute Graph, SwiftUI, or app code.
---

# ScriptGraph Editor

## Quick Start

Default to Reality Composer Pro 3 for creating and refining Script Graphs. Use
package inspection only to locate, compare, explain, or minimally repair
authored graph data.

The editable RCP3 project always ends in `.realitycomposerpro`. Treat
`RealityKitContent`, `.rkassets`, and `.reality` as downstream packaging or
runtime artifacts, not as the Script Graph project to modify.

## Load References When

| Reference | When to Use |
|---|---|
| [`references/rcp3-scriptgraph-workflow.md`](references/rcp3-scriptgraph-workflow.md) | When authoring, changing, repairing, or validating Script Graph behavior. |
| [`references/node-metadata-and-package-inspection.md`](references/node-metadata-and-package-inspection.md) | When checking installed RCP3 Script Graph nodes, package internals, or graph files. |
| [`references/runtime-and-skill-boundaries.md`](references/runtime-and-skill-boundaries.md) | When deciding whether behavior belongs in Script Graph, RealityKit ECS, Shader Graph, Compute Graph, SwiftUI, USD, or app code. |

## Workflow

1. Inspect the repo state before touching package content.
2. Locate the RCP package, scene, entity, and graph name the user means.
3. Classify the graph work as trigger, action, conditional branch, state,
   entity reference, custom component interaction, or runtime handoff.
4. Use the installed `ScriptGraphNodeMetadata.plist` to verify node names,
   availability, inputs, and outputs before proposing specific nodes.
5. Prefer RCP UI edits for graph structure; use text/package edits only with a
   small known-good diff, or when the user explicitly needs package repair.
6. Make the smallest graph or package change that preserves existing object
   identifiers and authored structure.
7. Validate by reopening the package in Reality Composer Pro, then validate app
   behavior through the relevant build/run/test skill when runtime behavior
   matters.

## When To Switch Skills

- Switch to `shadergraph-editor` for material Shader Graph nodes, promoted
  material inputs, MaterialX, or `ShaderGraphMaterial`.
- Switch to `realitykit-ecs-systems` when the behavior is custom per-frame app
  logic, testable Swift ECS, or multi-entity runtime coordination.
- Switch to `realitykit-animation-physics` for animation clips, animation
  libraries, retargeting, behavior trees, particles, physics, or cloth.
- Switch to `animationgraph-editor` for authored RCP3 animation state machines,
  transition graphs, clip bindings, or Animation Graph / Animator Graph package
  inspection.
- Switch to `usd-editor` for authored USD prims, composition arcs, transforms,
  or text-level stage edits outside Script Graph data.
- Switch to `swiftpm-visionos` when the issue is `RealityKitContent` package
  wiring rather than graph behavior.
- Switch to `build-run-debug` for Xcode project discovery, build, launch,
  runtime logs, or debugger validation.

## Guardrails

- Do not treat Script Graph as Shader Graph. Script Graph owns authored
  behavior; Shader Graph owns material shading.
- Treat Reality Composer Pro package internals as implementation details. Use
  them for inspection and small repairs, not broad hand-authored rewrites.
- Do not invent a public Swift Script Graph editing API. If no documented API
  exists for the needed runtime behavior, route to authored RCP changes or
  RealityKit ECS code.
- Preserve package object identifiers, entity references, and authored file
  layout unless a known-good diff proves a specific change is safe.
- Direct `.realitycomposerpro` package edits may not hot-reload in Reality
  Composer Pro. Reopen the project or validate through the generated app
  artifact instead of assuming the editor picked up filesystem changes.
- Keep exact entity names, graph names, node type names, custom component type
  names, and bundle/resource paths in the answer.


## Skills In Other Plugins

These routes live in other plugins from this marketplace. If one is not
installed, say so plainly and continue with the best available path rather
than stalling or inventing the missing skill's guidance.

| Skill | Plugin |
|---|---|
| `build-run-debug` | Build visionOS 27 apps |
| `realitykit-animation-physics` | Build with RealityKit |
| `realitykit-ecs-systems` | Build with RealityKit |
| `swiftpm-visionos` | Build visionOS 27 apps |

## Output Expectations

Provide:
- the Script Graph task category
- which RCP package, scene, entity, graph, or node metadata was inspected
- which references were used
- the exact graph or package change proposed or made
- how the change was validated in RCP and, if relevant, in the app runtime
- explicit routing to another skill when Script Graph is not the right owner
