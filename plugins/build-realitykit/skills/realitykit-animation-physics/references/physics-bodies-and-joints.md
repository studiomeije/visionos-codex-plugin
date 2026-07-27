# Physics Bodies, Motion, Joints, and Pins

Semantics and wiring rules. For exact signatures, defaults, and availability,
query the SDK with `apple-sdk-lookup`. Collision shapes have their own page -
see [`collisioncomponent.md`](collisioncomponent.md).

## The Required Component Set

Physics only runs when the pieces are all present. This is the most common
reason "nothing moves":

| Goal | Components required |
|---|---|
| Participate in simulation at all | `PhysicsBodyComponent` **and** `CollisionComponent` |
| Be moved by code | add `PhysicsMotionComponent` |
| Be constrained to another body | `PhysicsJointsComponent` plus pins on both entities |

`ModelEntity` already carries a physics body by default; a bare `Entity` does
not.

## PhysicsBodyComponent

`mode` decides who drives the transform:

- `.dynamic` - the solver moves it. Forces, gravity, and collisions apply.
- `.kinematic` - you move it; it pushes dynamic bodies but ignores forces.
- `.static` - never moves. Cheapest; use it for world geometry.

Other behavior worth knowing:

- `isAffectedByGravity`, `linearDamping` / `angularDamping` (how quickly motion
  bleeds off), and `material` (friction and restitution).
- `isTranslationLocked` / `isRotationLocked` are per-axis `(Bool, Bool, Bool)`
  tuples - use them instead of fighting the solver with counter-forces.
- `isContinuousCollisionDetectionEnabled` guards fast bodies against tunnelling
  through thin geometry.
- **Non-uniform scale is only supported for box, convex mesh, and triangle mesh
  shapes.** Under a non-uniformly scaled entity, avoid children with rotations -
  the result is undefined rather than merely wrong-looking.

## PhysicsMotionComponent

Sets `linearVelocity` (m/s) and `angularVelocity` (rad/s) directly. It has
**no effect on a `.static` body**, and the values it holds are integrated each
step, then reduced by the damping configured on the physics body. Very large
velocities cause instability and tunnelling - raise continuous collision
detection instead of the velocity cap.

## PhysicsSimulationComponent

Declares a simulation space on an **anchor**, so anchored content can run its
own physics rather than the scene's. Carries `collisionOptions`. Pair it with
`AnchoringComponent`, and use `nearestSimulationEntity(for:)` to find which
simulation a given entity actually belongs to - it is easy to add a body to one
space and expect it to collide with another.

## Joints And Pins

A joint connects two bodies at **pins** - named points with a position and
orientation, defined relative to each entity.

```swift
entityA.pins.set(named: "hinge", position: [0, 0.5, 0])
entityB.pins.set(named: "hinge", position: [0, -0.5, 0])
```

Pins live on `Entity.pins` (with subscript lookup and `remove(named:)`);
`GeometricPinsComponent` is the storage behind them. They also drive
`AttachedTransformComponent`.

`PhysicsCustomJoint` constrains each axis independently through
`linearMotionAlongX/Y/Z` and `angularMotionAroundX/Y/Z`, each one of:

- `.fixed` - locked
- `.free` - unconstrained
- `.range(ClosedRange<Float>)` - limited travel

A hinge is every axis `.fixed` except one angular axis set `.free` or
`.range(...)`. Both entities need a `PhysicsBodyComponent` or the joint silently
does nothing.

## Verifying

Physics is timing- and order-dependent. Drive it with deterministic inputs when
testing, and state whether a result came from simulator or device. For cost -
solver iterations, contact counts, joint complexity - route to
`realitykit-performance-triage` rather than guessing.
