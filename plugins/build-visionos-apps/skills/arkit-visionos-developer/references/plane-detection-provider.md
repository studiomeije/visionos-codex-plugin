# PlaneDetectionProvider

## Context

PlaneDetectionProvider detects planar surfaces in a person's surroundings and emits PlaneAnchor updates. Use it to place content on real-world surfaces like tables, floors, and walls.

For shared session setup, authorization, and lifecycle rules, see [session-basics.md](session-basics.md). For model-layer reconciliation, see [anchor-processing.md](anchor-processing.md).

## Code Examples

```swift
import ARKit

@MainActor
final class PlaneDetectionModel {
    private let session = ARKitSession()
    private let provider = PlaneDetectionProvider(alignments: [.horizontal, .vertical])

    func start() async {
        guard PlaneDetectionProvider.isSupported else { return }

        let results = await session.requestAuthorization(for: PlaneDetectionProvider.requiredAuthorizations)
        guard results.values.allSatisfy({ $0 == .allowed }) else { return }

        do {
            try await session.run([provider])
        } catch {
            print("Plane detection failed: \(error)")
            return
        }

        Task {
            for await update in provider.anchorUpdates {
                switch update.event {
                case .added, .updated:
                    handlePlaneAnchor(update.anchor)
                case .removed:
                    removePlaneAnchor(update.anchor.id)
                }
            }
        }
    }

    private func handlePlaneAnchor(_ anchor: PlaneAnchor) {}

    private func removePlaneAnchor(_ id: PlaneAnchor.ID) {}
}
```
