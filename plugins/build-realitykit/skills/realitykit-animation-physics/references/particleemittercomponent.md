# ParticleEmitterComponent

## Overview

A component that generates particle systems—tiny visual elements like sparks, smoke, fire, rain, etc.—attached to entities in a scene. Particle emitters create visual effects by spawning many small particles that can have various properties like color, velocity, lifespan, and billboard behavior.

## How to Use

### Basic Setup

There is no `ParticleEmitterComponent(emitter:)` initializer. Create the
component with `ParticleEmitterComponent()` and configure the nested emitter
through `mainEmitter` (or `spawnedEmitter` for the secondary burst).

```swift
import RealityKit

// Create the component, then configure its main emitter
var component = ParticleEmitterComponent()

component.mainEmitter.color = .constant(.single(.red))
component.mainEmitter.lifeSpan = 2.0        // Particles live for 2 seconds
component.mainEmitter.billboardMode = .billboard  // Face the camera

entity.components.set(component)
```

### Spark Effect

Emission-shape properties live on the **component**, not on the nested
`ParticleEmitter`.

```swift
var component = ParticleEmitterComponent()
component.mainEmitter.color = .constant(.single(.yellow))
component.mainEmitter.lifeSpan = 0.5

component.spawnSpreadFactor = 0.3
component.radialAmount = 5.0
component.burstCountVariation = 10

entity.components.set(component)
```

### Smoke Effect

```swift
var component = ParticleEmitterComponent()
component.mainEmitter.color = .constant(.single(.gray))
component.mainEmitter.lifeSpan = 3.0
component.mainEmitter.billboardMode = .billboard

component.spawnSpreadFactor = 0.1
component.radialAmount = 2.0

entity.components.set(component)
```

## Key Properties

### ParticleEmitterComponent Properties

- `mainEmitter: ParticleEmitter` - the primary emitter configuration
- `spawnedEmitter: ParticleEmitter?` - secondary emitter spawned from particles
- `emitterShape` / `emitterShapeSize` - the volume particles spawn from
- `spawnSpreadFactor: Float` (and `spawnSpreadFactorVariation`) - how much
  particles spread out spatially when spawned
- `radialAmount: Float` - how strongly particles spread radially from the
  emission origin
- `burstCount: Int` / `burstCountVariation: Int` - burst size and its randomness
- `isEmitting: Bool`, `simulationState`, `speed`, `speedVariation`

### ParticleEmitter (`mainEmitter`) Properties

- `color` - particle color (e.g. `.constant(.single(.red))`)
- `lifeSpan: Double` (and `lifeSpanVariation`) - how long each particle lives
- `billboardMode: BillboardMode` - `.billboard`, `.billboardYAligned`, or
  `.free(axis:variation:)`. There is no `.viewPlaneAligned`.
- `birthRate`, `size`, `sizeVariation`, `opacityCurve`, `blendMode`
- `sortOrder: SortOrder` - rendering order among particles

## Important Notes

- Particles are attached to an entity and inherit transforms
- Some versions may have offset issues from the parent entity
- Particle properties can be constants, curves, or enums depending on the effect
- Available on visionOS, iOS, and other Apple platforms
- Particle systems can impact performance - use judiciously
