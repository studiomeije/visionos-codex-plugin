# Animation Libraries, Skeletons, and Blend Shapes

Semantics and gotchas. For exact signatures, defaults, and availability, query
the SDK with `apple-sdk-lookup`. For animation graphs, retargeting, and root
motion see
[`animation-graphs-and-retargeting.md`](animation-graphs-and-retargeting.md).

## AnimationLibraryComponent

Holds the animations that shipped **with the asset**. Entities loaded from USD
or from a Reality Composer Pro `.reality` file usually already have it - the
library is authored upstream, not built in code, so if an expected clip is
missing the fix is normally in the asset pipeline rather than in Swift.

- `animations` is keyed by name, so look clips up by their authored names.
- `defaultAnimation` / `defaultKey` give the clip to play when the caller has no
  opinion.
- `unkeyedResources` holds clips that arrived without queryable names - if the
  clip you want is in there, it was not named in the source asset.

The library survives saving an entity back to `.reality`.

## SkeletalPosesComponent

Direct access to a skinned mesh's joints. Entities with a skinned mesh imported
from USD already carry it; you rarely add it by hand.

- `poses` is a `SkeletalPoseSet`; the initializer takes `[SkeletalPose]`.
- **Joint transforms are in local space, relative to the parent joint.** Writing
  world-space transforms here is the usual cause of a rig collapsing.
- Writes take effect on the next render - this is the hook for procedural
  animation, and for layering an IK or physics result on top of a clip.

Combine with `IKComponent` when you want the solver to place limbs from a small
number of targets rather than authoring every joint.

## BlendShapeWeightsComponent

Morph-target weights for facial animation and mesh deformation. The mesh must
already define blend shapes in the asset; the component only drives them.

The API is a set, not a plain dictionary: construct with
`init(weightsMapping:)` and read or write through `weightSet`. Multiple shapes
can be active at once, and weights interpolate, so drive them from a curve
rather than snapping between values.

## CharacterControllerStateComponent

The character controller writes this every frame; you only read it. The
component has exactly two properties, both `let`:

- `isOnGround: Bool` - grounded this frame. Note the spelling; there is no
  `isGrounded`.
- `velocity: SIMD3<Float>` - the controller's current velocity.

There is no `isWalkingUpSlope`, `isStepping`, or `collision` property. Slope and
step behavior is *configured* on `CharacterControllerComponent` (`slopeLimit`,
`stepLimit`), and contact details arrive through the collision handler passed to
`Entity.moveCharacter(by:deltaTime:relativeTo:)` - see
[`charactercontrollercomponent.md`](charactercontrollercomponent.md).
