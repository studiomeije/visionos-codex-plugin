# SceneReconstructionProvider

## Context

SceneReconstructionProvider supplies mesh data about the shape of a person's surroundings. It emits MeshAnchor updates and supports additional modes like classification.

For shared session setup, authorization, and lifecycle rules, see [session-basics.md](session-basics.md). For model-layer reconciliation, see [anchor-processing.md](anchor-processing.md).

## Code Examples

```swift
import ARKit

@MainActor
final class SceneReconstructionModel {
    private let session = ARKitSession()
    private let provider = SceneReconstructionProvider(modes: [.classification])

    func start() async {
        guard SceneReconstructionProvider.isSupported else { return }

        let results = await session.requestAuthorization(for: SceneReconstructionProvider.requiredAuthorizations)
        guard results.values.allSatisfy({ $0 == .allowed }) else { return }

        do {
            try await session.run([provider])
        } catch {
            print("Scene reconstruction failed: \(error)")
            return
        }

        Task {
            for await update in provider.anchorUpdates {
                handleMeshAnchor(update.anchor)
            }
        }
    }

    private func handleMeshAnchor(_ anchor: MeshAnchor) {}
}
```
