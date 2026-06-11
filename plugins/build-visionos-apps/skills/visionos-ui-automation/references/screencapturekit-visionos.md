# ScreenCaptureKit on visionOS (In-App Capture)

New in visionOS 27: ScreenCaptureKit joins the visionOS SDK at 27.0.
Beta API: names and shapes may change before release.

Scope boundary: AXe drives the simulator from outside the app.
ScreenCaptureKit is an in-app API — the running app captures itself or the
shared space, on device or simulator, always with user consent through a
system picker. Use AXe for agent-driven evidence capture; use
ScreenCaptureKit when the app ships or debugs its own record/replay feature.
There is no headless path: do not script around the picker.

## Getting a Content Filter (Picker Only)

There is no programmatic `SCContentFilter` construction on visionOS — all
`init(display:...)`-style initializers are macOS-only. The only source of a
filter is the system picker:

```swift
let picker = SCContentSharingPicker.shared
picker.add(observer)                   // SCContentSharingPickerObserver
picker.present()                       // general picker
picker.present(using: .display)        // straight to display picking
picker.presentForCurrentApplication()  // capture this app only
```

`.display` is the only pickable `SCShareableContentStyle` on visionOS
(`.none` also exists); window and application styles are macOS-only. `presentForCurrentApplication()`
scopes capture to the app's own content. The filter arrives via the
observer:

```swift
func contentSharingPicker(_ picker: SCContentSharingPicker,
                          didUpdateWith filter: SCContentFilter,
                          for stream: SCStream?) { /* build SCStream */ }
func contentSharingPicker(_ picker: SCContentSharingPicker,
                          didCancelFor stream: SCStream?) { }
func contentSharingPickerStartDidFailWithError(_ error: any Error) { }
```

For a microphone toggle in the picker, set
`showsMicrophoneControl = true` on an
`SCContentSharingPickerConfiguration` and assign it to
`picker.defaultConfiguration`. Read the user's choice back from
`filter.isMicrophoneEnabled`.

## Stream Setup and Outputs

```swift
let config = SCStreamConfiguration()
config.capturesAudio = true
config.sampleRate = 48_000
config.channelCount = 2
config.excludesCurrentProcessAudio = false

let stream = SCStream(filter: filter, configuration: config, delegate: self)
try stream.addStreamOutput(handler, type: .screen, sampleHandlerQueue: queue)
try stream.addStreamOutput(handler, type: .audio, sampleHandlerQueue: queue)
try stream.addStreamOutput(handler, type: .microphone,
                           sampleHandlerQueue: queue)
stream.startCapture { error in /* nil on success */ }
```

The handler conforms to `SCStreamOutput` and receives
`stream(_:didOutputSampleBuffer:of:)` callbacks per output type. Check
`stream.isCapturing` for state; stop with `stopCapture(completionHandler:)`.
The system decides capture resolution — `width` and `height` on
`SCStreamConfiguration` are unavailable on visionOS.

## File Recording (SCRecordingOutput)

```swift
let recConfig = SCRecordingOutputConfiguration()
recConfig.outputURL = fileURL              // must be a file URL
recConfig.videoCodecType = .h264           // default
recConfig.outputFileType = .mp4            // default
recConfig.mixesAudioWithMicrophone = true  // mix mic into the recording

let recording = SCRecordingOutput(configuration: recConfig, delegate: self)
try stream.addRecordingOutput(recording)
```

Delegate callbacks: `recordingOutputDidStartRecording(_:)`,
`recordingOutput(_:didFailWithError:)`,
`recordingOutputDidFinishRecording(_:)`. Check `availableVideoCodecTypes`
and `availableOutputFileTypes` instead of assuming codec support. Remove
with `removeRecordingOutput(_:)` to finish the file.

## Rolling Replay Buffer (SCClipBufferingOutput)

```swift
let clips = SCClipBufferingOutput(delegate: self)
try stream.addClipBufferingOutput(clips)
// later, on user action:
clips.exportClip(to: clipURL, duration: 15) { error in /* nil on success */ }
```

Maximum clip duration is 15 seconds; shorter buffers export whatever is
available. The destination file is overwritten if it exists. Export runs
asynchronously and does not interrupt buffering. The output must be added
to a stream before exporting.

## System Trim/Share UI (SCRecordingEditor)

```swift
let editor = SCRecordingEditor(url: recordedFileURL)
editor.delegate = self  // recordingEditorDidDismiss, didFailWithError
editor.present(from: windowScene) { error in /* nil on success */ }
```

Takes the file URL produced by `SCRecordingOutput` or
`SCClipBufferingOutput` and presents a system-owned preview/trim/share UI
from a `UIWindowScene`.

## Not Available on visionOS

- `SCScreenshotManager` — no one-shot in-app screenshot API. For simulator
  screenshots, AXe remains the path.
- `SCShareableContent` enumeration (`SCDisplay`, `SCWindow`,
  `SCRunningApplication`) — no programmatic listing of windows or displays.
- Programmatic `SCContentFilter` initializers — picker only.
- `SCStreamConfiguration` `width`/`height`, presets, frame interval, and
  pixel format — the system decides.
- HDR capture (`captureDynamicRange` and HDR presets).
- `SCVideoEffectOutput` — iOS-only.
- `updateContentFilter` / `updateConfiguration` on a running stream —
  macOS-only. Tear down and rebuild the stream instead.

## Errors and Background Mode

`SCStreamError` gains `.insufficientStorage` (-3822), `.notSupported`
(-3823), and `.missingBackgroundMode` (-3824) at 27.0.
`.missingBackgroundMode` means the system stopped the stream because the
app lacks a background mode, so expect continued capture across
backgrounding to require a background-mode declaration — verify the exact
Info.plist requirement against the current beta before shipping.
