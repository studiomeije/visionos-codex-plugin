# RealityKit Event Schema

Use a small stable vocabulary so logs and trace spans remain comparable.

## Suggested Categories

| Category | Useful Boundaries |
|---|---|
| `SceneLifecycle` | window/immersive open request, result, appear, disappear, teardown |
| `AssetLoading` | resource request, decode/load start, entity attach, failure |
| `ECS` | system phase start/end, query count, exceptional update skip |
| `Rendering` | content-tier switch, material/resource preparation, visibility change |
| `AnimationPhysics` | playback/simulation start, transition, completion, exceptional spike |
| `SpatialAudio` | resource load, prepare, play, stop, route or acoustics change |
| `Tracking` | provider lifecycle and authorization state, never raw sensor payloads |

## Correlation Rules

- Give a user scenario one public correlation identifier.
- Use public enum cases, counts, and stable entity IDs only when they are not
  sensitive.
- Pair each signpost begin/end exactly once.
- Prefer one interval for an app-owned operation such as asset load, scene
  assembly, entity cloning, or immersive transition.
- Keep per-frame systems visible through a bounded aggregate span or sampled
  counter instead of one log line per update.
