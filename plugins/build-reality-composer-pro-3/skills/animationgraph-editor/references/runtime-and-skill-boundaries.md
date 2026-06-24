# Runtime And Skill Boundaries

Use this file when deciding whether Animation Graph is the right owner for
animation behavior.

## Routing Table

| Task | Use |
|---|---|
| Authored Animation Graph / Animator Graph state machines in RCP3 | `animationgraph-editor` |
| Runtime `AnimationGraphResource`, `AnimationGraphComponent`, retargeting, root motion, IK, blendshapes, or animation libraries | `realitykit-animation-physics` |
| Authored RCP3 event/action logic that triggers animation playback | `scriptgraph-editor` |
| Runtime custom components, systems, ECS queries, and per-frame behavior | `realitykit-ecs-systems` |
| Behavior Tree authoring or runtime behavior selection | `realitykit-animation-physics` |
| Material node graphs, promoted material inputs, MaterialX, `ShaderGraphMaterial` | `shadergraph-editor` |
| Entity loading, `RealityView`, input targets, portals, attachments, synchronization | `realitykit-visionos-developer` |
| SwiftUI windows, ornaments, targeted gestures, and app UI state | `spatial-swiftui-developer` |
| Authored USD prims, composition, transforms, time samples, and USDZ validation | `usd-editor` |
| Downstream package structure, generated content, and SwiftPM checks | `swiftpm-visionos` |
| Build, launch, simulator logs, debugger, or runtime proof | `build-run-debug` |

## Decision Rules

- Keep designer-authored animation state machines in Animation Graph when they
  are local to RCP content and can be maintained visually.
- Move behavior to RealityKit runtime APIs when graph definitions are generated
  from data, validated in Swift, or controlled by app-owned state.
- Move behavior to ECS when animation depends on networked state, broad entity
  queries, high-frequency updates, or testable app logic.
- Use Script Graph to trigger animation actions; do not use Script Graph as a
  substitute for authored animation state machines.
- Keep USD time samples and authored transforms in USD unless the behavior is
  truly graph-state logic.
- Do not create parallel Swift animation state that fights an existing authored
  Animation Graph. Either remove/disable the authored graph or make Swift the
  clear owner.

## Runtime Validation

For Animation Graphs that interact with app code:
- confirm `AnimationGraphComponent` appears on the expected entity
- confirm custom RealityKit components and systems are registered before
  loading RCP content
- confirm generated resource bundles are copied into the app target, while
  keeping `.realitycomposerpro` as the editable RCP3 project source
- build the host app after package edits
- launch on Apple Vision Pro Simulator or device when behavior depends on
  input, scene timing, or RealityKit events
- capture logs around graph validation, active state changes, clip selection,
  and root-motion handling when available

If validation requires build or runtime work, switch to `build-run-debug` after
the authored graph change is scoped.
