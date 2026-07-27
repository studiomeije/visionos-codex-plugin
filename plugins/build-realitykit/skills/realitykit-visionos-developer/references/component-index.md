# RealityKit Reference Map

Load this file from `realitykit-visionos-developer` when you need to decide
which RealityKit skill or detailed component file to open next. Categories
marked "new in visionOS 27" cover beta API; names may change before release.

## Core Scene, Entity, Input, and Spatial References

These stay with `realitykit-visionos-developer`:

- Component choice:
  [`component-selection.md`](component-selection.md)
- Entity and asset loading:
  [`entity-loading-and-stored-entities.md`](../../realitykit-entities-scenes/references/entity-loading-and-stored-entities.md)
- Interaction:
  [`inputtargetcomponent.md`](../../realitykit-entities-scenes/references/interaction-and-accessibility.md),
  [`manipulationcomponent.md`](../../realitykit-entities-scenes/references/interaction-and-accessibility.md),
  [`gesturecomponent.md`](../../realitykit-entities-scenes/references/interaction-and-accessibility.md),
  [`hovereffectcomponent.md`](../../realitykit-entities-scenes/references/interaction-and-accessibility.md),
  [`accessibilitycomponent.md`](../../realitykit-entities-scenes/references/interaction-and-accessibility.md),
  [`billboardcomponent.md`](../../realitykit-entities-scenes/references/entity-structure-and-lifecycle.md)
- Anchoring and spatial:
  [`anchoringcomponent.md`](../../realitykit-entities-scenes/references/anchoringcomponent.md),
  [`arkitanchorcomponent.md`](../../realitykit-entities-scenes/references/entity-structure-and-lifecycle.md),
  [`sceneunderstandingcomponent.md`](../../realitykit-entities-scenes/references/entity-structure-and-lifecycle.md),
  [`dockingregioncomponent.md`](../../realitykit-entities-scenes/references/entity-structure-and-lifecycle.md),
  [`referencecomponent.md`](../../realitykit-entities-scenes/references/entity-structure-and-lifecycle.md),
  [`attachedtransformcomponent.md`](../../realitykit-entities-scenes/references/entity-structure-and-lifecycle.md),
  [`spatialtrackingsession.md`](../../realitykit-entities-scenes/references/spatialtrackingsession.md)
- Presentation and attachments:
  [`viewattachmentcomponent.md`](../../realitykit-entities-scenes/references/attachments-and-presentation.md),
  [`presentationcomponent.md`](../../realitykit-entities-scenes/references/attachments-and-presentation.md),
  [`textcomponent.md`](../../realitykit-entities-scenes/references/attachments-and-presentation.md),
  [`imagepresentationcomponent.md`](../../realitykit-entities-scenes/references/attachments-and-presentation.md),
  [`videoplayercomponent.md`](../../realitykit-entities-scenes/references/attachments-and-presentation.md)
- Portals and environments:
  [`portalcomponent.md`](../../realitykit-entities-scenes/references/portals-and-worlds.md),
  [`worldcomponent.md`](../../realitykit-entities-scenes/references/portals-and-worlds.md),
  [`portalcrossingcomponent.md`](../../realitykit-entities-scenes/references/portals-and-worlds.md),
  [`environmentblendingcomponent.md`](../../realitykit-entities-scenes/references/portals-and-worlds.md),
  [`portal-volumes-and-accessory-anchoring.md`](../../realitykit-entities-scenes/references/portal-volumes-and-accessory-anchoring.md)
- Networking and sync:
  [`synchronizationcomponent.md`](../../realitykit-entities-scenes/references/entity-structure-and-lifecycle.md),
  [`transientcomponent.md`](../../realitykit-entities-scenes/references/entity-structure-and-lifecycle.md)
- USD bridge:
  [`usdstagecomponent.md`](../../realitykit-entities-scenes/references/usdstagecomponent.md)

## Focused RealityKit Skills

- Rendering and materials:
  `realitykit-rendering-materials`
  - [`modelcomponent.md`](../../realitykit-rendering-materials/references/models-and-cameras.md)
  - [`modelsortgroupcomponent.md`](../../realitykit-rendering-materials/references/models-and-cameras.md)
  - [`opacitycomponent.md`](../../realitykit-rendering-materials/references/models-and-cameras.md)
  - [`adaptiveresolutioncomponent.md`](../../realitykit-rendering-materials/references/models-and-cameras.md)
  - [`meshinstancescomponent.md`](../../realitykit-rendering-materials/references/models-and-cameras.md)
  - New in visionOS 27:
    [`gaussiansplatcomponent.md`](../../realitykit-rendering-materials/references/gaussiansplatcomponent.md),
    [`tonemappingcomponent.md`](../../realitykit-rendering-materials/references/tonemappingcomponent.md),
    [`bloomcomponent.md`](../../realitykit-rendering-materials/references/bloomcomponent.md),
    [`physicallybaseddecalcomponent.md`](../../realitykit-rendering-materials/references/physicallybaseddecalcomponent.md),
    [`clippingcomponent.md`](../../realitykit-rendering-materials/references/clippingcomponent.md),
    [`levelofdetailcomponent.md`](../../realitykit-rendering-materials/references/levelofdetailcomponent.md),
    [`occlusioncullingcomponent.md`](../../realitykit-rendering-materials/references/occlusioncullingcomponent.md)
