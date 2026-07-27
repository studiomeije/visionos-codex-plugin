# RoomTrackingProvider

## Context

RoomTrackingProvider supplies real-time information about the room a person is currently in. It publishes RoomAnchor updates and can provide the current room anchor when available.

For shared session setup, authorization, and lifecycle rules, see [session-basics.md](session-basics.md). For model-layer reconciliation, see [anchor-processing.md](anchor-processing.md).

## Code Examples

```swift
import ARKit

@MainActor
final class RoomTrackingModel {
    private let session = ARKitSession()
    private let provider = RoomTrackingProvider()

    func start() async {
        guard RoomTrackingProvider.isSupported else { return }

        let results = await session.requestAuthorization(for: RoomTrackingProvider.requiredAuthorizations)
        guard results.values.allSatisfy({ $0 == .allowed }) else { return }

        do {
            try await session.run([provider])
        } catch {
            print("Room tracking failed: \(error)")
            return
        }

        Task {
            for await update in provider.anchorUpdates {
                handleRoomAnchor(update.anchor)
            }
        }
    }

    private func handleRoomAnchor(_ anchor: RoomAnchor) {}
}
```
