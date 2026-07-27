# SharedCoordinateSpaceProvider

## Context

SharedCoordinateSpaceProvider establishes a shared coordinate space among multiple participants. It provides event updates and lets you push coordinate space data for synchronization.

For shared session setup, authorization, and lifecycle rules, see [session-basics.md](session-basics.md). For model-layer reconciliation, see [anchor-processing.md](anchor-processing.md).

## Code Examples

```swift
import ARKit

@MainActor
final class SharedSpaceModel {
    private let session = ARKitSession()
    private let provider = SharedCoordinateSpaceProvider()

    func start() async {
        guard SharedCoordinateSpaceProvider.isSupported else { return }

        let results = await session.requestAuthorization(for: SharedCoordinateSpaceProvider.requiredAuthorizations)
        guard results.values.allSatisfy({ $0 == .allowed }) else { return }

        do {
            try await session.run([provider])
        } catch {
            print("Shared coordinate space failed: \(error)")
            return
        }

        Task {
            for await event in provider.eventUpdates {
                handleEvent(event)
            }
        }
    }

    func publishNextCoordinateSpace() {
        if let data = provider.nextCoordinateSpaceData {
            provider.push(data: data)
        }
    }

    private func handleEvent(_ event: SharedCoordinateSpaceProvider.Event) {}
}
```
