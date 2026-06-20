---
name: visionos-ui-automation
description: Automate Apple Vision Pro simulator validation with XCTest/XCUITest, XcodeBuildMCP or xcodebuild, simctl capture/control, and app-designed debug hooks for spatial flows. Use when validating launched UI flows, accessibility behavior, screenshots, video evidence, simulator settings, or deterministic spatial automation.
---

# visionOS UI Automation

This skill uses first-party and local automation paths for visionOS UI work.
Prefer XCTest/XCUITest for UI flows and accessibility assertions,
XcodeBuildMCP or `xcodebuild` for build/launch/test execution, `xcrun simctl`
for simulator screenshots, video, display/UI settings, URL opens, pasteboard,
and locally supported hardware-button or HID-style operations, app-designed
debug hooks for spatial gestures.

On visionOS, coordinate-based host-side taps and swipes are not the right
abstraction for spatial UI. Route those cases to XCUITest-accessible controls,
explicit launch arguments, URL schemes, or debug-only app hooks that exercise
the same application state path.

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/official-tooling-boundaries.md`](references/official-tooling-boundaries.md) | When choosing the automation path, checking local tooling, or deciding what cannot be automated from the host. |
| [`references/xctest-xcuitest-flows.md`](references/xctest-xcuitest-flows.md) | When implementing or running repeatable UI flows, accessibility assertions, and test-owned screenshots. |
| [`references/simctl-capture-and-control.md`](references/simctl-capture-and-control.md) | When capturing simulator screenshots/video, changing simulator UI settings, opening URLs, seeding pasteboard data, relaunching with flags, or checking local button/HID support. |
| [`references/visionos-automation-app-design.md`](references/visionos-automation-app-design.md) | When the app itself needs accessibility identifiers, labels, focusability, launch flags, URL hooks, or simulator-only debug controls. |
| [`references/workflow-recipes.md`](references/workflow-recipes.md) | When you need end-to-end screenshot, video, accessibility, spatial-sweep, or simulator-settings patterns. |

## Workflow

1. Choose the owner for the proof: XCUITest assertion, simulator artifact,
   app debug hook, or unified log.
2. Build, install, launch, or test with XcodeBuildMCP first. Use `xcodebuild`
   and `xcrun simctl` as the shell fallback.
3. Confirm the selected Apple Vision Pro simulator destination or UDID matches
   the build/run evidence.
4. For UI flows and accessibility, run the smallest relevant XCTest/XCUITest
   scope and capture result bundles or test attachments.
5. For visual evidence around an already launched app, use `xcrun simctl io`
   screenshots or video with the resolved UDID.
6. For spatial gestures or immersive state, use explicit app-designed hooks and
   pair the visual artifact with XCUITest assertions or telemetry.
7. Verify the artifact, assertion result, or log output before claiming the
   evidence supports the theory.

## When To Switch Skills

- Switch to `build-run-debug` when the app will not launch, the simulator is
  not booted, or logs must be captured through XcodeBuildMCP.
- Switch to `test-triage` when a test target fails or you need to narrow a
  failing XCTest, XCUITest, or Swift Testing scope.
- Switch to `telemetry` when the question is "did the app emit this event?"
  - UI automation artifacts do not replace unified-log proof.
- Switch to `realitykit-visionos-developer` for entity-level manipulation
  test hooks when a test needs to assert spatial gesture state.

## Guardrails

- Do not use host-side coordinate taps, swipes, or gestures as proof of
  visionOS spatial interaction behavior.
- Do not replace XCTest/XCUITest assertions with screenshots when the behavior
  can be asserted in the test runner.
- Do not commit captured screenshots or videos that contain private account
  data, unreleased assets under NDA, or anything the user has flagged as
  confidential.
- Do not assume a `simctl` subcommand exists across Xcode releases. Check local
  `xcrun simctl help` output and document the fallback when the operation is
  unavailable.
- Always verify the target UDID corresponds to an Apple Vision Pro simulator
  before running commands. It is easy to capture or relaunch the wrong booted
  device and get misleading evidence.

## Output Expectations

Provide:
- the runner or command path used: XcodeBuildMCP, `xcodebuild`, `xcrun simctl`,
  XCUITest, or app debug hook
- the simulator destination or resolved UDID
- the focused test scope, launch arguments, URL hook, or simulator command
- artifact paths produced: screenshots, videos, result bundles, or logs
- whether the captured evidence supports or rejects the current theory
- explicit routing back to `build-run-debug`, `test-triage`, or
  `telemetry` for the next step
