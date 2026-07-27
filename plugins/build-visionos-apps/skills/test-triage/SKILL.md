---
name: test-triage
description: Triage failing visionOS tests across Xcode and simulator workflows, for both XCTest and Swift Testing targets. Use when asked to run visionOS tests, narrow failing scopes, explain assertion or crash failures, or separate product regressions from simulator, privacy, and configuration problems.
---

# Test Triage

## Quick Start

Use this skill to run the smallest meaningful test scope first, classify
failures precisely, and avoid treating every simulator or entitlement issue like
a product bug.

Anchor every classification to the active test API and to concrete evidence -
`xcodebuild test` output, the `.xcresult` bundle, and simulator logs.

If the project cannot build or the app cannot launch on the selected simulator,
switch to `build-run-debug` first, establish a stable run loop, then resume
test triage.

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/harness-detection.md`](references/harness-detection.md) | When identifying XCTest vs Swift Testing targets, or when constructing `-only-testing:` filters. |
| [`references/post-build-verification.md`](references/post-build-verification.md) | When reviewing `xcodebuild test` output, `.xcresult` bundles, or simulator logs after a successful build. |
| [`references/failure-categories.md`](references/failure-categories.md) | When classifying build failures, assertion failures, crashes, flakes, capability gaps, or lifecycle issues. |
| [`references/simulator-capability-limits.md`](references/simulator-capability-limits.md) | When the failing test depends on hardware-backed visionOS capabilities that the simulator may stub or omit. |
| [`references/rerun-strategy.md`](references/rerun-strategy.md) | When deciding how narrowly to rerun and how to summarize confidence. |

## Workflow

1. Confirm the build/run state, scheme, destination, and simulator UDID.
2. Detect the test harness.
3. Run the smallest relevant XCTest or Swift Testing scope.
4. Inspect `xcodebuild` output, result bundles, and simulator logs before
   classifying.
5. Rerun intelligently.
6. Summarize the smallest failing scope, the failure class, and the next rerun
   or fix step.

## When To Switch Skills

- Switch to `build-run-debug` for compile/link failures, simulator boot/install
  failures, launch failures, or crash-debugging workflows.
- Switch to `signing-entitlements` for provisioning, capability, entitlements,
  privacy usage-key, or sandbox denial issues.
- Switch to `realitykit-observability` when RealityKit lifecycle or event
  ordering is the likely cause and proof needs targeted instrumentation.
- Switch to `visionos-ui-automation` when the evidence you need is a
  screenshot, a video, a keyboard-driven flow, or an accessibility-tree dump
  from the running simulator rather than a test assertion. UI automation uses
  XCTest/XCUITest, `xcodebuild`, and `simctl`; it does not
  replace focused test triage.
- Resume `test-triage` after the blocker category is resolved and re-run the
  narrowest failing scope.

## Guardrails

- Distinguish compilation failures from test execution failures.
- Call out when a failure looks like simulator setup, permissions, or immersive-scene bootstrapping rather than product logic.
- Mark likely flakes as such instead of overstating confidence.
- Do not label a failure as a product regression when environment or capability
  evidence is stronger.
- Do not mix XCTest APIs and Swift Testing APIs inside the same test body; use
  the active harness reference for the exact evidence rules.
- Treat a visionOS simulator boot, install, test-host attach, or scene-launch
  failure that occurs before a test body executes as environment or host
  lifecycle evidence until a test assertion proves otherwise.

## Skills In Other Plugins

These routes live in other plugins from this marketplace. If one is not
installed, say so plainly and continue with the best available path rather
than stalling or inventing the missing skill's guidance.

| Skill | Plugin |
|---|---|
| `realitykit-observability` | Profile & Optimize RealityKit |

## Output Expectations

Provide:
- the command used
- the evidence source used for classification
- the smallest failing scope
- the top failure category
- a concise explanation of the likely cause
- the next rerun or fix step
