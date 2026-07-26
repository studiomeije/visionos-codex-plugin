# Build visionOS 27 apps Plugin

This plugin packages first-party Xcode development workflows and
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
- `spatial-app-architecture`
- `spatial-swiftui-developer`
- `arkit-visionos-developer`
- `visionos-immersive-media-developer`
- `shareplay-developer`
- `visionos-widgetkit-developer`

## What It Covers

- discovering local Xcode workspaces, projects, and Swift packages for visionOS
- building and running visionOS apps on Apple Vision Pro Simulator with the
  official Xcode bridge or direct `xcodebuild` and `simctl`, plus a
  project-local `script/build_and_run.sh` for the Codex app Run button
- choosing the right scene surface: window, volumetric window, or
  `ImmersiveSpace`, and tuning default size, placement, launch, and restoration
  behavior
- implementing spatial SwiftUI with `RealityView`, `Model3D`, attachments,
  volumetric windows, progressive/full/mixed immersion styles, surface snapping,
  world recenter, volume viewpoints, spatial gestures, and Chart3D
- integrating ARKit providers with authorization flows and shared-space vs
  full-space behavior
- implementing immersive and spatial video playback, SharePlay GroupActivities,
  WidgetKit widgets, and Vision Pro specific interaction surfaces
- refactoring large visionOS view files toward stable scene, immersive, and
  feature structure
- handing running RealityKit performance investigations to
  `profile-realitykit-apps`
- triaging failing XCTest and Swift Testing targets on the visionOS simulator
- driving simulator UI automation and evidence capture with XCTest/XCUITest,
  `xcodebuild`, `xcrun simctl`, and app-designed debug hooks
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
- Use `profile-realitykit-apps` for RealityKit logs, signposts, Instruments
  traces, bottleneck analysis, and before-and-after performance verification.

## Plugin Structure

- `.codex-plugin/plugin.json` defines plugin metadata.
- `.mcp.json` ships the official `xcode` MCP bridge.
- `agents/` contains plugin-level agent metadata.
- `assets/` contains plugin branding assets.
- `commands/` contains reusable command entrypoints.
- `scripts/` contains the Run-button bootstrap helper.
- `skills/` contains visionOS-specific skills and workflow skills.

## Optional External CLIs

One standalone command-line tool complements the first-party Xcode workflow
and is documented directly by the skill that uses it. It is not bundled and
is not required for the core build/run/debug or UI automation loop:

- `asc` for App Store Connect automation such as TestFlight uploads, metadata,
  screenshots, certificates, profiles, and submission workflows.

The App Store Connect API key is a credential; the packaging skill enforces
that `asc auth login` is run by the user, not by the agent.

## Installation

Install this plugin only through the Studio Meije Codex marketplace:

```bash
codex plugin marketplace add studiomeije/visionos-codex-plugin --ref main
codex plugin add build-visionos-apps@visionos-codex-marketplace
```

For local development, replace the GitHub source with the absolute path to this
repository. Do not copy this plugin into a Codex home manually.
