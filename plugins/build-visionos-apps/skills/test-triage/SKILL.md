---
name: test-triage
description: Triage failing visionOS tests across Xcode and simulator workflows, for both XCTest and Swift Testing targets. Use when asked to run visionOS tests, narrow failing scopes, explain assertion or crash failures, or separate product regressions from simulator, privacy, and configuration problems.
---

# Test Triage

## Quick Start

Use this skill to run the smallest meaningful test scope first, classify
failures precisely, and avoid treating every simulator or entitlement issue like
a product bug.

If the project cannot build or the app cannot launch on the selected simulator,
switch to `build-run-debug` first, establish a stable run loop, then resume
test triage.

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/harness-detection.md`](references/harness-detection.md) | When identifying XCTest vs Swift Testing targets, or when constructing `-only-testing:` filters. |
| [`references/failure-categories.md`](references/failure-categories.md) | When classifying build failures, assertion failures, crashes, flakes, capability gaps, or lifecycle issues. |
| [`references/simulator-capability-limits.md`](references/simulator-capability-limits.md) | When the failing test depends on hardware-backed visionOS capabilities that the simulator may stub or omit. |
| [`references/rerun-strategy.md`](references/rerun-strategy.md) | When deciding how narrowly to rerun and how to summarize confidence. |

## Workflow

1. Detect the test harness.
2. Narrow the scope.
3. Classify the result.
4. Rerun intelligently.
5. Summarize the smallest failing scope, the failure class, and the next rerun
   or fix step.

## When To Switch Skills

- Switch to `build-run-debug` for compile/link failures, simulator boot/install
  failures, launch failures, or crash-debugging workflows.
- Switch to `signing-entitlements` for provisioning, capability, entitlements,
  privacy usage-key, or sandbox denial issues.
- Switch to `telemetry` when lifecycle/event ordering is the likely cause and
  proof needs targeted runtime instrumentation.
- Switch to `visionos-ui-automation` when the evidence you need is a
  screenshot, a video, a keyboard-driven flow, or an accessibility-tree dump
  from the running simulator rather than a test assertion. AXe complements
  XCTest/Swift Testing; it does not replace them.
- Resume `test-triage` after the blocker category is resolved and re-run the
  narrowest failing scope.

## Guardrails

- Distinguish compilation failures from test execution failures.
- Call out when a failure looks like simulator setup, permissions, or immersive-scene bootstrapping rather than product logic.
- Mark likely flakes as such instead of overstating confidence.
- Do not label a failure as a product regression when environment or capability
  evidence is stronger.

## Output Expectations

Provide:
- the command used
- the smallest failing scope
- the top failure category
- a concise explanation of the likely cause
- the next rerun or fix step
