# Studio Meije Spatial Codex Plugins

This repository packages four Codex plugins for Apple spatial-computing work:

- `build-visionos-apps` - Build visionOS 27 apps.
- `build-realitykit` - Build with RealityKit.
- `profile-realitykit-apps` - Profile and optimize RealityKit apps.
- `build-reality-composer-pro-3` - Build with Reality Composer Pro 3.

## Choose A Plugin

| Plugin | Use When | Produces |
|---|---|---|
| `build-visionos-apps` | The task is app structure, build, launch, signing, testing, SwiftUI, ARKit, SharePlay, or WidgetKit. | A runnable and correctly configured visionOS app. |
| `build-realitykit` | The task is RealityKit entities, components, systems, rendering, animation, physics, audio, or USDKit implementation. | Runtime code and architecture changes. |
| `profile-realitykit-apps` | A running RealityKit app is slow, stuttering, memory-heavy, thermally constrained, or needs trace-backed verification. | Logs, signposts, traces, bottleneck evidence, and matched comparisons. |
| `build-reality-composer-pro-3` | The editable source is an RCP graph/package, Shader Graph, Script Graph, Animation Graph, USD, or USDZ asset. | Authored graph and asset changes. |

## Plugin Roles

### Build visionOS 27 apps

Use `build-visionos-apps` for Apple Vision Pro app work:

- first-party Xcode build, run, debug, log, and simulator workflows
- spatial SwiftUI, windows, volumes, immersive spaces, ornaments, and app
  architecture
- ARKit providers, SharePlay, WidgetKit, immersive media, and
  Vision Pro specific interaction workflows
- Swift 6.2 coding standards: strict concurrency, actor isolation, `Sendable`,
  and `@Observable` ownership
- signing, entitlements, privacy keys, testing, SwiftPM, packaging,
  distribution, and simulator UI automation

This plugin links out to `build-realitykit` when the task becomes RealityKit
runtime code, to `profile-realitykit-apps` for performance evidence, and to
`build-reality-composer-pro-3` when authored graph, package, or USD
asset-pipeline work is the source of truth.

### Build with RealityKit

Use `build-realitykit` for cross-platform RealityKit runtime development:

- picking the owning skill for a broad or ambiguous RealityKit task
- entity loading, scene graph structure, interaction, attachments, anchoring,
  and portals
- looking up exact API signatures and availability in the installed SDK
- rendering, materials, cameras, lighting, shadows, post-processing, LOD,
  occlusion, splats, and decals
- animation, physics, particles, character controllers, IK, navigation,
  behavior trees, collision, cloth, and runtime animation graphs
- spatial audio, audio resources, mix groups, reverb, and acoustic simulation
- custom components, systems, ECS queries, registration, and update ordering
- USDKit runtime stage, layer, prim, observer, export, and RealityKit bridge
  flows

This plugin routes authored RCP3 graph/package edits to
`build-reality-composer-pro-3` and visionOS app lifecycle or simulator tasks to
`build-visionos-apps`. It routes runtime profiling and optimization
verification to `profile-realitykit-apps`.

### Profile & Optimize RealityKit

Use `profile-realitykit-apps` for evidence-driven runtime investigation:

- reproducible scenarios, baselines, and evidence contracts
- Console, unified logging, `Logger`, and `OSSignposter`
- RealityKit Trace and dynamic `xctrace` capability discovery
- CPU/ECS, frame/GPU, memory/assets, audio, thermal, and power diagnosis
- trace artifact handling and before-and-after performance verification

This plugin routes build and launch plumbing to `build-visionos-apps`, runtime
code fixes to `build-realitykit`, and authored asset or graph fixes to
`build-reality-composer-pro-3`.

### Build with Reality Composer Pro 3

Use `build-reality-composer-pro-3` for authored asset workflows:

- Reality Composer Pro 3 Shader Graph materials and promoted inputs
- Script Graph event/action behavior and package inspection
- Animation Graph / Animator Graph state machines, transitions, parameters,
  tags, and clip bindings
- text-level USD ASCII edits, command-line USD inspection, USDZ packaging, and
  Apple-platform validation

This plugin routes runtime Swift integration to `build-realitykit`, runtime
profiling to `profile-realitykit-apps`, and app build/run/debug or
RealityKitContent package wiring to `build-visionos-apps`.

## Installation

The Codex plugin marketplace is the only supported installation path. Do not
copy plugin directories into a Codex home or edit marketplace metadata by hand.

Add the GitHub repository as a marketplace source:

```bash
codex plugin marketplace add studiomeije/visionos-codex-plugin --ref main
```

For local development, add the checkout instead:

```bash
codex plugin marketplace add /absolute/path/to/visionos-codex-plugin
```

Then install the plugins you need from the configured marketplace:

```bash
codex plugin add build-visionos-apps@visionos-codex-marketplace
codex plugin add build-realitykit@visionos-codex-marketplace
codex plugin add profile-realitykit-apps@visionos-codex-marketplace
codex plugin add build-reality-composer-pro-3@visionos-codex-marketplace
```

The same plugins are available from the Studio Meije marketplace in the Codex
UI. Restart Codex after installation when prompted.

## Maintenance

### Verifying documented API against the SDK

These plugins document beta visionOS 27 API. Every Swift snippet in the docs is
typechecked against the installed visionOS SDK, so a renamed or moved symbol
fails CI instead of reaching an agent:

```bash
python3 scripts/check_swift_snippets.py
```

Pass a path to check one plugin or file. The script needs Xcode with a visionOS
SDK and exits successfully (skipping) where none is installed. It fails only on
diagnostics that indict the documentation - an unknown type or member, a wrong
argument label, or API unavailable on visionOS. Snippets that are illustrative
fragments referencing app-specific types are reported as skipped, not failed.

### Shared skill sync

The repo-to-repo sync workflow with `visionOSAgents` is documented in
`docs/sync-agents.skills.md`. That document is only for keeping the shared
skill set aligned between the two repos.

## Credits

These plugins and shared skill work were inspired by the work of:

- [Ivan Campos](https://github.com/ivancampos)
- [Paul Hudson](https://github.com/twostraws)
- [Pedro Piñera Buendía](https://github.com/pepicrft)
- [Thomas Ricouard](https://github.com/Dimillian/)
- [Sharno](https://github.com/sharno)