- Cameras, lighting, shadows, and probes:
  `realitykit-rendering-materials`
  - [`perspectivecameracomponent.md`](../../realitykit-rendering-materials/references/models-and-cameras.md)
  - [`orthographiccameracomponent.md`](../../realitykit-rendering-materials/references/models-and-cameras.md)
  - [`projectivetransformcameracomponent.md`](../../realitykit-rendering-materials/references/models-and-cameras.md)
  - [`pointlightcomponent.md`](../../realitykit-rendering-materials/references/lighting-and-shadows.md)
  - [`directionallightcomponent.md`](../../realitykit-rendering-materials/references/lighting-and-shadows.md)
  - [`spotlightcomponent.md`](../../realitykit-rendering-materials/references/lighting-and-shadows.md)
  - [`imagebasedlightcomponent.md`](../../realitykit-rendering-materials/references/lighting-and-shadows.md)
  - [`imagebasedlightreceivercomponent.md`](../../realitykit-rendering-materials/references/lighting-and-shadows.md)
  - [`groundingshadowcomponent.md`](../../realitykit-rendering-materials/references/lighting-and-shadows.md)
  - [`dynamiclightshadowcomponent.md`](../../realitykit-rendering-materials/references/lighting-and-shadows.md)
  - [`environmentlightingconfigurationcomponent.md`](../../realitykit-rendering-materials/references/lighting-and-shadows.md)
  - [`virtualenvironmentprobecomponent.md`](../../realitykit-rendering-materials/references/lighting-and-shadows.md)
  - New in visionOS 27:
    [`render-layers-and-shadows.md`](../../realitykit-rendering-materials/references/render-layers-and-shadows.md),
    [`lightmaps-and-probes.md`](../../realitykit-rendering-materials/references/lightmaps-and-probes.md)
- Animation, characters, navigation, and physics:
  `realitykit-animation-physics`
  - [`animationlibrarycomponent.md`](../../realitykit-animation-physics/references/animation-and-skeleton.md)
  - [`blendshapeweightscomponent.md`](../../realitykit-animation-physics/references/animation-and-skeleton.md)
  - [`charactercontrollercomponent.md`](../../realitykit-animation-physics/references/charactercontrollercomponent.md)
  - [`charactercontrollerstatecomponent.md`](../../realitykit-animation-physics/references/animation-and-skeleton.md)
  - [`skeletalposescomponent.md`](../../realitykit-animation-physics/references/animation-and-skeleton.md)
  - [`ikcomponent.md`](../../realitykit-animation-physics/references/ikcomponent.md)
  - [`bodytrackingcomponent.md`](../../realitykit-animation-physics/references/bodytrackingcomponent.md)
  - [`collisioncomponent.md`](../../realitykit-animation-physics/references/collisioncomponent.md)
  - [`physicsbodycomponent.md`](../../realitykit-animation-physics/references/physics-bodies-and-joints.md)
  - [`physicsmotioncomponent.md`](../../realitykit-animation-physics/references/physics-bodies-and-joints.md)
  - [`physicssimulationcomponent.md`](../../realitykit-animation-physics/references/physics-bodies-and-joints.md)
  - [`particleemittercomponent.md`](../../realitykit-animation-physics/references/particleemittercomponent.md)
  - [`forceeffectcomponent.md`](../../realitykit-animation-physics/references/forceeffectcomponent.md)
  - [`physicsjointscomponent.md`](../../realitykit-animation-physics/references/physics-bodies-and-joints.md)
  - [`geometricpinscomponent.md`](../../realitykit-animation-physics/references/physics-bodies-and-joints.md)
  - New in visionOS 27:
    [`animation-graphs-and-retargeting.md`](../../realitykit-animation-physics/references/animation-graphs-and-retargeting.md),
    [`navigation-and-behavior-trees.md`](../../realitykit-animation-physics/references/navigation-and-behavior-trees.md),
    [`cloth-simulation.md`](../../realitykit-animation-physics/references/cloth-simulation.md),
    [`compute-graph-particles.md`](../../realitykit-animation-physics/references/compute-graph-particles.md)
- Audio:
  `realitykit-audio-spatial`
  - [`spatialaudiocomponent.md`](../../realitykit-audio-spatial/references/audio-components.md)
  - [`ambientaudiocomponent.md`](../../realitykit-audio-spatial/references/audio-components.md)
  - [`channelaudiocomponent.md`](../../realitykit-audio-spatial/references/audio-components.md)
  - [`audiolibrarycomponent.md`](../../realitykit-audio-spatial/references/audio-components.md)
  - [`reverbcomponent.md`](../../realitykit-audio-spatial/references/audio-components.md)
  - [`audiomixgroupscomponent.md`](../../realitykit-audio-spatial/references/audio-components.md)
  - New in visionOS 27:
    [`audio-groups-and-acoustics.md`](../../realitykit-audio-spatial/references/audio-groups-and-acoustics.md)
- Custom ECS:
  `realitykit-ecs-systems`
  - [`custom-components.md`](../../realitykit-ecs-systems/references/custom-components.md)
  - [`custom-systems.md`](../../realitykit-ecs-systems/references/custom-systems.md)
  - [`systemandcomponentcreation.md`](../../realitykit-ecs-systems/references/systemandcomponentcreation.md)
