# SwiftUI Spatial Layout

## Context

SwiftUI spatial layout APIs let you measure, align, and compose views in three dimensions for visionOS. `GeometryReader3D` reads a view's available size and coordinate space including depth, and returns a flexible preferred size and depth to its parent. `ZStack` composes child depths the way `VStack` composes child heights, and can use `spacing` to separate adjacent children along the depth axis. `SpatialContainer` is a layout container that aligns overlapping content in 3D space and sizes itself to the maximum dimension of its children. `spatialOverlay(alignment:content:)` adds secondary views within a view's 3D bounds, stacking multiple overlays depthwise using a `SpatialContainer`. `rotation3DLayout` rotates a view while updating its layout frame to account for the rotation, which can change the view's layout size.

## ZStack Depth Decision Guide

- Start with the layout question. If children are true layers in a 3D stack, use
  `ZStack(alignment:spacing:)` so SwiftUI composes the depth and can resize the
  parent correctly.
- If a child needs an explicit depth budget, wrap it in
  `frame(depth:alignment:)` before layering it. This is useful for panels,
  labels, selection affordances, and bounded 3D previews.
- If the whole row or column should align on a depth plane, use
  `HStackLayout().depthAlignment(...)` or `VStackLayout().depthAlignment(...)`
  instead of giving every child its own z offset.
- If an element only needs a hover-like lift or a shadow-card separation, apply
  `offset(z:)` to the element itself and keep the value small.
- If an overlay belongs to a model's bounds, prefer
  `spatialOverlay(alignment:content:)` over a sibling `ZStack` layer.
- If several overlapping elements must be aligned inside one 3D space, prefer
  `SpatialContainer` over nested `ZStack` offsets.
- Check clipping in windows and volumes. Content outside the proposed or fixed
  depth can be clipped by the system.

## Code Examples

Every sample below uses shipped SwiftUI API only.

#### Robot image frame

```swift
Image("RobotHead")
  .border(.red)
```

#### Color frame

```swift
Color.blue
  .border(.red)
```

#### Layout composed frame

```swift
VStack {
  Image("RobotHead")
    .border(.red)
  Image("RobotHead")
    .border(.red)
}
.border(.yellow)
```

#### Zero depth views

2D views have no depth of their own, so they contribute nothing to a `ZStack`'s
depth budget.

```swift
HStack {
  Image("RobotHead")
  Text("Hello! I'm a piece of text. I have 0 depth.")
  Color.blue
    .frame(width: 200, height: 200)
}
```

#### Giving a RealityView a fixed depth

A `RealityView` will otherwise take all available depth in its container.

```swift
RealityView { content in
  // Setup RealityView content
}
.frame(depth: 200, alignment: .front)
```

#### Reading depth with GeometryReader3D

```swift
GeometryReader3D { proxy in
  Model3D(named: "Robot")
    .frame(depth: proxy.size.depth / 2, alignment: .back)
}
```

#### Model3D scaledToFit3D

```swift
Model3D(url: robotURL) { resolved in
  resolved.resizable()
} placeholder: {
  ProgressView()
}
.scaledToFit3D()
```

#### ZStack depth

```swift
ZStack(alignment: .center, spacing: 16) {
  Model3D(named: "LargeRobot")
  Model3D(named: "BabyBot")
}
```

#### Stable card and label depth

```swift
ZStack(alignment: .center, spacing: 8) {
  RoundedRectangle(cornerRadius: 12)
    .fill(.regularMaterial)
    .frame(width: 260, height: 160)
    .frame(depth: 12, alignment: .back)

  Text("Battery 82%")
    .font(.headline)
    .padding(16)
    .glassBackgroundEffect()
    .frame(depth: 4, alignment: .front)
    .offset(z: 6)
}
```

#### Front-aligned controls beside 3D content

```swift
HStackLayout().depthAlignment(.front) {
  Model3D(named: "Robot") { resolved in
    resolved.resizable()
  } placeholder: {
    ProgressView()
  }
  .scaledToFit3D()
  .frame(width: 220, height: 220)

  VStack(alignment: .leading) {
    Text("Robot")
      .font(.title2)
    Button("Inspect") {
      openInspector()
    }
  }
  .glassBackgroundEffect()
}
```

#### ZStack with RealityView

