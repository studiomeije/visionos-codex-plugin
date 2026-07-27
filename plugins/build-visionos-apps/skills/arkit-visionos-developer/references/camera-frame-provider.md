# CameraFrameProvider

## Context

CameraFrameProvider provides camera frame streams for selected video formats. It exposes `cameraFrameUpdates(for:)`, which returns an optional async sequence of `CameraFrame` values you can process for computer vision or custom rendering pipelines.

For shared session setup, authorization, and lifecycle rules, see [session-basics.md](session-basics.md). For model-layer reconciliation, see [anchor-processing.md](anchor-processing.md).

## Code Examples

```swift
import ARKit

@MainActor
final class CameraFrameStreamer {
    private let session = ARKitSession()
    private let provider = CameraFrameProvider()

    func start(format: CameraVideoFormat) async {
        guard CameraFrameProvider.isSupported else { return }

        let results = await session.requestAuthorization(for: CameraFrameProvider.requiredAuthorizations)
        guard results.values.allSatisfy({ $0 == .allowed }) else { return }

        do {
            try await session.run([provider])
        } catch {
            print("CameraFrameProvider failed: \(error)")
            return
        }

        Task {
            guard let updates = provider.cameraFrameUpdates(for: format) else { return }

            for await frame in updates {
                handleFrame(frame)
            }
        }
    }

    private func handleFrame(_ frame: CameraFrame) {}
}
```
