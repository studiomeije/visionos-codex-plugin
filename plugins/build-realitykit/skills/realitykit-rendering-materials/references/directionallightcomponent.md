# DirectionalLightComponent


## Overview

A component that adds a directional light source with parallel rays, similar to sunlight. Directional lights illuminate everything uniformly from a direction, and their orientation (not position) determines the light direction. This is ideal for simulating sunlight or other distant light sources.

## When to Use

- Simulating sunlight or other distant light sources
- Creating consistent scene-wide lighting
- Implementing day/night cycles by rotating the light
- Adding primary lighting to outdoor or large scenes
- Creating dramatic lighting effects with shadows

## How to Use

### Basic Setup

```swift
import RealityKit

// Create a directional light (sun)
var sun = DirectionalLightComponent()
sun.color = .white
sun.intensity = 1.0
entity.components.set(sun)

// Set orientation to control light direction
entity.orientation = simd_quatf(angle: .pi / 4, axis: [1, 0, 0])  // 45 degrees
```

### With Shadows

```swift
// Create directional light with shadow support
var sun = DirectionalLightComponent()
sun.color = .white
sun.intensity = 1.0

entity.components.set(sun)

// Shadow is its own Component; set it on the same entity.
// On visionOS, use shadowProjection rather than the deprecated
// maximumDistance property.
var shadow = DirectionalLightComponent.Shadow()
shadow.shadowProjection = .automatic(maximumDistance: 50.0)
shadow.depthBias = 0.01

entity.components.set(shadow)
```

### Real-World Proxy

`isRealWorldProxy` is unavailable on visionOS. On Apple Vision Pro, real-world
lighting comes from the automatic environment IBL and from
`ImageBasedLightComponent` / `EnvironmentLightingConfigurationComponent`; see
[`imagebasedlightcomponent.md`](imagebasedlightcomponent.md).

## Key Properties

- `color: Color` - The color of the light (default: white)
- `intensity: Float` - The brightness of the light
- `layers: RenderLayer.Set` - which render layers this light illuminates
  (visionOS 27)
- `DirectionalLightComponent.Shadow` - a separate `Component`, not a property.
  Carries `shadowProjection` (`.automatic(maximumDistance:)` or
  `.fixed(zNear:zFar:orthographicScale:)`), `depthBias`, `cullModeOverride`,
  `cascades` (visionOS 27), and `layers` (visionOS 27).
- `isRealWorldProxy: Bool` - unavailable on visionOS; other Apple platforms only

### Shadow Properties

- `maximumDistance: Float` - Maximum distance for shadow casting
- `depthBias: Float` - Depth bias to prevent shadow acne

## Important Notes

- Directional lights act like the sun - orientation matters, not position
- Typically only **one** directional light per scene (multiple may not work as expected)
- Supports shadows (depth-map shadows) when configured
- The light direction is determined by the entity's orientation
- Position doesn't affect lighting - only orientation matters
- Available on iOS, macOS, and visionOS (with limitations on visionOS)
- In visionOS, Image-Based Lighting (IBL) is more consistently supported

## Best Practices

- Use only one directional light per scene for primary lighting
- Set orientation to control light direction (e.g., simulate sun position)
- Configure shadows appropriately - they can be performance-intensive
- Use `isRealWorldProxy` for mixed reality experiences
- Consider Image-Based Lighting for visionOS experiences
- Test on target platforms - support varies by platform
- Use appropriate intensity values for realistic lighting
- Combine with `DynamicLightShadowComponent` on entities that should cast shadows

## Related Components

- `PointLightComponent` - For localized light sources
- `SpotLightComponent` - For focused cone-shaped lighting
- `ImageBasedLightComponent` - For environment lighting (preferred on visionOS)
- `DynamicLightShadowComponent` - For per-entity shadow control
- `GroundingShadowComponent` - For grounding shadows
