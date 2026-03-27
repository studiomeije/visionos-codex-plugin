# Build visionOS Apps Plugin

This plugin packages visionOS 26 development workflows in
`plugins/build-visionos-apps` for Apple Vision Pro.

It currently includes these skills:

- `build-run-debug`
- `test-triage`
- `visionos-ui-automation`
- `signing-entitlements`
- `swiftpm-visionos`
- `packaging-distribution`
- `spatial-app-architecture`
- `telemetry`
- `coding-standards-enforcer`
- `spatial-swiftui-developer`
- `realitykit-visionos-developer`
- `arkit-visionos-developer`
- `shadergraph-editor`
- `usd-editor`
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
- authoring Reality Composer Pro Shader Graph materials and loading them at
  runtime via `ShaderGraphMaterial` with promoted inputs
- editing USD ASCII (`.usda`) files, inspecting stages, and packaging USDZ for
  RealityKit
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
- driving post-launch simulator automation (screenshots, video capture,
  accessibility-tree dumps, keyboard flows) with [AXe](https://github.com/cameroncooke/AXe)
  as a complement to XCTest/XCUITest
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
  - the actual skill payload
  - each skill keeps the standard skill structure (`SKILL.md`, optional
    `references/`, `samples/`, `scripts/`)

## Optional External CLIs

Two standalone command-line tools complement XcodeBuildMCP and are
documented directly by the skills that use them. They are not bundled and
are not required for the core build/run/debug loop:

Treat the upstream tool help and README as the source of truth for current
flags and subcommands:

- `axe --help` / `axe <command> --help`
- `asc --help` / `asc <command> --help`

- **AXe** (`brew install cameroncooke/axe/axe`) — simulator automation for
  screenshots, video, keyboard input, hardware buttons, and accessibility
  trees. Used by `visionos-ui-automation`. AXe's 2D touch commands
  (`tap`/`swipe`/`gesture`) target iOS and are not reliable on visionOS;
  the skill documents exactly which commands work on the Apple Vision Pro
  simulator and routes spatial gestures back to XCUITest.
- **App Store Connect CLI** (`brew install asc`) — JWT-authenticated
  automation for TestFlight, App Store submission, metadata, screenshots,
  certificates, profiles, and Xcode Cloud. Used by `packaging-distribution`.
  The App Store Connect API key is a credential; the skill enforces that
  `asc auth login` is run by the user, not by the agent, and that the
  `.p8` never lands in chat or repo files. Apple’s upload docs remain the
  authority for Transporter and `altool` behavior.

## Notes

This plugin is XcodeBuildMCP-first. Unlike the canonical
`plugins/build-macos-apps` shape, it deliberately ships `.mcp.json` and a
bootstrap helper script because the Apple Vision Pro simulator launch loop
benefits from a dedicated MCP server and a deterministic shell fallback.
AXe and `asc` sit on top of that as optional, external CLIs for
post-launch simulator automation and App Store Connect workflows
respectively.

The shared core skill layer (`spatial-app-architecture`,
`spatial-swiftui-developer`, `realitykit-visionos-developer`,
`arkit-visionos-developer`, `shareplay-developer`,
`visionos-immersive-media-developer`, `visionos-widgetkit-developer`,
`shadergraph-editor`, `usd-editor`, `coding-standards-enforcer`) carries the
visionOS-specific architecture and implementation guidance. The plugin-local
workflow skills (`build-run-debug`, `test-triage`, `signing-entitlements`,
`swiftpm-visionos`, `packaging-distribution`, `telemetry`,
`visionos-ui-automation`) mirror the shape of `build-macos-apps` with
visionOS-specific adjustments.
