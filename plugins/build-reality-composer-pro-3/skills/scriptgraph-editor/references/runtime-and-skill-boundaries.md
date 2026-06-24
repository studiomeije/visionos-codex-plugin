# Runtime And Skill Boundaries

Use this file when deciding whether Script Graph is the right owner for a
behavior.

## Routing Table

| Task | Use |
|---|---|
| Authored event/action behavior in Reality Composer Pro 3 | `scriptgraph-editor` |
| Authored Animation Graph / Animator Graph state machines in RCP3 | `animationgraph-editor` |
| Material node graphs, promoted material inputs, MaterialX, `ShaderGraphMaterial` | `shadergraph-editor` |
| Compute Graph particles or GPU simulations | `realitykit-animation-physics` |
| Runtime custom components, systems, ECS queries, and per-frame behavior | `realitykit-ecs-systems` |
| Entity loading, `RealityView`, input targets, portals, attachments, synchronization | `realitykit-visionos-developer` |
| SwiftUI windows, ornaments, targeted gestures, and app UI state | `spatial-swiftui-developer` |
| Authored USD prims, composition, transforms, and USDZ validation | `usd-editor` |
| Swift USDKit stage/layer/prim APIs | `usdkit-runtime-developer` |
| Downstream package structure, generated content, and SwiftPM checks | `swiftpm-visionos` |
| Build, launch, simulator logs, debugger, or runtime proof | `build-run-debug` |

## Decision Rules

- Keep designer-authored scene behavior in Script Graph when it is local to RCP
  content and can be maintained visually.
- Move behavior to RealityKit ECS when it needs code review, unit tests,
  networked state, broad entity queries, high-frequency updates, or app-owned
  state.
- Keep material math in Shader Graph. Script Graph should trigger or configure
  behavior, not replace a material graph.
- Use Animation Graph when the authored behavior is animation state, blending,
  transitions, clip selection, or graph parameters.
- Keep USD composition and transform edits in USD unless the behavior is truly
  event/action logic.
- Do not create parallel Swift behavior that fights an existing authored Script
  Graph. Either remove/disable the authored behavior or make Swift the clear
  owner.

## Runtime Validation

For Script Graphs that interact with app code:
- confirm custom RealityKit components and systems are registered before
  loading RCP content
- confirm generated resource bundles are copied into the app target, while
  keeping `.realitycomposerpro` as the editable RCP3 project source
- build the host app after package edits
- launch on Apple Vision Pro Simulator or device when behavior depends on
  input, scene timing, or RealityKit events
- capture logs around trigger emission and action execution when available

If validation requires build or runtime work, switch to `build-run-debug` after
the authored graph change is scoped.
