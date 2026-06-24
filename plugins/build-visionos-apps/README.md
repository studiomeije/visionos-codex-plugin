# Build visionOS 27 apps Plugin

This plugin packages XcodeBuildMCP-first development workflows and
visionOS-specific skills for Apple Vision Pro apps.

It intentionally no longer owns the full RealityKit or Reality Composer Pro 3
skill surface. Runtime RealityKit work belongs in `build-realitykit`; authored
RCP3 graph, package, and USD asset-pipeline work belongs in
`build-reality-composer-pro-3`.

## Included Skills

- `build-run-debug`
- `test-triage`
- `visionos-ui-automation`
- `signing-entitlements`
- `swiftpm-visionos`
- `packaging-distribution`
- `spatial-preview-developer`
- `spatial-app-architecture`
- `telemetry`
- `coding-standards-enforcer`
- `spatial-swiftui-developer`
- `swiftui-chart3d-developer`
- `arkit-visionos-developer`
- `arkit-spatial-tracking-providers`
- `arkit-hand-tracking-provider`
- `arkit-reference-tracking-providers`
- `arkit-camera-access-providers`
- `arkit-rendering-context-providers`
- `visionos-immersive-media-developer`
- `shareplay-developer`
- `visionos-widgetkit-developer`

## What It Covers

- discovering local Xcode workspaces, projects, and Swift packages for visionOS
- building and running visionOS apps on Apple Vision Pro Simulator with
  XcodeBuildMCP as the primary path and a project-local
  `script/build_and_run.sh` fallback for the Codex app Run button
- choosing the right scene surface: window, volumetric window, or
  `ImmersiveSpace`, and tuning default size, placement, launch, and restoration
  behavior
- implementing spatial SwiftUI with `RealityView`, `Model3D`, attachments,
  volumetric windows, progressive/full/mixed immersion styles, surface snapping,
  world recenter, volume viewpoints, and spatial gestures
- integrating ARKit providers with authorization flows and shared-space vs
  full-space behavior
- streaming Mac documents and live USD stages to Vision Pro with Spatial
  Preview
- implementing immersive and spatial video playback, SharePlay GroupActivities,
  WidgetKit widgets, and Vision Pro specific interaction surfaces
- refactoring large visionOS view files toward stable scene, immersive, and
  feature structure
- adding `Logger` / `OSLog` instrumentation, `OSSignposter` spans, and
  Instruments workflows for spatial performance
- triaging failing XCTest and Swift Testing targets on the visionOS simulator
- driving simulator UI automation and evidence capture with XCTest/XCUITest,
  XcodeBuildMCP or `xcodebuild`, `xcrun simctl`, and app-designed debug hooks
- inspecting signing identities, entitlements, enterprise ARKit entitlements,
  and visionOS-specific privacy keys
- automating App Store Connect workflows through the packaging skill when the
  optional `asc` CLI is available

## Cross-Plugin Routing

- Use `build-realitykit` for RealityKit runtime entity/component work,
  rendering, animation, physics, audio, custom systems, and USDKit.
- Use `build-reality-composer-pro-3` for Shader Graph, Script Graph,
  Animation Graph, Reality Composer Pro 3 package inspection, USD ASCII edits,
  and USDZ validation.

## Plugin Structure

- `.codex-plugin/plugin.json` defines plugin metadata.
- `.mcp.json` ships `XcodeBuildMCP` and the official `xcode` MCP bridge.
- `agents/` contains plugin-level agent metadata.
- `assets/` contains plugin branding assets.
- `commands/` contains reusable command entrypoints.
- `scripts/` contains the Run-button fallback bootstrap helper.
- `skills/` contains visionOS-specific skills and workflow skills.

## Optional External CLIs

One standalone command-line tool complements XcodeBuildMCP and is documented
directly by the skill that uses it. It is not bundled and is not required for
the core build/run/debug or UI automation loop:

- `asc` for App Store Connect automation such as TestFlight uploads, metadata,
  screenshots, certificates, profiles, and submission workflows.

The App Store Connect API key is a credential; the packaging skill enforces
that `asc auth login` is run by the user, not by the agent.
