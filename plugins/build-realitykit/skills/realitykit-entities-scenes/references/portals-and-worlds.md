# Portals, Worlds, and Environment Blending

Semantics and wiring rules. For exact signatures and availability, query the SDK
with `apple-sdk-lookup`. For the visionOS 27 volumetric portal additions, see
[`portal-volumes-and-accessory-anchoring.md`](portal-volumes-and-accessory-anchoring.md).

## A Portal Is Three Pieces

A portal never works from one component. All three must line up:

1. **`WorldComponent`** on the root of the content you want to hide. Everything
   under a world is invisible in the normal scene - it can only be seen through
   a portal. The component has no properties; it is a marker. One per world
   root, and several portals may target the same world.
2. **`PortalComponent`** on the geometry you look through, with `target` set to
   that world root.
3. **`PortalMaterial`** on the portal geometry, or it will not render as an
   opening.

If content is invisible everywhere, the usual cause is a `WorldComponent` with
no portal pointing at it.

## Clipping And Crossing

`clippingMode` (for example `.plane(.positiveZ)`) must be **aligned with the
portal geometry**. A mismatched clipping plane is the standard reason a portal
shows the wrong half of its world.

`crossingMode` decides what happens at the boundary:

- Left off, entities are simply masked - visible only while entirely on the
  portal's visible side.
- Enabled, entities can transition across the portal surface. Each entity that
  should participate also needs `PortalCrossingComponent`; the crossing behavior
  is tied to the portal's plane.

## EnvironmentBlendingComponent

Lets **static** real-world geometry occlude virtual content, so a virtual object
can sit convincingly behind a real table.

The constraints matter more than the API:

- Works only in a **mixed or immersive space** - not in a volume, not in a
  window.
- Only **static** surroundings occlude. People and other moving objects will
  not.
- The entity is treated as part of the background environment, and
  virtual-to-virtual layering still wins: other virtual content draws in front
  of an occluded entity.
- visionOS only.

Modes: `.default` (normal virtual content) and `.occluded(by: .surroundings)`.
