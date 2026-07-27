# RealityKit Audio Components

Semantics, ordering rules, and gotchas for the audio components. For exact
signatures, property lists, and availability, query the SDK - see
`apple-sdk-lookup`.

## Choosing A Playback Mode

Exactly one of these three components decides how an entity's audio is
rendered. They are mutually exclusive in intent; pick by whether position should
matter.

| Component | Rendering | Use for |
|---|---|---|
| `SpatialAudioComponent` | Positioned in 3D, follows the entity, picks up environment acoustics | Diegetic sound: objects, characters, interaction feedback |
| `AmbientAudioComponent` | Multi-channel, each channel fixed to a direction, no additional reverb or spatial effects | Environment beds and musical ambience that should not localize to a point |
| `ChannelAudioComponent` | Bypasses spatialization entirely | Background music and UI sound that must not move with the listener |

RealityKit playback is **spatial by default** - `entity.playAudio(resource)`
with no audio component set is already spatialized. Add `AmbientAudioComponent`
or `ChannelAudioComponent` to opt out.

## SpatialAudioComponent

The non-obvious behavior:

- **Mono only.** A spatial source emits a single channel; stereo and
  multichannel material is mixed down before spatialization. Author mono files,
  or accept the mixdown artifacts.
- **Sound projects along the entity's negative Z axis.** If a model is authored
  +Z-forward, the audio fires backwards. Rotate the audio source rather than the
  model:

  ```swift
  let audioSource = Entity()
  audioSource.orientation = .init(angle: .pi, axis: [0, 1, 0])
  audioSource.components.set(SpatialAudioComponent())
  ```

- `gain` runs `[-∞, 0]` - it attenuates, it does not amplify.
- `directivity` shapes the radiation pattern (`.beam(focus:)`, where focus `0`
  is omnidirectional and `1` is tightly directional); `distanceAttenuation`
  shapes falloff (`.rolloff(factor:)`, higher falls off faster).
- All properties are live. `entity.spatialAudio?.reverbLevel = -6` takes effect
  without re-adding the component.

## ReverbComponent

- **Inherited down the hierarchy.** The nearest `ReverbComponent` in an entity's
  ancestry governs its spatial audio, so place one on a room root rather than on
  every emitter. Only one is active per entity.
- Build the value with `.preset(_:)`, `.anechoic`, or
  `.simulated(mesh:materials:)`.
- Immersion level changes the outcome: in mixed immersion the system reverberates
  against real-world acoustics, while progressive and full immersion can blend
  real acoustics with the preset or use the preset alone. Presets are far more
  audible in an immersive space than in mixed.
- Ambient audio does **not** take additional reverb.

`Reverb.Preset` in the visionOS 27 SDK - note there is no `.mediumRoom`:

`.verySmallRoomBright`, `.smallRoom`, `.smallRoomBright`, `.mediumRoomDry`,
`.mediumRoomTreated`, `.largeRoom`, `.largeRoomTreated`, `.veryLargeRoom`,
`.concertHall`, `.outside`

## AudioMixGroupsComponent

Groups are matched **by name against the resource's configuration**, not by
entity hierarchy. A resource joins a group through `mixGroupName` when it is
loaded:

```swift
let music = try await AudioFileResource(
    named: "BackgroundMusic",
    configuration: .init(loadingStrategy: .stream, shouldLoop: true,
                         mixGroupName: "Music")
)
```

`AudioMixGroup.name` is a `let` - to change a level, build a new group value and
re-set the component on the mixer entity:

```swift
var music = AudioMixGroup(name: "Music")
music.gain = -3.0

var effects = AudioMixGroup(name: "SFX")
effects.gain = 0.0

audioMixer.components.set(AudioMixGroupsComponent(mixGroups: [music, effects]))
```

Gain is relative decibels: `0` is nominal, negative is quieter. Put the
component on one dedicated mixer entity rather than scattering it.

## AudioLibraryComponent

Holds named resources so several entities can share one load. Useful when many
entities play from the same small set of clips; it does not change how the audio
is rendered - the playback mode still comes from the component above.

## Loading Strategy

Set on `AudioFileResource.Configuration`:

- `.preload` (the default) - low latency, holds the whole file in memory. Use for
  short, frequently triggered effects.
- `.stream` - constant memory, higher start latency. Use for long ambience and
  music beds.

Pair `.stream` with `shouldLoop: true` for continuous environment audio.

## Verifying

Spatialization, acoustics, and output routing are hardware-dependent. Simulator
playback does not prove device behavior - confirm on an Apple Vision Pro before
concluding a mix is correct.
