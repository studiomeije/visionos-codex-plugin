# SwiftUI Attachments, Text, Images, and Video In A Scene

Semantics and gotchas. For exact signatures and availability, query the SDK with
`apple-sdk-lookup`.

## Getting SwiftUI Into The Scene

Two complementary routes; pick by who declares the view.

- **`RealityView` attachment builder** - the view is declared in SwiftUI, and
  you resolve the entity with `attachments.entity(for:)`. Use this when the
  attachment set is known up front. See `spatial-swiftui-developer`.
- **`ViewAttachmentComponent`** - the entity is created in RealityKit and
  carries its own SwiftUI content. Use this for dynamic, per-entity adornments
  where a static builder list does not fit.

`ViewAttachmentComponent` is **transient**: it does not serialize into
`.reality` files. Its `bounds` are in meters, and the view hierarchy is managed
and updated by RealityKit.

## PresentationComponent

Attaches a SwiftUI **popover** to an entity. visionOS only.

Two things bite here:

- `content` is a **View value**, not a `@ViewBuilder` closure -
  `content: MyView()`, not `content: { MyView() }`.
- `.popover(arrowEdge:)` is the **only** configuration in the visionOS 27 SDK.
  There is no `.sheet`. For sheet-style UI, present from the owning window or
  open a separate window; reserve the popover for content that must stay
  attached to the entity.

Drive it from a `Binding<Bool>` with `init(isPresented:configuration:content:)`
rather than mutating `isPresented` by hand where you can.

## Text

Prefer `MeshResource.generateText()` for in-world 3D text; it is the reliable
path across RealityKit versions. `TextComponent` is not consistently available -
confirm it in the installed SDK before using it.

For text that must be legible, selectable, or interactive, use a SwiftUI
attachment instead of 3D geometry. Extruded text is scene decoration, not UI.

## ImagePresentationComponent

Displays 2D photos, spatial photos, and generated **spatial scenes** (3D
reconstructions with motion parallax). visionOS only.

`desiredViewingMode` is a request, not a state - the available modes depend on
the image type and on whether spatial-scene generation has finished. Selecting a
spatial-scene mode before generation completes shows a progress UI rather than
failing. Read back the active mode instead of assuming the desired one took
effect.

Modes: `.mono`, `.spatial3D`, `.spatial3DImmersive`, `.spatialStereo`,
`.spatialStereoImmersive`.

## VideoPlayerComponent

Embeds `AVPlayer` playback on an entity, with immersive- and spatial-aware
rendering.

- The component **creates its own mesh and material**. Do not add a
  `ModelComponent` for the video surface.
- The default mesh is **1 meter tall**. Scale uniformly; scaling one axis
  distorts the video rather than cropping it.
- Video larger than the containing window scene will clip - size the scene, not
  just the entity.
- `desiredViewingMode` / `desiredImmersiveViewingMode` / `desiredSpatialVideoMode`
  are all requests; read the active `viewingMode` back.
- `.portal`, `.progressive`, and `.full` immersive modes are visionOS only, and
  a mode change is scene orchestration, not a property flip.

For playback architecture, APMP, comfort mitigation, and AVKit's
`AVExperienceController`, use `visionos-immersive-media-developer`.
