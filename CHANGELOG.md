# Changelog

## 1.2.0 - 2026-06-10

- Added visionOS 27 (beta) coverage to the shared RealityKit skill: 16 new
  references for Gaussian splats, compute-graph particles, cloth simulation,
  animation graphs and retargeting, navigation and behavior trees,
  post-processing components (tone mapping, bloom, decals, clipping, LOD,
  occlusion culling), render layers and shadows, lightmaps and probes, audio
  playback groups and simulated acoustics, USD stages, and volumetric portals
  with accessory anchoring.
- Added USDKit framework coverage to the USD editor skill, including the
  Swift-native stage/prim/layer API and a USDKit-vs-CLI decision guide.
- Added a new plugin-local `spatial-preview-developer` skill for the macOS 27
  Spatial Preview frameworks that stream documents and live USD stages to
  Apple Vision Pro.
- Added visionOS 27 ARKit guidance: `VisualFidelityProvider`, live accessory
  updates, high-frame-rate object tracking, and anchor coordinate-space
  conformance.
- Added programmatic shader graph guidance (`ShaderGraph` module,
  `ShaderGraphMaterial.Program`, lighting models, subsurface scattering) to
  the Shader Graph skill.
- Added an in-app ScreenCaptureKit-on-visionOS reference to the UI automation
  skill, including the picker-only filter model and unavailable-API list.
- Added SwiftUI `RotateGesture3D` input-kind constraints and widget
  container-background guidance verified against the visionOS 27 SDK.
- Replaced WWDC-anchored staleness markers with SDK-verified availability
  floors across RealityKit references, and rewrote the AttachedTransform and
  DockingRegion component references from the actual SDK API.
- Retargeted the plugin to visionOS 27 as the minimum supported release:
  plugin metadata, READMEs, build/run, and SwiftPM guidance now target
  visionOS 27, sub-27 availability annotations were removed across the
  skills, and the SwiftPM platform floor moved to `.visionOS(.v27)`.
  Xcode-beta SDK semantics were corrected along the way.
- Fixed plugin validation: skill icons moved so `validate_plugin.py` passes,
  `defaultPrompt` converted to the spec's array form, missing
  `agents/openai.yaml` added to three skills, and over-long short
  descriptions shortened.

## 1.1.4 - 2026-06-04

- Renamed the marketplace display name from `visionOS Codex Plugins` to
  `Studio Meije`.
- Updated the plugin manifest version for the marketplace metadata release.

## 1.1.3 - 2026-06-04

- Refined shared visionOS skill guidance around official Apple frameworks,
  including RealityKit `GestureComponent`, SwiftUI scene lifecycle APIs,
  button shape guidance, immersive media events, SharePlay, WidgetKit, USD, and
  Shader Graph boundaries.
- Removed stale route-only documentation and eliminated duplicated or
  meta-guidance notes from skill references.
- Removed Apple documentation link sections and literal documentation
  identifiers from bundled skill markdown.
- Synced the shared skill set from the packaged plugin back to
  `visionOSAgents`.

## 1.1.2 - 2026-04-29

- Added SwiftUI spatial layout guidance for intentional ZStack depth in
  visionOS 26.
- Documented when to use `ZStack(alignment:spacing:)`,
  `frame(depth:alignment:)`, layout `depthAlignment(_:)`, `SpatialContainer`,
  `spatialOverlay`, and `offset(z:)`.
- Clarified that `offset(z:)` is best for small visual lifts and that
  `zIndex(_:)` affects drawing order, not spatial depth.
- Added examples for stable card depth, raised labels, and front-aligned
  controls beside 3D content.

## 1.1.1 - 2026-04-28

- Added shared visionOS SwiftUI guidance requiring intentional
  `.buttonBorderShape(...)` usage for visible button-like controls.
- Added review coverage for `Button`, button-like `NavigationLink`, `ShareLink`,
  and widget AppIntent button surfaces.
- Synced the new control-shape guidance from `visionOSAgents` into the packaged
  `build-visionos-apps` plugin.

## 1.1.0 - 2026-04-23

- Sharpened the plugin metadata, README, and command entrypoints around
  XcodeBuildMCP-first visionOS 26 workflows.
- Improved the build/run/debug, SwiftPM, test triage, telemetry, AXe automation,
  signing, entitlements, packaging, and distribution skill guidance.
- Expanded shared `visionOSAgents` skills for spatial SwiftUI, RealityKit, ARKit,
  SharePlay, USD, ShaderGraph, immersive media, WidgetKit, and Swift coding
  standards.
- Strengthened the default guidance for new SwiftUI and visionOS code to use
  `@Observable` instead of `ObservableObject` unless a compatibility blocker is
  documented.
- Improved the plugin installer, marketplace metadata update flow, package
  workflow validation, and shared-skill sync documentation.
- Added deterministic Run-button bootstrap checks for Apple Vision Pro Simulator
  selection, app bundle resolution, and project-local DerivedData paths.
