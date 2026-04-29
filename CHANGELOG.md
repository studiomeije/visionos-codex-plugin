# Changelog

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
