# BarcodeDetectionProvider

## Context

BarcodeDetectionProvider supplies real-time position updates for barcodes detected in a person's surroundings. It publishes BarcodeAnchor updates and requires the barcode detection entitlement to deliver data.

For shared session setup, authorization, and lifecycle rules, see [session-basics.md](session-basics.md). For model-layer reconciliation, see [anchor-processing.md](anchor-processing.md).

## Code Examples

```swift
import ARKit

@MainActor
final class BarcodeTrackingModel {
    private let session = ARKitSession()
    private var provider: BarcodeDetectionProvider?

    func startTracking(symbologies: [BarcodeAnchor.Symbology]) async {
        guard BarcodeDetectionProvider.isSupported else { return }
        let provider = BarcodeDetectionProvider(symbologies: symbologies)
        self.provider = provider

        let results = await session.requestAuthorization(for: BarcodeDetectionProvider.requiredAuthorizations)
        guard results.values.allSatisfy({ $0 == .allowed }) else { return }

        do {
            try await session.run([provider])
        } catch {
            print("Barcode detection failed: \(error)")
            return
        }

        Task {
            for await update in provider.anchorUpdates {
                switch update.event {
                case .added, .updated:
                    handleBarcodeAnchor(update.anchor)
                case .removed:
                    removeBarcodeAnchor(update.anchor.id)
                }
            }
        }
    }

    private func handleBarcodeAnchor(_ anchor: BarcodeAnchor) {}

    private func removeBarcodeAnchor(_ id: BarcodeAnchor.ID) {}
}
```
