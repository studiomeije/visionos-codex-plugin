---
name: build-visionos-apps
description: Build, debug, and ship visionOS 26 apps for Apple Vision Pro. Combines XcodeBuildMCP-backed build workflows with spatial SwiftUI, RealityKit, ARKit, SharePlay, and engineering best practices including spec-driven development, incremental builds, and architectural decision records.
---

# Build visionOS Apps

## Overview

This plugin provides skills, agents, and commands for building visionOS 26 applications for Apple Vision Pro. It combines platform-specific expertise (RealityKit, ARKit, spatial SwiftUI, SharePlay, USD, Shader Graph) with disciplined engineering workflows (spec-driven development, incremental implementation, debugging triage, architecture decision records, git workflow).

## Skill Map

### Platform Skills

| Skill | Use When |
|-------|----------|
| [spatial-architecture](skills/spatial-architecture/SKILL.md) | Choosing window vs volume vs immersive space, defining scene boundaries, state ownership |
| [realitykit](skills/realitykit/SKILL.md) | Working with entities, components, systems, render loop, and RealityKit runtime |
| [arkit](skills/arkit/SKILL.md) | Configuring ARKit sessions, providers, anchors, and tracked-world behaviour |
| [shareplay](skills/shareplay/SKILL.md) | Implementing group activities, shared immersive presence, spatial coordination |
| [shader-graph](skills/shader-graph/SKILL.md) | Authoring and debugging Shader Graph materials for RealityKit |
| [usd](skills/usd/SKILL.md) | Editing, validating, and loading USD assets for visionOS |
| [signing-entitlements](skills/signing-entitlements/SKILL.md) | Resolving signing, entitlement, privacy key, and provisioning issues |
| [immersive-media](skills/immersive-media/SKILL.md) | Building immersive media playback, spatial video, and viewing experiences |
| [swiftui-spatial](skills/swiftui-spatial/SKILL.md) | Implementing spatial SwiftUI views, scene types, and visionOS-specific modifiers |

### Engineering Workflow Skills

| Skill | Use When |
|-------|----------|
| [spec-driven-spatial](skills/spec-driven-spatial/SKILL.md) | Starting a new feature - write a spec before writing code |
| [incremental-build](skills/incremental-build/SKILL.md) | Implementing features in thin vertical slices, one component at a time |
| [debugging-triage](skills/debugging-triage/SKILL.md) | Systematic root-cause debugging for visionOS runtime issues |
| [adr-spatial](skills/adr-spatial/SKILL.md) | Recording architectural decisions for scene models, RealityKit choices, ARKit strategies |
| [git-workflow](skills/git-workflow/SKILL.md) | Atomic commits, clean history, visionOS-specific commit discipline |

## Agents

| Agent | Role | Invoke When |
|-------|------|-------------|
| [spatial-architect](agents/spatial-architect.md) | Senior spatial design reviewer | New feature specs, architecture reviews, scene model decisions |
| [realitykit-debugger](agents/realitykit-debugger.md) | RealityKit/ARKit runtime specialist | Build succeeds but runtime behaviour is wrong |
| [xcode-build-agent](agents/xcode-build-agent.md) | Build and CI orchestrator | Build failures, signing issues, distribution tasks |

## Commands

| Command | Purpose |
|---------|---------|
| `/build-and-run-visionos-app` | Build and launch on Apple Vision Pro simulator |
| `/fix-visionos-capability-error` | Diagnose and fix capability, privacy, or signing errors |
| `/test-visionos-app` | Run tests with failure classification |
| `/spec` | Start a feature specification (no code until approved) |
| `/plan` | Break a spec into ordered, verifiable tasks |
| `/review` | Code review across spatial, RealityKit, Swift, and quality axes |
| `/ship` | Pre-launch checklist for TestFlight and App Store readiness |

## Typical Workflow Sequence

```
/spec "feature name"     - Define what we're building
/plan "feature name"     - Break into verifiable slices
  [implement slice]      - Build one component/system at a time
  [verify on simulator]  - Each slice must build and run
/review                  - Review before merge
/ship                    - Pre-launch checklist
```

## XcodeBuildMCP Dependency

This plugin requires XcodeBuildMCP for build, run, and debug workflows. It is declared in `marketplace.json` and will be available as an MCP server when the plugin is installed.

## visionOS 26 Notes

- ARKitSession requires explicit authorization - always check authorization status before starting providers
- Hand tracking runs at 90Hz - code in the render loop must sustain this rate
- Scene types (WindowGroup, ImmersiveSpace) determine the app's spatial presence - choose deliberately
- Privacy entitlements for world sensing, hand tracking, and camera access must be declared in the .entitlements file and Info.plist
