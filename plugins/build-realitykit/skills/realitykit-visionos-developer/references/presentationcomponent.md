# PresentationComponent


## Overview

A component that integrates SwiftUI content as a popover presentation attached to a RealityKit entity. This helps bridge 2D SwiftUI view content into 3D spatial contexts, allowing entities to present SwiftUI modals or system UI in a spatially-aware manner.

## When to Use

- Presenting SwiftUI modals from 3D entities
- Showing popovers triggered by entity interactions
- Integrating SwiftUI UI into spatial experiences
- Creating interactive UI that appears from entities
- Presenting system UI from spatial interactions
- Building spatially-aware presentation flows

## How to Use

### Basic Setup

```swift
import RealityKit
import SwiftUI

// `content:` takes a View value, not a closure.
let presentation = PresentationComponent(
    configuration: .popover(arrowEdge: .bottom),
    content: VStack {
        Text("Entity Info")
        Button("Close") { }
    }
    .padding()
)
entity.components.set(presentation)
```

### With Popover

```swift
// Drive presentation from a Binding<Bool>
let presentation = PresentationComponent(
    isPresented: $isShowingDetail,
    configuration: .popover(arrowEdge: .top),
    content: MySwiftUIView()
)
entity.components.set(presentation)

// Toggle presentation
if var presentation = entity.components[PresentationComponent.self] {
    presentation.isPresented = true
    entity.components[PresentationComponent.self] = presentation
}
```

### There Is No `.sheet` Configuration

`PresentationComponent.Configuration` exposes only `.popover(arrowEdge:)` in
the visionOS 27 SDK. For sheet-style presentation, present a SwiftUI sheet from
the owning window/scene instead, or open a separate window. Use the popover for
content that must stay attached to the entity.

```swift
let presentation = PresentationComponent(
    configuration: .popover(arrowEdge: nil),
    content: NavigationStack {
        MyDetailView()
    }
)
entity.components.set(presentation)
```

## Key Properties

- `isPresented: Bool` - toggles the presentation on/off

### Initializers

- `init(configuration:content:)` - `content` is a **View value**, not a
  view-builder closure
- `init(isPresented:configuration:content:)` - drives presentation from a
  `Binding<Bool>`

### Configuration Types

- `.popover(arrowEdge: Edge?)` - the only configuration in the visionOS 27 SDK

## Important Notes

- Allows 3D entities to show SwiftUI content in spatially-aware presentation modes
- Works in spatial contexts and immersive spaces
- visionOS only - unavailable on iOS, macOS, and tvOS
- Bridges SwiftUI UI into RealityKit spatial experiences

## Best Practices

- Use appropriate presentation configuration for your use case
- Toggle `isPresented` to show/hide presentations
- Design SwiftUI content to work well in spatial contexts
- Test presentation behavior in immersive spaces
- Consider spatial positioning when presenting from entities
- Use for modal UI that should appear from entity interactions

## Related Components

- `ViewAttachmentComponent` - For embedding SwiftUI views directly in 3D space
- `InputTargetComponent` - For making entities interactive to trigger presentations
- `ImagePresentationComponent` - For displaying images
- `VideoPlayerComponent` - For video playback
