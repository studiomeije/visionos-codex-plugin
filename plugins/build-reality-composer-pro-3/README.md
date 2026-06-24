# Build with Reality Composer Pro 3 Plugin

This plugin packages authored Reality Composer Pro 3 and USD asset-pipeline
skills. It is separate from the RealityKit runtime plugin so graph/package
authoring does not get mixed with app runtime code.

## Included Skills

- `shadergraph-editor`
- `scriptgraph-editor`
- `animationgraph-editor`
- `usd-editor`

## Best Fit

Use this plugin when the editable source of truth is a
`.realitycomposerpro` project, Shader Graph material, Script Graph behavior,
Animation Graph state machine, package internals, USDA layer, or USDZ asset
pipeline.

Use `build-realitykit` when the task is runtime Swift, entities, components,
systems, animation playback, physics, audio, rendering, or USDKit. Use
`build-visionos-apps` when the task is app structure, ARKit, build/run/debug,
testing, signing, packaging, simulator automation, or Vision Pro specific
workflow.
