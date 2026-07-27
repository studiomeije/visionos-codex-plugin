# ImageTrackingProvider

## Context

ImageTrackingProvider tracks known 2D images in a person's surroundings and emits ImageAnchor updates. Use it to attach content to specific printed or displayed images.

For shared session setup, authorization, and lifecycle rules, see [session-basics.md](session-basics.md). For model-layer reconciliation, see [anchor-processing.md](anchor-processing.md).

## Code Examples

```swift
import ARKit

@MainActor
final class ImageTrackingModel {
    private let session = ARKitSession()
    private var provider: ImageTrackingProvider?

    func start(referenceImages: [ReferenceImage]) async {
        guard ImageTrackingProvider.isSupported else { return }
        let provider = ImageTrackingProvider(referenceImages: referenceImages)
        self.provider = provider

        let results = await session.requestAuthorization(for: ImageTrackingProvider.requiredAuthorizations)
        guard results.values.allSatisfy({ $0 == .allowed }) else { return }

        do {
            try await session.run([provider])
        } catch {
            print("Image tracking failed: \(error)")
            return
        }

        Task {
            for await update in provider.anchorUpdates {
                switch update.event {
                case .added, .updated:
                    handleImageAnchor(update.anchor)
                case .removed:
                    removeImageAnchor(update.anchor.id)
                }
            }
        }
    }

    private func handleImageAnchor(_ anchor: ImageAnchor) {}

    private func removeImageAnchor(_ id: ImageAnchor.ID) {}
}
```
