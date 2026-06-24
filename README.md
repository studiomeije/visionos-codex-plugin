# Studio Meije Spatial Codex Plugins

This repository packages three Codex plugins for Apple spatial-computing work:

- `build-visionos-apps` - Build visionOS 27 apps.
- `build-realitykit` - Build with RealityKit.
- `build-reality-composer-pro-3` - Build with Reality Composer Pro 3.

The split keeps platform app work, runtime RealityKit work, and authored RCP3
asset work in separate plugin surfaces while allowing each plugin to route to
the others when a task crosses boundaries.

## Plugin Roles

### Build visionOS 27 apps

Use `build-visionos-apps` for Apple Vision Pro app work:

- XcodeBuildMCP-first build, run, debug, log, and simulator workflows
- spatial SwiftUI, windows, volumes, immersive spaces, ornaments, and app
  architecture
- ARKit providers, SharePlay, WidgetKit, immersive media, Spatial Preview, and
  Vision Pro specific interaction workflows
- signing, entitlements, privacy keys, testing, telemetry, SwiftPM, packaging,
  distribution, and simulator UI automation

This plugin links out to `build-realitykit` when the task becomes RealityKit
runtime code, and to `build-reality-composer-pro-3` when authored graph,
package, or USD asset-pipeline work is the source of truth.

### Build with RealityKit

Use `build-realitykit` for cross-platform RealityKit runtime development:

- entity loading, component selection, scene ownership, and runtime integration
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
`build-visionos-apps`.

### Build with Reality Composer Pro 3

Use `build-reality-composer-pro-3` for authored asset workflows:

- Reality Composer Pro 3 Shader Graph materials and promoted inputs
- Script Graph event/action behavior and package inspection
- Animation Graph / Animator Graph state machines, transitions, parameters,
  tags, and clip bindings
- text-level USD ASCII edits, command-line USD inspection, USDZ packaging, and
  Apple-platform validation

This plugin routes runtime Swift integration to `build-realitykit` and app
build/run/debug or RealityKitContent package wiring to `build-visionos-apps`.

## Installation

For local development, add this repository as a marketplace source:

```bash
codex plugin marketplace add /absolute/path/to/visionos-codex-plugin
```

Restart Codex, open the Studio Meije marketplace source, and install the
plugin or plugins you need.

You can also install all packaged plugins from this checkout:

```bash
./scripts/install-plugin.sh
```

The installer copies:

```text
${CODEX_HOME:-$HOME/.codex}/plugins/build-visionos-apps
${CODEX_HOME:-$HOME/.codex}/plugins/build-realitykit
${CODEX_HOME:-$HOME/.codex}/plugins/build-reality-composer-pro-3
```

and updates `~/.agents/plugins/marketplace.json` with all three plugin entries.

## Maintenance

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
