# USD Preview Session

Use this when streaming a live USDKit `USDStage` from a macOS app to Vision
Pro and round-tripping edits made in the spatial viewer.

Requires macOS 27 (beta) plus USDKit. Beta API: names and shapes may change
before release. `import SpatialPreview` together with `import USDKit`
activates the cross-import overlay that defines `USDPreviewSession`.

## Start a session

```swift
let session = USDPreviewSession(stage: stage) // USDKit.USDStage
try await session.start(
    endpoint: endpoint,
    viewerOptions: [.annotations, .perObjectManipulation, .export])
```

`start(endpoint:parameters:viewerOptions:)` defaults:

- `parameters: OptimizationParameters = .processed([.optimized, .compressed])`
  — pass `.unmodified` to skip asset processing. `OptimizationSteps` is an
  `OptionSet` with `.optimized` and `.compressed`.
- `viewerOptions: SpatialViewerOptions = .default` — `OptionSet` with
  `.annotations`, `.perObjectManipulation`, `.export`. The members of
  `.default` are not visible in the interface; set options explicitly when
  behavior matters.

The session conforms to `SpatialPreviewSession` (`state`, `progress`,
`close()`); observe `progress.fractionCompleted` to drive a sync indicator.

## Events and playback

`session.events` is `any AsyncSequence<USDPreviewSession.Event, Never>` and
mirrors changes made in the Vision Pro viewer:

```swift
for await event in session.events {
    switch event {
    case .timeChanged(let time): playbackModel.timeCode = time
    case .playbackStateChanged(let isPlaying): sync(isPlaying)
    case .error(let error): handle(error)
    }
}
```

`session.time: TimeInterval` and `session.isPlaying: Bool` are settable and
drive remote playback. Render the same time locally by writing
`USDStage.TimeCode(timeCode)` into `USDStageComponent.timeCode` and
re-setting the component on its entity.

`USDPreviewSession.Error` cases: `.assetUnshareable` (the asset cannot be
sent to the viewer) and `.readOnlyStage` (the stage cannot accept viewer
edits).

## Round-trip editing pattern

The session shares the live stage; edits from either side compose into the
same `USDStage`.

Render locally with RealityKit so the Mac UI shows the same content:

```swift
let stageComponent = await USDStageComponent(stage, timeCode: .default)
rootEntity.components[USDStageComponent.self] = stageComponent
// The component re-renders automatically as the stage changes.
```

Observe remote edits with USD notices; keep the returned
`USDStage.ObservationToken` alive:

```swift
observerToken = stage.addObserver(for: USDStage.ObjectsDidChange.self) { event in
    for path in event.resyncedPaths {
        let prim = event.stage.prim(at: path)
        guard prim.isValid else { continue }
        // React to annotation or variant changes at this path.
    }
}
```

## Annotations

With `.annotations` in `viewerOptions`, annotations created in the viewer
arrive as prims with USD `typeName` metadata `"AppleTextAnnotation"` under a
`"Scope"` prim at `/__documentAnnotationGroup__`. Each carries attributes
`identifier` (UUID string), `text`, and `author`, plus an
`xformOp:translate` for placement. Create your own with
`stage.definePrim(at:type:)` at a child path of that scope, write the same
attributes (`makeAttribute(named:as:custom:variability:)` then the
`prim[token, as:]` subscript), and call
`addTransformOperation(type: .translate)` before setting
`xformOp:translate`. Find existing ones by filtering `descendants` on the
`typeName` metadata.

## Variant switching

```swift
let primSpec = USDPrim.Spec(layer: stage.rootLayer, primPath: furniturePath)
primSpec?.setVariantSelection(for: "Layout", to: USDToken("LayoutB"))
// Read back: primSpec?.variantSelections["Layout"]
```

Variant selections made on either Mac or Vision Pro arrive as resyncs on
the shared stage; compare the received selection with local UI state before
re-applying to avoid feedback loops.
