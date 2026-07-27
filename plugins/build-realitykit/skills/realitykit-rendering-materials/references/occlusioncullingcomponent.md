# OcclusionCullingComponent

## Overview

A component that opts an entity into occlusion culling, so geometry fully hidden behind other opaque geometry is skipped instead of rendered. The component is a single switch (`isEnabled`); RealityKit performs the visibility determination.

New in visionOS 27. Beta API: names and shapes may change before release.

## How to Use

### Enable Culling

```swift
import RealityKit

entity.components.set(OcclusionCullingComponent(isEnabled: true))
```

### Toggle at Runtime

```swift
var culling = entity.components[OcclusionCullingComponent.self]!
culling.isEnabled = false
entity.components.set(culling)
```

## Key Properties

- `isEnabled: Bool` - Whether occlusion culling applies to the entity

## Important Notes

- New in visionOS 27; also available on macOS 27, iOS 27, tvOS 27,
  and macCatalyst 27.
- Occlusion culling skips rendering work for hidden geometry; it does not
  disable the entity - systems, physics, and audio continue to run.
- Culling effectiveness depends on having solid occluders in front of the
  culled content; transparent or cut-out materials make poor occluders.
- The component carries no tuning parameters in the current interface; it is
  purely opt-in/opt-out per entity.
