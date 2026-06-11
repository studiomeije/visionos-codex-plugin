# Endpoints and Sessions

Use this when discovering a Vision Pro endpoint or streaming a document file
from a macOS app with Spatial Preview.

Requires macOS 27 (beta). Beta API: names and shapes may change before
release. `import SpatialPreview`; the device picker is part of a SwiftUI
cross-import overlay that loads automatically when the target also imports
SwiftUI. Frameworks auto-link from `import` statements.

## Endpoint discovery

`ConnectedSpatialEndpointObserver` (`@MainActor`, `Observable`) tracks the
Vision Pro connected through Mac Virtual Display:

- `isEndpointAvailable: Bool` — synchronous check for enabling UI.
- `endpoint: SpatialPreviewEndpoint` — `get async throws`; throws
  `ConnectedSpatialEndpointObserver.UnavailableError` when no Mac Virtual
  Display connection exists.

```swift
@State private var deviceObserver = ConnectedSpatialEndpointObserver()

do {
    let endpoint = try await deviceObserver.endpoint
    await startSession(endpoint: endpoint)
} catch {
    showDevicePicker = true // fall back to the picker sheet
}
```

`SpatialPreviewEndpoint` is opaque: `Hashable`, `Sendable`, `Codable`, with
no public initializer besides `Codable`. Obtain one from the observer or the
picker; never construct it.

## Device picker (SwiftUI, macOS-only)

`SpatialPreviewDevicePicker` lists available Vision Pro devices and hands
back an endpoint. It is explicitly unavailable on visionOS. Present it in a
sheet when no automatic endpoint exists:

```swift
.sheet(isPresented: $showDevicePicker) {
    SpatialPreviewDevicePicker(isPresented: $showDevicePicker) { endpoint in
        showDevicePicker = false
        Task { await startSession(endpoint: endpoint) }
    }
}
```

## SpatialPreviewSession protocol

Both session classes conform to `SpatialPreviewSession` (`AnyObject`,
`Observable`):

- `state: SpatialPreviewSessionState`
- `progress: ProgressReporter` — Foundation type; observe
  `progress.fractionCompleted` for sync progress.
- `func close() async throws`

`SpatialPreviewSessionState` cases: `.waiting`, `.connected`,
`.interrupted`, `.invalidated`. The extension property `isInvalidated` is
the canonical end-of-session check.

`SpatialPreviewSessionError` cases: `.invalidated`,
`.invalidSpatialPreviewEndpoint`, `.tooManySessions`.

## DocumentPreviewSession

Streams whole files of any `UTType`; the Apple sample streams spatial HEIC
photos. Reuse one session and swap content in place with `updateContents`
instead of starting a new session per file.

```swift
import UniformTypeIdentifiers

let session = DocumentPreviewSession(
    name: "Gallery.heic",
    contentType: UTType(filenameExtension: "heic")!)
try await session.start(endpoint: endpoint)
try await session.updateContents(url: url) // or updateContents(data:)
```

Detect session end and release local state with an `Observations` loop
keyed to the session identity:

```swift
.task(id: previewSession.map { ObjectIdentifier($0) }) {
    guard let session = previewSession else { return }
    for await state in Observations({ session.state })
        where state.isInvalidated {
        previewSession = nil
        break
    }
}
```

## Requirements recap

- macOS 27 (beta) deployment target; the sender is always the Mac app.
- No entitlement or Info.plist key required (the sandboxed Apple sample
  ships none).
- visionOS ships no SpatialPreview module; the Vision Pro side is the
  built-in system viewer.
