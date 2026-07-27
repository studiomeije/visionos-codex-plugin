# BodyTrackingComponent

> **Not available on visionOS.** `BodyTrackingComponent` and
> `ARBodyTrackingConfiguration` are marked unavailable in the visionOS SDK, and
> `ARView` does not exist on visionOS at all. Code on this page will not compile
> for an Apple Vision Pro target. It is kept for cross-platform RealityKit work
> on iOS, iPadOS, macOS, and macCatalyst.
>
> **On visionOS, use instead:** ARKit `HandTrackingProvider` for hands (see
> `arkit-visionos-developer`), `SkeletalPosesComponent` and `IKComponent` to
> drive a rig, and `AnchoringComponent` `.head` / `.hand` targets for
> body-relative placement.

## Overview

A component that integrates ARKit body tracking data with RealityKit entities
on iOS and iPadOS. It enables full-body tracking using ARKit's body tracking
capabilities, allowing entities to reflect real-world body poses and movements.
This component works with `ARBodyTrackingConfiguration` to provide skeleton and
joint information.

## When to Use

Only on iOS / iPadOS (and Catalyst / macOS builds that host an `ARView`):

- Creating virtual characters that mirror real-world body movements
- Implementing full-body tracking experiences
- Animating entities based on ARKit body pose data
- Creating avatars that follow user movements
- Building fitness or movement tracking applications

## How to Use (iOS / iPadOS only)

### Basic Setup with ARKit

```swift
#if os(iOS)
import RealityKit
import ARKit

// Set up ARKit body tracking
let configuration = ARBodyTrackingConfiguration()
arView.session.run(configuration)

// Create entity with body tracking component
let avatar = Entity()
avatar.components.set(BodyTrackingComponent())
#endif
```

### Checking Body Tracking Support

```swift
#if os(iOS)
// Check if body tracking is available
if ARBodyTrackingConfiguration.isSupported {
    let configuration = ARBodyTrackingConfiguration()
    arView.session.run(configuration)

    entity.components.set(BodyTrackingComponent())
} else {
    // Body tracking not available on this device
}
#endif
```

### Accessing Body Tracking Data

```swift
#if os(iOS)
// Access body tracking information
if let bodyTracking = entity.components[BodyTrackingComponent.self] {
    // Access body joints, skeleton, etc.
    _ = bodyTracking
}
#endif
```

## Key Properties

- Properties depend on ARKit body tracking integration
- Provides access to body joints and skeleton information
- Reflects real-world body pose data from ARKit

## Important Notes

- Unavailable on visionOS and tvOS
- Requires ARKit body tracking support (hardware and software)
- Works with `ARBodyTrackingConfiguration`, which is also unavailable on visionOS
- Available on supported devices (typically newer iPhones and iPads)
- Requires appropriate `Info.plist` permissions
- Body tracking data comes from ARKit, not RealityKit directly
- Check `ARBodyTrackingConfiguration.isSupported` before use

## Best Practices

- Guard the whole feature behind `#if os(iOS)` in a cross-platform target
- Check for body tracking support before attempting to use it
- Request appropriate permissions in `Info.plist`
- Handle cases where body tracking is not available gracefully
- Combine with `SkeletalPosesComponent` for skeleton manipulation
- Update entity poses based on body tracking data each frame

## Related Components

- `SkeletalPosesComponent` - available on visionOS 2.0+; use it to drive a rig
  from whatever pose source the platform supports
- `IKComponent` - solve limb placement from a small number of targets
- `AnimationLibraryComponent` - for blending tracked pose with keyframe animations
- `AnchoringComponent` - `.head` and `.hand` targets for body-relative placement
  on visionOS
