# Signposts And Instruments

Use this file when the task is about timing or performance evidence.

## `OSSignposter`

Use `OSSignposter` for spans that need measurement in Instruments.

```swift
import OSLog

private let signposter = OSSignposter(
  subsystem: Bundle.main.bundleIdentifier ?? "SampleApp",
  category: .pointsOfInterest
)

func loadScene(named name: String) async throws -> Entity {
  let state = signposter.beginInterval("LoadScene", id: signposter.makeSignpostID(), "name=\(name)")
  defer { signposter.endInterval("LoadScene", state) }
  return try await Entity(named: name)
}
```

## RealityKit Trace Budgets

- Entity count: under 20 per-frame hotspots when possible
- 3D mesh draw calls: under 100 per frame
- 3D mesh vertices: under 100,000 per frame

## Simulator Caveat

`xctrace` can be incomplete or unreliable on the Apple Vision Pro simulator.
When that happens, use `sample` as the first CPU-side fallback:

```bash
sample <pid> 5 -file ./artifacts/sample-output.txt
```
