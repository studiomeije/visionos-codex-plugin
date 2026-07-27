# AccessoryTrackingProvider

## Context

AccessoryTrackingProvider supplies real-time pose updates for accessories in the user's environment. It publishes AccessoryAnchor updates and can return the latest anchor state or a predicted pose for latency compensation.

For shared session setup, authorization, and lifecycle rules, see [session-basics.md](session-basics.md). For model-layer reconciliation, see [anchor-processing.md](anchor-processing.md).

## Code Examples

```swift
import ARKit

@MainActor
final class AccessoryTrackingModel {
    private let session = ARKitSession()
    private var provider: AccessoryTrackingProvider?

    func startTracking(accessories: [Accessory]) async {
        guard AccessoryTrackingProvider.isSupported else { return }
        let provider = AccessoryTrackingProvider(accessories: accessories)
        self.provider = provider

        let results = await session.requestAuthorization(for: AccessoryTrackingProvider.requiredAuthorizations)
        guard results.values.allSatisfy({ $0 == .allowed }) else { return }

        do {
            try await session.run([provider])
        } catch {
            print("Accessory tracking failed: \(error)")
            return
        }

        Task {
            for await update in provider.anchorUpdates {
                switch update.event {
                case .added, .updated:
                    handleAccessoryAnchor(update.anchor)
                case .removed:
                    removeAccessoryAnchor(update.anchor.id)
                }
            }
        }
    }

    private func handleAccessoryAnchor(_ anchor: AccessoryAnchor) {}

    private func removeAccessoryAnchor(_ id: AccessoryAnchor.ID) {}

    // New in visionOS 27.
    func replaceAccessories(_ accessories: [Accessory]) async {
        guard let provider else { return }
        do {
            try await provider.updateAccessories(accessories)
        } catch {
            print("Accessory update failed: \(error)")
        }
    }
}
```
