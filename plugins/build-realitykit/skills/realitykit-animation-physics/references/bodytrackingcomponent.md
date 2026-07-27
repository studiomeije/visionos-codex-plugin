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
