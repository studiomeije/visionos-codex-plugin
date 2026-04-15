# Build visionOS Apps

`build-visionos-apps` is a plugin for building, debugging, refactoring, and
shipping visionOS 26 apps for Apple Vision Pro. It supports both **Codex** and
**Claude Code** runtimes under a shared repository.

## Repository Structure

```
plugins/build-visionos-apps/
├── codex/          ← Original Codex plugin (unchanged)
└── claude/         ← Claude Code plugin (new)
```

Each flavour is self-contained with its own skills, commands, agents, and
configuration. The platform knowledge (RealityKit, ARKit, spatial SwiftUI,
SharePlay, USD, Shader Graph, signing, immersive media) is shared across both;
the Claude Code flavour adds engineering workflow skills and agent personas.

## What The Plugin Does

- Discovers local Xcode workspaces, projects, schemes, Swift packages, and
  Apple Vision Pro simulator targets
- Builds, runs, debugs, and captures logs for visionOS apps with
  `XcodeBuildMCP`
- Helps choose the right surface model: window, volume, immersive space, or a
  mixed flow between them
- Guides scene ownership, app structure, and spatial SwiftUI architecture
- Implements and troubleshoots RealityKit, ARKit, SharePlay, WidgetKit,
  immersive media, Shader Graph, and USD workflows
- Triages tests, signing failures, entitlement issues, privacy-key gaps, and
  launch blockers
- Supports packaging, TestFlight, and App Store submission workflows

## Claude Code Installation

```bash
claude plugin install build-visionos-apps
```

The plugin registers XcodeBuildMCP as an MCP server automatically via
`marketplace.json`.

### Claude Code Features

**Engineering Workflow Skills** (new in the Claude Code flavour):

| Skill | Purpose |
|-------|---------|
| `spec-driven-spatial` | Write a feature spec before writing code, gated on scene model decision |
| `incremental-build` | Thin vertical slices - one RealityKit component/system at a time |
| `debugging-triage` | Five-step triage: reproduce, classify, isolate, fix, test |
| `adr-spatial` | Architecture decision records for spatial design choices |
| `git-workflow` | Atomic commits, dedicated .xcodeproj and .entitlements commits |

**Agent Personas:**

| Agent | When to Use |
|-------|-------------|
| `spatial-architect` | New feature specs, architecture reviews, scene model decisions |
| `realitykit-debugger` | Build succeeds but runtime behaviour is wrong |
| `xcode-build-agent` | Build failures, signing issues, distribution tasks |

**Slash Commands:**

| Command | Purpose |
|---------|---------|
| `/build-and-run-visionos-app` | Build and launch on Apple Vision Pro simulator |
| `/fix-visionos-capability-error` | Diagnose and fix capability/signing errors |
| `/test-visionos-app` | Run tests with failure classification |
| `/spec` | Start a feature specification |
| `/plan` | Break a spec into ordered, verifiable tasks |
| `/review` | Multi-axis code review (correctness, spatial, Swift, security, performance) |
| `/ship` | Pre-launch checklist for TestFlight and App Store |

## Codex Installation

The original Codex plugin is now located at `plugins/build-visionos-apps/codex/`.

### Option 1: Download The Packaged ZIP

Download `build-visionos-apps.zip` from the release assets and unzip into your
Codex plugins directory:

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/plugins"
unzip build-visionos-apps.zip -d "${CODEX_HOME:-$HOME/.codex}/plugins"
```

### Option 2: Clone The Repo And Use The Installer Script

```bash
git clone https://github.com/studiomeije/visionos-codex-plugin.git
cd visionos-codex-plugin
./scripts/install-plugin.sh
```

The script copies the plugin from `plugins/build-visionos-apps/codex/` into your
Codex plugins directory. Target a custom location with:

```bash
./scripts/install-plugin.sh --home ~/.codex
./scripts/install-plugin.sh --plugins-dir /path/to/codex/plugins
```

### Codex Usage

- Ask directly for the outcome you want and let Codex choose the bundled skills
- Type `@` to invoke `Build visionOS Apps` or one of its skills explicitly
- Use the command layer: `/build-and-run-visionos-app`,
  `/fix-visionos-capability-error`, or `/test-visionos-app`

## Platform Skills (Both Flavours)

Both Codex and Claude Code flavours include these platform skills:

- **Spatial App Architecture** - scene model, surface selection, state ownership
- **RealityKit** - entities, components, systems, render loop
- **ARKit** - sessions, providers, anchors, tracked world
- **SharePlay** - group activities, shared immersive presence
- **Shader Graph** - materials authoring and debugging
- **USD** - asset editing, validation, runtime loading
- **Signing and Entitlements** - signing, entitlements, privacy keys
- **Immersive Media** - spatial video, immersive playback
- **Spatial SwiftUI** - spatial views, scene types, visionOS modifiers

## Optional External Tools

- `AXe` for post-launch simulator automation, screenshots, and accessibility
  inspection
- `asc` for App Store Connect automation (TestFlight, metadata, submission)

These tools are not bundled with the plugin.

## Maintenance

The repo-to-repo sync workflow with `visionOSAgents` is documented in
`docs/sync-agents.skills.md`.

---

## Credits

This plugin and its shared skill work were inspired by the work of:

- [Ivan Campos](https://github.com/ivancampos)
- [Paul Hudson](https://github.com/twostraws)
- [Pedro Pinera Buendia](https://github.com/pepicrft)
- [Thomas Ricouard](https://github.com/Dimillian/)
- [Sharno](https://github.com/sharno)

The Claude Code engineering workflow skills are adapted from
[agent-skills](https://github.com/addyosmani/agent-skills) by
[Addy Osmani](https://github.com/addyosmani).
