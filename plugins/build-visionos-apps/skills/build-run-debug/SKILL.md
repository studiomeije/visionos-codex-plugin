---
name: build-run-debug
description: Build, run, and debug local visionOS 27 apps with first-party Xcode and Apple Vision Pro simulator workflows. Use when asked to discover an Xcode project or scheme, build or launch an app, diagnose compiler, linker, install, startup, or debugger failures, collect basic process logs, or bootstrap a local Run button. Route an already-running RealityKit performance investigation to realitykit-performance-triage.
---

# Build / Run / Debug

## Quick Start

This skill supports two first-party execution paths: `xcode` / `mcpbridge` for
active Xcode session capabilities, and direct shell tools for deterministic
project discovery, build, test, simulator, logging, and debugger work. Detect
the available path first and keep the workflow aligned to that choice.

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/project-discovery.md`](references/project-discovery.md) | When the workspace, project, package, app-producing scheme, bundle id, or runnable target is not already proven. |
| [`references/xcode-mcpbridge-boundary.md`](references/xcode-mcpbridge-boundary.md) | When deciding whether to use the official Xcode MCP bridge or direct shell tools. |
| [`references/shell-workflow.md`](references/shell-workflow.md) | When using direct `xcodebuild`, `simctl`, `log stream`, and LLDB commands. |
| [`references/run-button-bootstrap.md`](references/run-button-bootstrap.md) | When the repo needs a persistent `script/build_and_run.sh` and a Codex Run action. |
| [`references/launch-caveats.md`](references/launch-caveats.md) | When a slow simulator boot, immersive-space expectation, or launch symptom may be misclassified as a build failure. |

## Workflow

1. Detect whether the official Xcode bridge is callable and whether the task
   depends on active Xcode session state.
2. Confirm the real project shape and the app-producing target.
3. Choose the Apple Vision Pro Simulator deliberately.
4. Run the narrowest build, launch, or debug step that can prove or disprove
   the current theory.
5. Bootstrap the project-local run script when a persistent Codex Run button
   or repeatable shell entrypoint is useful.
6. Summarize the exact blocker class and the smallest next action.

## When To Switch Skills

- Switch to `test-triage` when the main task becomes failing tests, flaky test
  behavior, or narrowing XCTest or Swift Testing scope.
- Switch to `signing-entitlements` when the blocker is code signing,
  provisioning, capabilities, privacy usage keys, sandbox denials, or
  entitlement mismatch.
- Switch to `realitykit-performance-triage` when the app runs and the primary
  request is RealityKit profiling, trace analysis, bottleneck isolation, or
  optimization verification.
- Switch to `spatial-app-architecture` when the blocker is structural SwiftUI
  or scene ownership debt rather than a build or runtime execution failure.
- Return to `build-run-debug` after any of those changes to re-run build,
  install, launch, and debugger checks.

## Guardrails

- Prefer the narrowest command that proves or disproves the current theory.
- Detect the available build path before running any build commands.
- Use direct `xcodebuild` and `simctl` for deterministic project discovery,
  simulator selection, build, install, launch, test, and log workflows.
- Use `xcode` / `mcpbridge` when the task depends on an active Xcode session,
  Xcode-owned debugger state, or another capability exposed by the bridge.
- When the Xcode bridge is unavailable or mismatched with the local
  SDK/runtime, use the shell path.
- Do not invent a workspace, project, scheme, package product, or bundle id
  from the repo name; inspect the actual build graph.
- Do not skip deliberate Apple Vision Pro Simulator selection.
- Use the Xcode beta developer directory when the selected Xcode cannot see
  the visionOS 27 SDK or simulator runtime; both ship with Xcode 27 beta.
- Treat missing `x86_64` simulator slices on Apple silicon as an architecture
  selection problem before changing app code.
- Do not write `.codex/environments/environment.toml` before the run script
  exists, and do not point the Run action at a stale script path.
- Do not describe macOS desktop launch patterns as if they apply to a visionOS
  simulator loop.
- If build output is huge, summarize the first real blocker and point to the
  next command that should run.


## Skills In Other Plugins

These routes live in other plugins from this marketplace. If one is not
installed, say so plainly and continue with the best available path rather
than stalling or inventing the missing skill's guidance.

| Skill | Plugin |
|---|---|
| `realitykit-performance-triage` | Profile & Optimize RealityKit |

## Output Expectations

Provide:
- the detected project type and chosen scheme
- whether you used `xcode` / `mcpbridge` or the shell path
- the simulator target selected
- any `DEVELOPER_DIR` or arm64-only override used
- the script path and Run action you configured, if applicable
- the Xcode bridge tool call or shell command you ran
- whether build and launch succeeded
- the top blocker if they failed
- the smallest sensible next action
