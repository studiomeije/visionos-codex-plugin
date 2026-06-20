# Build visionOS Apps Plugin

This plugin packages XcodeBuildMCP-first development workflows for visionOS 27
apps in `plugins/build-visionos-apps` for Apple Vision Pro.

It combines shared platform skills synced from `visionOSAgents` with
plugin-local workflow skills for build/run/debug, testing, signing, telemetry,
packaging, UI automation, command entrypoints, and Run-button fallback
bootstrap.

It currently includes these skills:

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
- `realitykit-visionos-developer`
- `realitykit-rendering-materials`
- `realitykit-animation-physics`
- `realitykit-audio-spatial`
- `realitykit-ecs-systems`
- `arkit-visionos-developer`
- `arkit-spatial-tracking-providers`
- `arkit-hand-tracking-provider`
- `arkit-reference-tracking-providers`
- `arkit-camera-access-providers`
- `arkit-rendering-context-providers`
- `shadergraph-editor`
- `usd-editor`
- `usdkit-runtime-developer`
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
- building RealityKit scenes with entities, components, custom systems,
  `ManipulationComponent`, `HoverEffectComponent`, portals, and
  `SpatialTrackingSession`
- integrating ARKit providers (world tracking, hand tracking, plane detection,
  scene reconstruction, image/object/room tracking, accessory tracking, barcode
  detection) with authorization flows and shared-space vs full-space behavior
- streaming Mac documents and live USD stages to Vision Pro with Spatial
  Preview
- authoring Reality Composer Pro Shader Graph materials and loading them at
  runtime via `ShaderGraphMaterial` with promoted inputs
- editing USD ASCII (`.usda`) files, inspecting stages, packaging USDZ for
  RealityKit, and using USDKit runtime stage APIs when the app owns live USD
- implementing immersive and spatial video playback with RealityKit
  `VideoPlayerComponent`, AVKit `AVExperienceController`, Apple Projected Media
  Profile, and comfort mitigation events
- integrating SharePlay GroupActivities for visionOS including spatial
  coordination via `SystemCoordinator` and group immersion styles
- building WidgetKit widgets for Apple Vision Pro with mounting styles,
  textures, proximity-aware `LevelOfDetail` layouts, and interactive widgets
- refactoring large visionOS view files toward stable scene, immersive, and
  feature structure
- adding `Logger` / `OSLog` instrumentation, `OSSignposter` spans, and
  Instruments RealityKit Trace workflows for spatial performance
- triaging failing XCTest and Swift Testing targets on the visionOS simulator
- driving simulator UI automation and evidence capture with XCTest/XCUITest,
  XcodeBuildMCP or `xcodebuild`, `xcrun simctl`, and app-designed debug hooks
- inspecting signing identities, entitlements, enterprise ARKit entitlements,
  and visionOS-specific privacy keys
- automating App Store Connect workflows (TestFlight uploads, App Store
  submissions, metadata, screenshots, review status) with the
  [App Store Connect CLI](https://github.com/rudrankriyam/App-Store-Connect-CLI)
  (`asc`)

## What It Does Not Cover

- iOS, macOS, watchOS, or tvOS simulator control
- pixel-perfect visual design or design-system generation
- App Store Connect release management beyond the packaging/distribution
  entry points that the packaging skill describes

## Plugin Structure

The plugin lives at:

- `plugins/build-visionos-apps/`

with this shape:

- `.codex-plugin/plugin.json`
  - required plugin manifest
  - defines plugin metadata and points Codex at the plugin contents

- `.mcp.json`
  - ships `XcodeBuildMCP` via `npx -y xcodebuildmcp@latest mcp`
  - enables `simulator`, `debugging`, and `logging` workflows
  - ships the official Xcode MCP server via `xcrun mcpbridge`
  - treats XcodeBuildMCP as the default build/run/debug path, with
    `xcode` / `mcpbridge` reserved for active Xcode session capabilities

- `agents/`
  - plugin-level agent metadata
  - currently includes `agents/openai.yaml` for the OpenAI surface

- `assets/`
  - plugin branding assets (`icon.png`)

- `commands/`
  - reusable command entrypoints (`build-and-run-visionos-app`,
    `fix-visionos-capability-error`, `test-visionos-app`) that cross-link
    directly into the relevant skills

- `scripts/`
  - `bootstrap_build_and_run.sh`: generates a project-local
    `script/build_and_run.sh` + `.codex/environments/environment.toml` so the
    Codex app Run button works even when XcodeBuildMCP is unavailable

- `skills/`
  - shared platform skills and plugin-local workflow skills
  - each skill keeps the standard skill structure (`SKILL.md`, optional
    `references/`, `samples/`, `scripts/`)

## Optional External CLIs

One standalone command-line tool complements XcodeBuildMCP and is documented
directly by the skill that uses it. It is not bundled and is not required for
the core build/run/debug or UI automation loop:

Treat the upstream tool help and README as the source of truth for current
flags and subcommands:

- `asc --help` / `asc <command> --help`

- **App Store Connect CLI** (`brew install asc`) — JWT-authenticated
  automation for TestFlight, App Store submission, metadata, screenshots,
  certificates, profiles, and Xcode Cloud. Used by `packaging-distribution`.
  The App Store Connect API key is a credential; the skill enforces that
  `asc auth login` is run by the user, not by the agent, and that the
  `.p8` never lands in chat or repo files. Apple’s upload docs remain the
  authority for Transporter and `altool` behavior.

## Notes

This plugin is XcodeBuildMCP-first. It ships `.mcp.json` and a bootstrap
helper script because the Apple Vision Pro simulator launch loop benefits from
a dedicated MCP server and a deterministic shell fallback. UI automation uses
first-party XCTest/XCUITest, XcodeBuildMCP or `xcodebuild`, `simctl`, app debug
hooks. `asc` sits on top of the packaging skill as the only optional external
CLI for App Store Connect workflows.

The plugin also ships the official `xcode` MCP bridge through `xcrun
mcpbridge`. That bridge is intentionally secondary: use it for live Xcode
debugger or Xcode-owned session/device state, not as the default replacement
for XcodeBuildMCP's project discovery, scheme selection, simulator selection,
build, install, launch, log, and test workflow.

The shared platform skill layer (`spatial-app-architecture`,
`spatial-swiftui-developer`, `swiftui-chart3d-developer`,
`realitykit-visionos-developer`, `realitykit-rendering-materials`,
`realitykit-animation-physics`, `realitykit-audio-spatial`,
`realitykit-ecs-systems`, `arkit-visionos-developer`,
`arkit-spatial-tracking-providers`, `arkit-hand-tracking-provider`,
`arkit-reference-tracking-providers`, `arkit-camera-access-providers`,
`arkit-rendering-context-providers`, `shareplay-developer`,
`visionos-immersive-media-developer`, `visionos-widgetkit-developer`,
`shadergraph-editor`, `usd-editor`, `usdkit-runtime-developer`,
`coding-standards-enforcer`) carries the visionOS-specific architecture and
implementation guidance. The plugin-local workflow skills (`build-run-debug`,
`test-triage`, `signing-entitlements`, `swiftpm-visionos`,
`packaging-distribution`, `telemetry`, `visionos-ui-automation`,
`spatial-preview-developer`) cover the operational loop and Vision Pro-adjacent
tooling around a visionOS 27 codebase.
