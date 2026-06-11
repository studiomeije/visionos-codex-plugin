---
name: spatial-preview-developer
description: Stream documents and live USD scenes from a Mac app to Apple Vision Pro using the Spatial Preview framework (macOS 27, beta), including endpoint discovery via ConnectedSpatialEndpointObserver and SpatialPreviewDevicePicker, DocumentPreviewSession for files, USDPreviewSession for live USDKit stages, viewer options, playback events, and annotation/variant round-trips. Use when a macOS 27 app needs to show content spatially on a Vision Pro connected over Mac Virtual Display. The sender is always the Mac app; visionOS ships no SpatialPreview module, the Vision Pro side is the built-in system viewer.
---

# Spatial Preview Developer

## Quick Start

Spatial Preview is a macOS 27 framework. A Mac app opens a session against a
`SpatialPreviewEndpoint` (a connected Vision Pro) and streams either a
document file or a live USDKit `USDStage`. Vision Pro renders the content in
its system viewer; the USD path is bidirectional.

1. Confirm the deployment target is macOS 27. Requires macOS 27 (beta);
   this is beta API, names and shapes may change before release.
2. `import SpatialPreview`. The SwiftUI device picker and `USDPreviewSession`
   come from cross-import overlays that load automatically when the target
   also imports SwiftUI or USDKit; never import the underscored modules.
3. Pick the endpoint: `ConnectedSpatialEndpointObserver` for the Mac Virtual
   Display connection, `SpatialPreviewDevicePicker` as the fallback UI.
4. Choose the session class: `DocumentPreviewSession` for whole files,
   `USDPreviewSession` for a live stage with remote editing.
5. Load only the reference file that matches the current problem.

## Requirements

- macOS 27 (beta) SDK and deployment target; Swift 6 concurrency.
- A Vision Pro connected via Mac Virtual Display for the automatic endpoint;
  otherwise the user picks a device in `SpatialPreviewDevicePicker`.
- No entitlement or Info.plist key; the sandboxed Apple sample ships none.
- visionOS itself ships no SpatialPreview module; do not plan visionOS-side
  code for this feature.
- The USD path additionally needs USDKit, and RealityKit
  `USDStageComponent` for local rendering.

## Load References When

| Reference | When to Use |
|---|---|
| [`endpoints-and-sessions.md`](references/endpoints-and-sessions.md) | When discovering endpoints, presenting the device picker, streaming files with `DocumentPreviewSession`, or handling session state and errors. |
| [`usd-preview-session.md`](references/usd-preview-session.md) | When streaming a live `USDStage` with `USDPreviewSession`, handling playback events, or round-tripping annotations and variant edits. |

## Workflow

1. Confirm the target is a macOS 27 app and the content type: file vs live
   USD stage.
2. Wire endpoint discovery first: try `deviceObserver.endpoint`, fall back
   to the picker sheet on `UnavailableError`.
3. Create the session, `start(endpoint:)`, then push content or stage edits.
4. Observe `state` (end the session UI when `state.isInvalidated`) and
   `progress.fractionCompleted` for sync progress.
5. For USD, attach the remote-event loop (`session.events`) and USD notices
   (`USDStage.ObjectsDidChange`) before exposing editing UI.

## Guardrails

- Keep one session per shared document; call `updateContents` to swap
  content instead of starting new sessions (`.tooManySessions` is an error
  case).
- `SpatialPreviewDevicePicker` is macOS-only; never reference it from
  visionOS code paths.
- Treat `SpatialPreviewEndpoint` as opaque; obtain it from the observer or
  the picker, never construct it.
- For USD, the session shares the live stage: route all edits through
  USDKit so both sides stay in sync, and keep the `ObservationToken` alive.
- This is beta API; re-verify symbols against the installed macOS 27 SDK
  before shipping.

## Output Expectations

Provide:
- the session class chosen and why
- the endpoint-discovery path (auto vs picker)
- which references were used
- the state/error handling added
- the next validation step on a connected Vision Pro