```swift
ZStack {
  RealityView { ... }
  Model3D(named: "BabyBot")
}
```

#### Layouts are 3D

```swift
HStack {
  Model3D(named: "LargeRobot")
  Model3D(named: "BabyBot")
}
```

#### ResizableRobotView

```swift
struct ResizableRobotView: View {
  let asset: Model3DAsset

  var body: some View {
    Model3D(asset: asset) { resolved in
      resolved
        .resizable()
    }
    .scaledToFit3D()
  }
}
```

#### Robot profile layout

```swift
struct RobotProfile: View {
  let robot: Robot

  var body: some View {
    VStack {
      ResizableRobotView(asset: robot.model3DAsset)
      RobotNameCard(robot: robot)
    }
    .frame(width: 300)
  }
}
```

#### Vertical alignment

```swift
HStack(alignment: .bottom) {
  Image("RobotHead")
    .border(.red)
  Color.blue
    .frame(width: 100, height: 100)
    .border(.red)
}
.border(.yellow)
```

#### Depth alignment

```swift
struct RobotProfile: View {
  let robot: Robot

  var body: some View {
    VStackLayout().depthAlignment(.front) {
      ResizableRobotView(asset: robot.model3DAsset)
      RobotNameCard(robot: robot)
    }
    .frame(width: 300)
  }
}
```

#### Favorite robots row

```swift
struct FavoriteRobotsRow: View {
  let robots: [Robot]

  var body: some View {
    HStack {
      RobotProfile(robot: robots[2])
      RobotProfile(robot: robots[0])
      RobotProfile(robot: robots[1])
    }
  }
}
```

#### Staggering depth within a row

`DepthAlignment` ships three values - `.front`, `.center`, and `.back` - and
`alignmentGuide(_:computeValue:)` has no depth overload, so there is no
per-child depth guide. To stagger children along depth, align the row on one
plane and give individual children their own depth budget with
`frame(depth:alignment:)`, or nudge them with `offset(z:)`.

```swift
struct FavoritesRow: View {
  let robots: [Robot]

  var body: some View {
    HStackLayout().depthAlignment(.front) {
      RobotProfile(robot: robots[2])

      // Sits deeper than its neighbors by taking a larger depth budget
      // aligned to the back of the row.
      RobotProfile(robot: robots[0])
        .frame(depth: 120, alignment: .back)

      // A small visual push, not a layout change.
      RobotProfile(robot: robots[1])
        .offset(z: -20)
    }
  }
}
```

#### Rotation3DEffect

```swift
Model3D(named: "ToyRocket")
  .rotation3DEffect(.degrees(45), axis: .z)
```

#### Rotation3DLayout

```swift
HStackLayout().depthAlignment(.front) {
  RocketDetailsCard()
  Model3D(named: "ToyRocket")
    .rotation3DLayout(.degrees(isRotated ? 45 : 0), axis: .z)
}
```

#### Pet radial layout

```swift
struct PetRadialLayout: View {
  let pets: [Pet]

  var body: some View {
    MyRadialLayout {
      ForEach(pets) { pet in
        PetImage(pet: pet)
      }
    }
  }
}
```

#### Rotated robot carousel

```swift
struct RobotCarousel: View {
  let robots: [Robot]

  var body: some View {
    VStack {
      Spacer()
      MyRadialLayout {
        ForEach(robots) { robot in
          ResizableRobotView(asset: robot.model3DAsset)
            .rotation3DLayout(.degrees(-90), axis: .x)
        }
      }
      .rotation3DLayout(.degrees(90), axis: .x)
    }
  }
}
```

#### Spatial container

```swift
SpatialContainer(alignment: .topTrailingBack) {
  LargeBox()
  MediumBox()
  SmallBox()
}
```

#### Spatial overlay

```swift
LargeBox()
  .spatialOverlay(alignment: .bottomLeadingFront) {
    SmallBox()
  }
```

#### Selection ring spatial overlay

```swift
struct RobotCarouselItem: View {
  let robot: Robot
  let isSelected: Bool

  var body: some View {
    ResizableRobotView(asset: robot.model3DAsset)
      .spatialOverlay(alignment: .bottom) {
        if isSelected {
          ResizableSelectionRingModel()
        }
      }
  }
}
```
