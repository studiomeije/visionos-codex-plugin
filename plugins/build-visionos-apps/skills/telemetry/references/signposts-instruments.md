# Signposts And Instruments

Use this file when the task is about timing or performance evidence.

## `OSSignposter`

Use `OSSignposter` for spans that need measurement in Instruments.
Use [`logging.md`](logging.md) for `Logger` policy and privacy rules.

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

For post-build verification, pair signpost captures with a small number of
`Logger` events that prove the measured action actually started and ended in
the intended app lifecycle path.

## Apple API Anchors

- `OSSignposter`: records signposted intervals and events using unified
  logging.
- `OSSignposter.init(logger:)`: reuses a `Logger` subsystem and category for
  signposts.
- `OSSignposter.beginInterval(_:id:)`,
  `OSSignposter.endInterval(_:_:)`, `OSSignposter.emitEvent(_:id:)`, and
  `OSSignposter.withIntervalSignpost(_:id:around:)`: measure spans or mark
  points of interest for runtime verification and Instruments.
