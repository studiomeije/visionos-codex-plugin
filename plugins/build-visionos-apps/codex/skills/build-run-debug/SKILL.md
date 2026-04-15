---
name: build-run-debug
description: Build, run, and debug local visionOS 26 apps with XcodeBuildMCP-backed Apple Vision Pro simulator workflows. Use when asked to build a visionOS app, launch it in Simulator, diagnose compiler or linker failures, inspect simulator launch problems, debug runtime issues in a spatial app, or bootstrap a local Run button fallback.
---

# Build / Run / Debug

## Quick Start

This skill supports two valid execution paths: XcodeBuildMCP and direct shell
tools. Detect the available path first and keep the rest of the workflow
aligned to that choice.

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/mcp-workflow.md`](references/mcp-workflow.md) | When XcodeBuildMCP is available and you need the session, simulator, build, launch, log, or LLDB workflow. |
| [`references/shell-fallback.md`](references/shell-fallback.md) | When XcodeBuildMCP is unavailable, or when you intentionally want direct `xcodebuild`, `simctl`, `log stream`, and LLDB commands. |
| [`references/run-button-bootstrap.md`](references/run-button-bootstrap.md) | When the repo needs a persistent `script/build_and_run.sh` and a Codex Run action. |
| [`references/launch-caveats.md`](references/launch-caveats.md) | When a slow simulator boot, immersive-space expectation, or launch symptom may be misclassified as a build failure. |

## Workflow

1. Detect whether XcodeBuildMCP is callable.
2. Confirm the project shape and the runnable target.
3. Choose the Apple Vision Pro simulator deliberately.
4. Run the narrowest build, launch, or debug step that can prove or disprove
   the current theory.
5. Bootstrap the project-local run script only when the shell path or Run
   button contract requires it.
6. Summarize the exact blocker class and the smallest next action.

## When To Switch Skills

- Switch to `test-triage` when the main task becomes failing tests, flaky test
  behavior, or narrowing XCTest or Swift Testing scope.
- Switch to `signing-entitlements` when the blocker is code signing,
  provisioning, capabilities, privacy usage keys, sandbox denials, or
  entitlement mismatch.
- Switch to `telemetry` when build or launch succeeds but behavior must be
  proven through structured lifecycle logs.
- Switch to `spatial-app-architecture` when the blocker is structural SwiftUI
  or scene ownership debt rather than a build or runtime execution failure.
- Return to `build-run-debug` after any of those changes to re-run build,
  install, launch, and debugger checks.

## Guardrails

- Prefer the narrowest command that proves or disproves the current theory.
- Detect the available build path before running any build commands.
- When XcodeBuildMCP is available, prefer it. When it is not, use the shell
  path without apology.
- Do not skip deliberate simulator selection.
- Do not write `.codex/environments/environment.toml` before the run script
  exists, and do not point the Run action at a stale script path.
- Do not describe macOS desktop launch patterns as if they apply to a visionOS
  simulator loop.
- If build output is huge, summarize the first real blocker and point to the
  next command that should run.

## Output Expectations

Provide:
- the detected project type and chosen scheme
- whether you used XcodeBuildMCP or the shell path
- the simulator target selected
- the script path and Run action you configured, if applicable
- the MCP tool call or shell command you ran
- whether build and launch succeeded
- the top blocker if they failed
- the smallest sensible next action
