# Signposts And Instruments

Use this file when the task is about timing or performance evidence.

## `OSSignposter`

Use `OSSignposter` for spans that need measurement in Instruments.
Use [`runtime-logging.md`](runtime-logging.md) for `Logger` policy and privacy rules.

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

## Performance Budgets

Do not treat entity, draw-call, vertex, or duration counts as universal
platform limits. Record the app surface, content tier, target, frame deadline,
thermal state, and baseline, then set a product-specific budget.

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
