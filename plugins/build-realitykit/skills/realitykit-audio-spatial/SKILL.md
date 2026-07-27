---
name: realitykit-audio-spatial
description: Implement and debug RealityKit spatial audio, ambient audio, channel audio, audio libraries, audio mix groups, reverb, grouped playback, and acoustic simulation on visionOS 27. Use when a RealityKit task is primarily about placing sound in 3D, loading or organizing audio resources, controlling channel or ambient playback, mixing groups, room acoustics, or audio behavior tied to RealityKit entities.
---

# RealityKit Audio Spatial

## Quick Start

1. Decide whether the task is entity-placed spatial audio, ambient/channel
   playback, reusable audio libraries, mix groups, reverb, or acoustic
   simulation.
2. Load the matching audio reference file only.
3. Keep audio resource loading asynchronous and entity ownership explicit.
4. Route entity loading, anchoring, interaction, or attachment setup to
   `realitykit-visionos-developer`.
5. Route animation or physics triggers for audio events to
   `realitykit-animation-physics`, and custom trigger systems to
   `realitykit-ecs-systems`.

## Load References When

| Reference | When to Use |
|---|---|
| [`references/audio-components.md`](references/audio-components.md) | Choosing between spatial, ambient, and channel playback, and the semantics of reverb inheritance, mix groups, libraries, and loading strategy. |
| [`references/audio-groups-and-acoustics.md`](references/audio-groups-and-acoustics.md) | Use grouped playback or simulated room acoustics. |

For exact signatures, property lists, enum cases, and availability, query the
installed SDK with `apple-sdk-lookup` rather than relying on recall.

## Cross-Routing

- Use `realitykit-visionos-developer` for entity ownership, asset loading,
  anchors, input, attachments, portals, or synchronization around audio
  entities.
- Use `realitykit-animation-physics` when audio is triggered by character,
  collision, physics, particle, or cloth behavior.
- Use `realitykit-ecs-systems` when audio behavior needs custom per-frame
  query logic.
- Use `realitykit-performance-triage` when playback, acoustics, or spatial
  audio overhead needs trace-backed diagnosis.

## Guardrails

- Keep audio resource and file loading off the synchronous UI path.
- Decide whether audio should be positional, ambient, channel-based, grouped,
  or acoustically simulated before adding components.
- Treat visionOS 27 audio group and acoustics additions as beta API; confirm
  symbols against the installed SDK with `apple-sdk-lookup` before writing them.
- Verify audio behavior on device when spatialization, acoustics, or output
  routing matters.
- Verify written Swift by building before reporting done. Route the build
  through `build-run-debug`.
- Apply `coding-standards-enforcer` to Swift you write here: Swift 6.2 strict
  concurrency, actor isolation, `Sendable`, and `@Observable` ownership.

## Skills In Other Plugins

These routes live in other plugins from this marketplace. If one is not
installed, say so plainly and continue with the best available path rather
than stalling or inventing the missing skill's guidance.

| Skill | Plugin |
|---|---|
| `build-run-debug` | Build visionOS 27 apps |
| `coding-standards-enforcer` | Build visionOS 27 apps |
| `realitykit-performance-triage` | Profile & Optimize RealityKit |

## Output Expectations

Provide:

- the audio category
- which audio references were used
- the selected component or resource ownership path
- the spatialization, grouping, or acoustics constraint
- the next device or runtime validation step
