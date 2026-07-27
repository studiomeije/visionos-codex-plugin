# ARKitAnchorComponent


## Overview

A component that attaches ARKit anchor data to RealityKit entities (`AnchorEntity`). It allows accessing raw ARKit anchor properties—such as extents, transforms, and classifications—while using RealityKit abstractions. This component provides access to the underlying ARKit anchor when you need detailed anchor information.

visionOS 26.0+, and unavailable on every other platform. `anchor` is typed
`any ARKit.Anchor`, so cast to the **visionOS** anchor types - `PlaneAnchor`,
`AccessoryAnchor`, `MeshAnchor`, `ImageAnchor`, `ObjectAnchor`, `RoomAnchor`,
`HandAnchor`, `WorldAnchor`. The iOS-era `ARPlaneAnchor` / `ARAnchor` class
names do not exist on visionOS.

## When to Use

- Accessing detailed ARKit anchor properties (extents, classification, etc.)
- Inspecting plane anchor information (size, alignment, etc.)
- Accessing accessory anchor data
- Getting raw ARKit anchor transforms and properties
- Implementing custom anchor processing logic
- Accessing anchor-specific data not exposed by RealityKit abstractions

## How to Use

### Basic Setup

```swift
import RealityKit
import ARKit

// AnchorEntity automatically gets ARKitAnchorComponent when anchored
let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: [0.1, 0.1]))
```

### Accessing Anchor Data

```swift
// Access ARKit anchor component after anchoring
content.subscribe(to: SceneEvents.AnchoredStateChanged.self) { event in
    if event.isAnchored {
        if let arkitAnchor = event.entity.components[ARKitAnchorComponent.self] {
            // Access ARKit anchor data
            if let planeAnchor = arkitAnchor.anchor as? PlaneAnchor {
                print("Plane size: \(planeAnchor.geometry.extent)")
                print("Plane alignment: \(planeAnchor.alignment)")
            }
        }
    }
}
```

### Plane Anchor Information

```swift
// Get plane anchor details
if let arkitComponent = entity.components[ARKitAnchorComponent.self],
   let planeAnchor = arkitComponent.anchor as? PlaneAnchor {
    // Extent exposes width/height, not x/z
    let width = planeAnchor.geometry.extent.width
    let height = planeAnchor.geometry.extent.height
    let alignment = planeAnchor.alignment  // .horizontal, .vertical, .slanted
}
```

### Accessory Anchor

```swift
// Access accessory anchor data
if let arkitComponent = entity.components[ARKitAnchorComponent.self],
   let accessoryAnchor = arkitComponent.anchor as? AccessoryAnchor {
    let isTracked = accessoryAnchor.isTracked
    let chirality = accessoryAnchor.heldChirality
    _ = (isTracked, chirality)
}
```

## Key Properties

- `anchor: any ARKit.Anchor` - The underlying ARKit anchor. Cast to a concrete
  visionOS anchor type such as `PlaneAnchor`, `AccessoryAnchor`, `MeshAnchor`,
  `ImageAnchor`, `ObjectAnchor`, `RoomAnchor`, or `WorldAnchor`.

### PlaneAnchor Properties

- `geometry.extent` - Size of the plane (width, height)
- `alignment` - Plane alignment (`.horizontal` or `.vertical`)
- `center` - Center position of the plane
- `transform` - Transform matrix of the anchor

## Important Notes

- Automatically attached to `AnchorEntity` when it becomes anchored
- Access via `AnchorStateEvents` like `DidAnchor` when anchor state changes
- Can be cast to specific anchor types (`PlaneAnchor`, `AccessoryAnchor`, etc.)
- Provides access to ARKit-specific data not in RealityKit abstractions
- visionOS 26.0+ only - unavailable on iOS, macOS, macCatalyst, and tvOS
- Works with `AnchoringComponent` for anchor management

## Best Practices

- Access anchor data through `AnchorStateEvents` for reliable timing
- Cast to specific anchor types to access type-specific properties
- Use for detailed anchor information when RealityKit abstractions aren't sufficient
- Handle different anchor types appropriately
- Combine with `AnchoringComponent` for complete anchor management
- Test anchor access on target platforms

## Related Components

- `AnchoringComponent` - For anchoring entities to real-world targets
- `SceneUnderstandingComponent` - For scene understanding data
- `CollisionComponent` - For collision with anchored content
