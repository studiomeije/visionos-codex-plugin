# StereoPropertiesProvider

## Context

StereoPropertiesProvider supplies the latest viewpoint properties for stereo rendering. Use it to inform custom rendering or compositing pipelines.

For shared session setup, authorization, and lifecycle rules, see [session-basics.md](session-basics.md). For model-layer reconciliation, see [anchor-processing.md](anchor-processing.md).

## Code Examples

```swift
import ARKit

@MainActor
final class StereoPropertiesModel {
    private let session = ARKitSession()
    private let provider = StereoPropertiesProvider()

    func start() async {
        guard StereoPropertiesProvider.isSupported else { return }

        let results = await session.requestAuthorization(for: StereoPropertiesProvider.requiredAuthorizations)
        guard results.values.allSatisfy({ $0 == .allowed }) else { return }

        do {
            try await session.run([provider])
        } catch {
            print("StereoPropertiesProvider failed: \(error)")
            return
        }
    }

    func updateViewpoint() {
        guard let properties = provider.latestViewpointProperties else { return }
        applyViewpointProperties(properties)
    }

    private func applyViewpointProperties(_ properties: ViewpointProperties) {}
}
```
