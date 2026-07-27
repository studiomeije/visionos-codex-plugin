# Entity Structure, Attachment Points, and Lifecycle

Semantics and gotchas. For exact signatures and availability, query the SDK with
`apple-sdk-lookup`. For loading entities from assets, see
[`entity-loading-and-stored-entities.md`](entity-loading-and-stored-entities.md).

## Attaching One Entity To Another

Three mechanisms, in increasing cost - pick the cheapest that works.

1. **`addChild()`** - static relative placement. Simplest and cheapest; use it
   unless you need one of the below.
2. **`AttachedTransformComponent`** - keeps the entity's `source` pin (or its
   origin when `source` is `nil`) aligned to a `GeometricPin` on a target,
   including pins bound to **skeletal joints**. Use it to track a socket on a
   moving or animated rig. `Entity.attach(_:to:)` is shorthand for setting it.

   The system drives the attached entity's transform. Do **not** also parent it
   to the target or write its transform each frame - that fights the system.
3. **`BillboardComponent`** - continuously reorients the entity to face the
   viewer. For labels, sprites, and flat UI that must stay readable from any
   angle. Pair it with flat geometry; billboarding a solid object looks wrong.

## TransientComponent

Marks content as temporary. A transient entity is **not persisted across
sessions, not synchronized to other participants, and does not survive anchor
state changes**. Use it for effects, previews, and debug content so cleanup is
automatic - and make sure you have *not* used it on anything the user expects to
come back.

## ReferenceComponent

Defers loading an external entity asset until it is needed. Useful for trimming
initial load, but it is thinly documented and varies by SDK version - confirm it
exists in the installed SDK before depending on it. `Entity(named:in:)` at the
point of need is the predictable alternative.

## SynchronizationComponent

Opts an entity into replication across participants in a shared session; state
changes propagate automatically through `scene.synchronizationService`.

The transport is the constraint, not the component. On iOS this pairs with a
collaborative ARKit session; **`ARWorldTrackingConfiguration` and `ARView` do
not exist on visionOS**, where shared sessions come from SharePlay
GroupActivities instead - see `shareplay-developer`.

Entities marked `TransientComponent` are excluded from synchronization.

## DockingRegionComponent

Marks where the **system video player** docks inside a custom immersive
environment, so AVKit playback lands in your scene instead of floating in front
of the wearer. The owning entity's position and orientation define the docked
screen; `width` is the only placement property.

It does not snap arbitrary entities - for object snapping use
`ManipulationComponent` or a custom system. Keep one active docking region per
environment. visionOS only.

## ARKitAnchorComponent

Attached automatically to an `AnchorEntity` once it anchors, exposing the raw
ARKit anchor behind the RealityKit abstraction. Observe `AnchorStateEvents` such
as `DidAnchor` rather than polling.

`anchor` is typed `any ARKit.Anchor`. Cast to the **visionOS** anchor types -
`PlaneAnchor`, `AccessoryAnchor`, `MeshAnchor`, `ImageAnchor`, `ObjectAnchor`,
`RoomAnchor`, `WorldAnchor`. The iOS-era `ARPlaneAnchor` / `ARAnchor` class
names do not exist here. visionOS 26.0+ only.

## SceneUnderstandingComponent

Lets an entity interact with the reconstructed real environment - walls, floors,
obstacles - for collision, physics, and occlusion.

It does nothing on its own: the capabilities must be requested when the session
starts, via `SpatialTrackingSession.Configuration(tracking:sceneUnderstanding:)`
with `.collision`, `.physics`, `.occlusion`, or `.shadow`. `sceneUnderstanding`
is an initializer argument, not a settable property, and `run(_:)` returns the
capabilities it could **not** provide - check that return value instead of
assuming. See
[`spatialtrackingsession.md`](spatialtrackingsession.md).

Pair with `EnvironmentBlendingComponent` for occlusion by real geometry; see
[`portals-and-worlds.md`](portals-and-worlds.md).
