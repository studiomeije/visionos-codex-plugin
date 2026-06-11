# RealityKit Reference Map

Load this file first when you need to decide which detailed component file to
open next. Categories marked "new in visionOS 27" cover the 27 additions; that
API is beta and names may change before release.

## Category Routing

- Rendering and appearance:
  `modelcomponent`, `modelsortgroupcomponent`, `opacitycomponent`,
  `adaptiveresolutioncomponent`, `meshinstancescomponent`,
  `blendshapeweightscomponent`
- Rendering and appearance (new in visionOS 27):
  `gaussiansplatcomponent`, `tonemappingcomponent`, `bloomcomponent`,
  `physicallybaseddecalcomponent`, `clippingcomponent`,
  `levelofdetailcomponent`, `occlusioncullingcomponent`
- Interaction:
  `inputtargetcomponent`, `manipulationcomponent`, `gesturecomponent`,
  `hovereffectcomponent`, `accessibilitycomponent`, `billboardcomponent`
- Anchoring and spatial:
  `anchoringcomponent`, `arkitanchorcomponent`,
  `sceneunderstandingcomponent`, `dockingregioncomponent`,
  `referencecomponent`, `attachedtransformcomponent`
- Cameras:
  `perspectivecameracomponent`, `orthographiccameracomponent`,
  `projectivetransformcameracomponent`
- Lighting and shadows:
  `pointlightcomponent`, `directionallightcomponent`, `spotlightcomponent`,
  `imagebasedlightcomponent`, `groundingshadowcomponent`,
  `dynamiclightshadowcomponent`, `environmentlightingconfigurationcomponent`,
  `virtualenvironmentprobecomponent`
- Lighting and shadows (new in visionOS 27):
  `render-layers-and-shadows`, `lightmaps-and-probes`
- Audio:
  `spatialaudiocomponent`, `ambientaudiocomponent`,
  `channelaudiocomponent`, `audiolibrarycomponent`, `reverbcomponent`,
  `audiomixgroupscomponent`
- Audio (new in visionOS 27):
  `audio-groups-and-acoustics`
- Animation and character:
  `animationlibrarycomponent`, `charactercontrollercomponent`,
  `charactercontrollerstatecomponent`, `skeletalposescomponent`,
  `ikcomponent`, `bodytrackingcomponent`
- Animation and behavior (new in visionOS 27):
  `animation-graphs-and-retargeting`, `navigation-and-behavior-trees`
- Physics and collision:
  `collisioncomponent`, `physicsbodycomponent`, `physicsmotioncomponent`,
  `physicssimulationcomponent`, `particleemittercomponent`,
  `forceeffectcomponent`, `physicsjointscomponent`,
  `geometricpinscomponent`
- Physics and simulation (new in visionOS 27):
  `cloth-simulation`, `compute-graph-particles`
- Portals and environments:
  `portalcomponent`, `worldcomponent`, `portalcrossingcomponent`,
  `environmentblendingcomponent`
- Portals and environments (new in visionOS 27):
  `portal-volumes-and-accessory-anchoring`
- Presentation and UI:
  `viewattachmentcomponent`, `presentationcomponent`, `textcomponent`,
  `imagepresentationcomponent`, `videoplayercomponent`
- Tracking:
  `spatialtrackingsession`
- Networking and sync:
  `synchronizationcomponent`, `transientcomponent`
- USD stages and export (new in visionOS 27):
  `usdstagecomponent`

## Custom ECS Work

- Use [custom-components.md](custom-components.md) for per-entity data types.
- Use [custom-systems.md](custom-systems.md) for per-frame or query-driven
  behavior.
