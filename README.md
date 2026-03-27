# Build visionOS Apps for Codex

`build-visionos-apps` is a Codex plugin for building, debugging, refactoring,
and shipping visionOS 26 apps for Apple Vision Pro.

It combines XcodeBuildMCP-backed build and simulator workflows with focused
skills for spatial SwiftUI, RealityKit, ARKit, SharePlay, WidgetKit, Shader
Graph, USD, immersive media, testing, signing, and packaging.

## What The Plugin Does

- discovers local Xcode workspaces, projects, schemes, Swift packages, and
  Apple Vision Pro simulator targets
- builds, runs, debugs, and captures logs for visionOS apps with
  `XcodeBuildMCP`
- helps choose the right surface model: window, volume, immersive space, or a
  mixed flow between them
- guides scene ownership, app structure, and spatial SwiftUI architecture as a
  codebase grows
- implements and troubleshoots RealityKit, ARKit, SharePlay, WidgetKit,
  immersive media, Shader Graph, and USD workflows
- triages tests, signing failures, entitlement issues, privacy-key gaps, and
  launch blockers
- supports packaging, TestFlight, and App Store submission workflows when the
  optional `asc` CLI is available
- supports simulator evidence capture and automation when the optional `AXe`
  CLI is available

## Best Fit

This plugin is a strong fit when you want Codex to help with:

- building and launching a visionOS app on Apple Vision Pro Simulator
- refactoring an oversized spatial app into cleaner scene and feature
  boundaries
- debugging RealityKit, ARKit, SharePlay, or immersive-media behavior
- fixing signing, privacy, capability, or simulator test failures
- preparing a visionOS app for packaging or distribution

## Included Expertise

The plugin bundles both workflow skills and platform skills.

- Workflow coverage includes build and run, test triage, telemetry,
  signing/entitlements, SwiftPM support, packaging/distribution, and
  visionOS-specific UI automation.
- Platform coverage includes spatial app architecture, spatial SwiftUI,
  RealityKit, ARKit, SharePlay, WidgetKit, Shader Graph, USD, immersive media,
  and coding standards for modern Swift and visionOS app code.

## Use In Codex

- Ask directly for the outcome you want and let Codex choose the bundled
  skills.
- Type `@` to invoke `Build visionOS Apps` or one of its skills explicitly.
- Use the command layer when you want a narrower entrypoint:
  `/build-and-run-visionos-app`, `/fix-visionos-capability-error`, or
  `/test-visionos-app`.

## Optional External Tools

The core build/debug loop does not require extra CLIs, but two optional tools
extend what the plugin can do:

- `AXe` for post-launch Apple Vision Pro simulator automation, screenshots,
  accessibility inspection, and capture workflows
- `asc` for App Store Connect automation such as TestFlight uploads, metadata,
  and submission workflows

These tools are not bundled with the plugin.

## Installation

The plugin installs into `${CODEX_HOME:-~/.codex}/plugins/build-visionos-apps`.
If you use a non-default Codex home, replace `~/.codex` with `$CODEX_HOME`.

### Option 1: Download The Packaged ZIP

The GitHub Actions workflow at `.github/workflows/package-plugin.yml` builds
`build-visionos-apps.zip` from `plugins/build-visionos-apps/`.

The zip is created only for published GitHub releases. Download
`build-visionos-apps.zip` from the release assets.

Install it by unzipping into your Codex plugins directory:

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/plugins"
unzip build-visionos-apps.zip -d "${CODEX_HOME:-$HOME/.codex}/plugins"
```

That creates:

```text
${CODEX_HOME:-$HOME/.codex}/plugins/build-visionos-apps
```

### Option 2: Clone The Repo And Use The Installer Script

Clone the repo, then run the installer:

```bash
git clone https://github.com/studiomeije/visionos-codex-plugin.git
cd visionos-codex-plugin
./scripts/install-plugin.sh
```

The script removes any previous install of `build-visionos-apps` and copies the
packaged plugin from `plugins/build-visionos-apps/` into your Codex plugins
directory. You can also target a custom location:

```bash
./scripts/install-plugin.sh --home ~/.codex
./scripts/install-plugin.sh --plugins-dir /path/to/codex/plugins
```

Keep the marketplace entry in `.agents/plugins/marketplace.json`, then restart
Codex so it picks up the updated plugin and MCP config.

## Maintenance

The repo-to-repo sync workflow with `visionOSAgents` is documented in
`docs/sync-agents.skills.md`. That document is only for keeping the shared
skill set aligned between the two repos.

---

## Credits

This plugin and its shared skill work were inspired by the work of:

- [Ivan Campos](https://github.com/ivancampos)
- [Paul Hudson](https://github.com/twostraws)
- [Pedro Piñera Buendía](https://github.com/pepicrft)
- [Thomas Ricouard](https://github.com/Dimillian/)
- [Sharno](https://github.com/sharno)
