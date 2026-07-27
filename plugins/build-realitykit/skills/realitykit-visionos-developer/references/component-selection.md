# RealityKit Component Selection

Use this file before choosing a RealityKit component, switching to a focused
RealityKit skill, or inventing a new ECS type. Prefer documented components
when they match the behavior.

## Core Interaction

- [`InputTargetComponent`](../../realitykit-entities-scenes/references/interaction-and-accessibility.md): make an entity eligible
  for input and hit testing.
- [`CollisionComponent`](../../realitykit-animation-physics/references/collisioncomponent.md):
  provide shapes for hit testing and physics contacts.
- [`HoverEffectComponent`](../../realitykit-entities-scenes/references/interaction-and-accessibility.md): add system hover
  affordances.
- [`ManipulationComponent`](../../realitykit-entities-scenes/references/interaction-and-accessibility.md): use built-in direct
  manipulation before writing a custom transform stack.
- SwiftUI targeted gestures: use documented targeted gestures, such as
  `TapGesture().targetedToEntity(...)`, for entity-specific tap handling.
- [`GestureComponent`](../../realitykit-entities-scenes/references/interaction-and-accessibility.md): attach a UI gesture to the entity
  as RealityKit component state when that ownership model is more natural than
  a SwiftUI view modifier.

## Presentation and UI

- [`ViewAttachmentComponent`](../../realitykit-entities-scenes/references/attachments-and-presentation.md): attach SwiftUI-backed
  views as RealityKit entities when direct entity ownership is natural.
- `RealityView` attachments builder: prefer this for declarative SwiftUI-owned
  attachments inside a `RealityView`.
- [`TextComponent`](../../realitykit-entities-scenes/references/attachments-and-presentation.md): render text inside the entity graph.
- [`ImagePresentationComponent`](../../realitykit-entities-scenes/references/attachments-and-presentation.md): present image
  content in RealityKit.
- [`VideoPlayerComponent`](../../realitykit-entities-scenes/references/attachments-and-presentation.md): present AVPlayer-backed
  video in RealityKit.

## Scene Content and Rendering

- [`ModelComponent`](../../realitykit-rendering-materials/references/models-and-cameras.md):
  render meshes and materials.
- [`OpacityComponent`](../../realitykit-rendering-materials/references/models-and-cameras.md):
  control entity opacity.
- [`ImageBasedLightComponent`](../../realitykit-rendering-materials/references/lighting-and-shadows.md)
  and
  [`ImageBasedLightReceiverComponent`](../../realitykit-rendering-materials/references/lighting-and-shadows.md):
  configure image-based lighting.
- [`GroundingShadowComponent`](../../realitykit-rendering-materials/references/lighting-and-shadows.md):
  use system grounding shadows where appropriate.
- `realitykit-rendering-materials`: use this skill for cameras, lights,
  shadows, materials, post-processing, splats, decals, lightmaps, probes,
  LOD, occlusion, or render-cost controls.

## Audio

- `AudioFileResource` with audio components: load and play spatial or channel
  audio.
- `realitykit-audio-spatial`: use this skill for spatial audio, ambient audio,
  channel audio, audio libraries, mix groups, reverb, grouped playback, or
  acoustic simulation.

## Tracking and Anchoring

- [`SpatialTrackingSession`](../../realitykit-entities-scenes/references/spatialtrackingsession.md): use when
  RealityKit-managed anchoring is enough.
- `ARKitSession`: use `arkit-visionos-developer` when the app needs provider
  streams, explicit authorization, or direct anchor-update reconciliation.
- [`AnchoringComponent`](../../realitykit-entities-scenes/references/anchoringcomponent.md) and
  [`ARKitAnchorComponent`](../../realitykit-entities-scenes/references/entity-structure-and-lifecycle.md): use for RealityKit-owned
  anchor component state.

## Animation and Physics

- `realitykit-animation-physics`: use this skill for animation clips,
  character controllers, skeletal poses, IK, body tracking, blendshapes,
  runtime animation graphs, retargeting, root motion, navigation, behavior trees,
  collision, physics bodies, joints, forces, particles, compute simulations,
  and cloth.
- `animationgraph-editor`: use this skill for authored Reality Composer Pro 3
  Animation Graph / Animator Graph state machines, transitions, clip bindings,
  graph parameters, and `.realitycomposerpro` graph inspection.

## New in visionOS 27

All entries below are new in visionOS 27; beta API names and shapes may change
before release.

- Rendering: use `realitykit-rendering-materials` for
  [`GaussianSplatComponent`](../../realitykit-rendering-materials/references/gaussiansplatcomponent.md),
  [`ToneMappingComponent`](../../realitykit-rendering-materials/references/tonemappingcomponent.md),
  [`BloomComponent`](../../realitykit-rendering-materials/references/bloomcomponent.md),
  [`PhysicallyBasedDecalComponent`](../../realitykit-rendering-materials/references/physicallybaseddecalcomponent.md),
  [`ClippingComponent`](../../realitykit-rendering-materials/references/clippingcomponent.md),
  [`LevelOfDetailComponent`](../../realitykit-rendering-materials/references/levelofdetailcomponent.md),
  [`OcclusionCullingComponent`](../../realitykit-rendering-materials/references/occlusioncullingcomponent.md),
  [`render layers and shadows`](../../realitykit-rendering-materials/references/render-layers-and-shadows.md),
  and [`lightmaps and probes`](../../realitykit-rendering-materials/references/lightmaps-and-probes.md).
- Animation and physics: use `realitykit-animation-physics` for
  [`cloth simulation`](../../realitykit-animation-physics/references/cloth-simulation.md),
  [`ComputeGraph` particles](../../realitykit-animation-physics/references/compute-graph-particles.md),
  runtime [`animation graphs and retargeting`](../../realitykit-animation-physics/references/animation-graphs-and-retargeting.md),
  and
  [`navigation and behavior trees`](../../realitykit-animation-physics/references/navigation-and-behavior-trees.md).
- Audio: use `realitykit-audio-spatial` for
  [`audio groups and acoustics`](../../realitykit-audio-spatial/references/audio-groups-and-acoustics.md).
- Local USD rendering: use
  [`USDStageComponent`](../../realitykit-entities-scenes/references/usdstagecomponent.md). For Swift USDKit authoring, use
  `usdkit-runtime-developer`; for authored USD edits or command-line
  inspection, use `usd-editor`.
- Portals and accessory anchoring: use
  [`portal-volumes-and-accessory-anchoring.md`](../../realitykit-entities-scenes/references/portal-volumes-and-accessory-anchoring.md).

## Custom ECS Boundary

Create a custom `Component` or `System` only when documented components do not
represent the needed state or behavior. Use `realitykit-ecs-systems` for
custom components, systems, registration, ECS queries, and per-frame behavior:

- [`custom-components.md`](../../realitykit-ecs-systems/references/custom-components.md)
- [`custom-systems.md`](../../realitykit-ecs-systems/references/custom-systems.md)
- [`systemandcomponentcreation.md`](../../realitykit-ecs-systems/references/systemandcomponentcreation.md)
