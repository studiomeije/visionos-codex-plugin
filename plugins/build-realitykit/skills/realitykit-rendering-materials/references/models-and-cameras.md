# Models, Instancing, Draw Order, and Cameras

Semantics and gotchas. For exact signatures, defaults, and availability, query
the SDK with `apple-sdk-lookup`.

## ModelComponent

The mesh plus its materials - the foundation of anything visible.
`boundsMargin` widens the entity's bounding box for visibility determination;
raise it when a vertex shader or deformer pushes geometry outside the authored
bounds and the model culls too early.

`ModelComponent` takes a `MeshResource`, not a `MeshResource.Contents`. When
generating geometry, build the resource first:

```swift
let mesh = try MeshResource.generate(from: contents)
entity.components.set(ModelComponent(mesh: mesh, materials: [material]))
```

To update geometry on an entity that already renders, replace in place rather
than rebuilding the component - `try model.mesh.replace(with: contents)`.

## MeshInstancesComponent

Renders many copies of one mesh far more cheaply than one entity per copy. Use
it for crowds, foliage, and debris fields.

Two things surprise people:

- It carries **no `materials:` argument**. Materials still come from the
  `ModelComponent` on the same entity.
- Transforms live in a `LowLevelInstanceData` buffer, not an array of
  `Transform`. It is a reference type, so per-frame updates rewrite the buffer
  in place instead of rebuilding the component.

```swift
let data = try LowLevelInstanceData(instanceCount: 100)
data.withMutableTransforms { transforms in
    for i in 0..<transforms.count {
        transforms[i] = Transform(translation: [Float(i) * 0.5, 0, 0]).matrix
    }
}
entity.components.set(try MeshInstancesComponent(mesh: mesh, instances: data))
entity.components.set(ModelComponent(mesh: mesh, materials: [material]))
```

`MeshInstanceCollection` is a different type for a different job - instancing
*within* a mesh resource, keyed by `MeshResource.Instance`. It uses
`insert(_:)` / `update(_:)` / `remove(id:)`, not `add(_:)`.

## OpacityComponent

`opacity` (0...1) multiplies across **the entity and all its descendants**, and
nested opacity components multiply together - a 0.5 parent over a 0.5 child
renders at 0.25. That inheritance is the point: fade a subtree by putting one
component on its root rather than touching every material.

It affects all visual components, `ParticleEmitterComponent` included, and needs
a material that supports transparency to show anything.

## ModelSortGroupComponent

Fixes z-fighting and transparency ordering by pinning draw order explicitly.
Reach for it when two coplanar surfaces flicker, or when semi-transparent
content composites in the wrong order - not as a general layering tool. For
depth *layout* on the SwiftUI side, that is `spatial-swiftui-developer`.

## ModelDebugOptionsComponent

Development-only visualization of geometry, materials, and rendering state. It
costs performance and must not ship - strip it, do not merely disable it.

## AdaptiveResolutionComponent

Lets RealityKit lower an entity's render resolution as it gets farther from the
viewer. The system manages the decision; there is nothing meaningful to tune.
Treat it as an opt-in hint for distant content, and measure the result rather
than assuming a win - see `realitykit-performance-triage`.

## Cameras

On visionOS the system owns the camera. A custom camera component has little
effect in a shared space or immersive space; treat these as primarily useful for
offscreen rendering, non-visionOS targets, and `RealityRenderer` work.

- `PerspectiveCameraComponent` - `near` (must be `> 0` and `< far`), `far`, and
  `fieldOfViewInDegrees` (vertical, default 60). Horizontal FOV is derived from
  aspect ratio. Geometry outside `near`/`far` is clipped.
- `OrthographicCameraComponent` - no field of view; `orthographicScale` sets the
  size of the visible region and therefore the zoom. Object size is independent
  of distance, which is what makes it right for measured or diagrammatic views.
- `ProjectiveTransformCameraComponent` - custom projection matrix. Sparsely
  documented; confirm it exists and behaves in the installed SDK before building
  on it, and prefer the two standard cameras when they suffice.
