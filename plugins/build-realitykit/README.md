# Build with RealityKit Plugin

This plugin packages RealityKit runtime development skills for Apple platforms.
It is meant to stand beside `build-visionos-apps` and
`build-reality-composer-pro-3` instead of being buried inside the visionOS
plugin.

## Included Skills

- `realitykit-visionos-developer`
- `realitykit-rendering-materials`
- `realitykit-animation-physics`
- `realitykit-audio-spatial`
- `realitykit-ecs-systems`
- `usdkit-runtime-developer`

## Best Fit

Use this plugin when the task is primarily RealityKit runtime code or behavior:
entity loading, component selection, rendering, materials, animation, physics,
audio, custom systems, USDKit runtime stages, or runtime integration of
authored assets.

Use `build-visionos-apps` when the task is primarily a visionOS app surface,
ARKit provider, entitlement, build, launch, test, distribution, or simulator
workflow. Use `build-reality-composer-pro-3` when the source of truth is an
authored Reality Composer Pro 3 project, graph, package, or USD asset pipeline.
Use `profile-realitykit-apps` when the app already runs and the task is to
collect logs or signposts, capture or inspect an Instruments trace, diagnose
CPU/GPU/memory cost, or verify a performance improvement.

## Installation

Install this plugin only through the Studio Meije Codex marketplace:

```bash
codex plugin marketplace add studiomeije/visionos-codex-plugin --ref main
codex plugin add build-realitykit@visionos-codex-marketplace
```

For local development, replace the GitHub source with the absolute path to this
repository. Do not copy this plugin into a Codex home manually.
