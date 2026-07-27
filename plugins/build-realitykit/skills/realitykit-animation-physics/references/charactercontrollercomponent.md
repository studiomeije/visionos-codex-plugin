# CharacterControllerComponent

## Overview

A component that enables character movement and physics behavior for player-controlled characters in RealityKit. It handles movement, collision detection, ground detection, slope limits, and step limits. The character controller uses a capsule-shaped collider and provides collision information for responsive character movement.

## How to Use

### Basic Setup

```swift
import RealityKit

// Create a character controller with capsule collider
let characterController = CharacterControllerComponent(
    radius: 0.3,        // Capsule radius
    height: 1.8,        // Capsule height
    skinWidth: 0.01,    // Buffer to avoid getting stuck
    slopeLimit: 0.7,    // Max slope angle (radians)
    stepLimit: 0.3,     // Max step height
    upVector: [0, 1, 0], // Up direction
    collisionFilter: .default
)
entity.components.set(characterController)
```

### Character Movement

Movement is driven by `Entity.moveCharacter(by:deltaTime:relativeTo:)`, not by a
method on the component. It returns `CollisionFlags` and optionally reports each
contact through a handler.

```swift
// Move character and handle collisions
@MainActor
func moveCharacter(_ entity: Entity, direction: SIMD3<Float>, deltaTime: Float, speed: Float) {
    let movement = direction * deltaTime * speed

    let flags = entity.moveCharacter(
        by: movement,
        deltaTime: deltaTime,
        relativeTo: entity.parent
    ) { collision in
        // Handle collision response:
        // collision.hitEntity, collision.hitPosition, collision.hitNormal
        _ = collision.hitEntity
    }

    // CollisionFlags: .none, .side, .top, .bottom
    if flags.contains(.bottom) {
        // Standing on something
    }
}
```

### With State Component

`CharacterControllerStateComponent` is written by the simulation. Its
properties are `let` - read them, do not assign them - and the grounded flag is
`isOnGround`, not `isGrounded`.

```swift
// Read the state the character controller published this frame
if let state = entity.components[CharacterControllerStateComponent.self] {
    if state.isOnGround {
        // Allow jumping
    } else {
        // Character is in air; state.velocity has the current velocity
    }
}
```

## Key Properties

### Initializer Parameters

- `radius: Float` - The radius of the character's capsule collider
- `height: Float` - The height of the capsule collider
- `skinWidth: Float` - Buffer around the collider to avoid getting stuck on surfaces
- `slopeLimit: Float` - Maximum slope angle the character can walk up (in radians)
- `stepLimit: Float` - Maximum height the character can step up over
- `upVector: SIMD3<Float>` - Defines which direction is 'up' in your scene (typically [0, 1, 0])
- `collisionFilter: CollisionFilter` - Specifies which collision groups the character interacts with

### Collision Information

- `hitPosition: SIMD3<Float>` - World-space position where collision was detected
- `hitEntity: Entity?` - The entity that was hit
- `hitNormal: SIMD3<Float>` - Normal vector of the collision surface
- `moveDirection: SIMD3<Float>` - Direction of movement
- `moveDistance: Float` - Distance moved

## Important Notes

- Uses a capsule-shaped collider for character collision
- Requires `CollisionComponent` on scene geometry for collision detection
- Movement is driven by `Entity.moveCharacter(by:deltaTime:relativeTo:)`, which
  returns `CollisionFlags`; there is no move method on the component
- Collision information arrives through the move call's collision handler
- Works with `CharacterControllerStateComponent` to track character state
- Available on iOS, macOS, and visionOS
