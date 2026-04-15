# Build visionOS Apps - Claude Code Plugin

## Purpose

This plugin equips Claude Code with the skills, agents, and commands needed to build, debug, and ship visionOS 26 applications for Apple Vision Pro. It combines platform expertise with disciplined engineering workflows.

## XcodeBuildMCP Setup

The plugin depends on XcodeBuildMCP for build, run, and debug workflows. It is declared in `marketplace.json` and activated automatically when the plugin is installed via `claude plugin install build-visionos-apps`.

If XcodeBuildMCP is not available, fall back to direct `xcodebuild` and `simctl` shell commands.

## Skill Map

### Platform Skills (what to build)

- **spatial-architecture** - scene model decisions, app structure, state ownership
- **realitykit** - entities, components, systems, render loop
- **arkit** - sessions, providers, anchors, tracked world
- **shareplay** - group activities, shared immersive presence
- **shader-graph** - Shader Graph materials for RealityKit
- **usd** - USD asset editing, validation, runtime loading
- **signing-entitlements** - signing, entitlements, privacy keys, provisioning
- **immersive-media** - immersive video, spatial video, playback
- **swiftui-spatial** - spatial SwiftUI views, scene types, visionOS modifiers

### Engineering Workflow Skills (how to build)

- **spec-driven-spatial** - write a spec before writing code, gate on scene model decision
- **incremental-build** - thin vertical slices, one component/system at a time
- **debugging-triage** - five-step triage: reproduce, classify, isolate, fix, test
- **adr-spatial** - architecture decision records for spatial decisions
- **git-workflow** - atomic commits, dedicated .xcodeproj and .entitlements commits

## Which Agent for Which Situation

| Situation | Agent |
|-----------|-------|
| Choosing between window, volume, and immersive space | spatial-architect |
| Reviewing a feature spec or architecture proposal | spatial-architect |
| Build succeeds but entities don't appear or behave wrong | realitykit-debugger |
| ARKit session fails or hand tracking is unreliable | realitykit-debugger |
| Build fails with compiler, linker, or signing errors | xcode-build-agent |
| Preparing for TestFlight or App Store submission | xcode-build-agent |
| Entitlement or capability is blocking launch | xcode-build-agent |

## Commands Reference

- `/build-and-run-visionos-app` - build and launch on simulator
- `/fix-visionos-capability-error` - diagnose signing/capability errors
- `/test-visionos-app` - run tests with failure classification
- `/spec` - start a feature specification
- `/plan` - break a spec into ordered tasks
- `/review` - multi-axis code review
- `/ship` - pre-launch checklist

## visionOS 26 Key Notes

- **ARKitSession** requires explicit authorization. Always check `ARKitSession.AuthorizationStatus` before starting providers. Authorization can be revoked at any time.
- **Hand tracking at 90Hz** - the render loop must sustain 90fps. Avoid allocations, heavy computation, or blocking calls in `update()` methods of RealityKit systems.
- **Scene types** determine spatial presence. `WindowGroup` for flat UI, `ImmersiveSpace` for placed-in-world content. Choose the scene type before writing UI code.
- **Privacy entitlements** for world sensing (`com.apple.developer.arkit.main-camera-access`), hand tracking (`com.apple.developer.arkit.hand-tracking`), and other visionOS capabilities must be declared in both the .entitlements file and Info.plist.
- **Simulator vs device** behaviour differs for signing, ARKit provider availability, and performance characteristics. Always specify which target you're building for.
