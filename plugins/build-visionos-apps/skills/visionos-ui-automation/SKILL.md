---
name: visionos-ui-automation
description: Drive the Apple Vision Pro simulator from outside the test target for screenshots, video capture, keyboard input, hardware-button presses, and accessibility tree inspection using AXe (github.com/cameroncooke/AXe) on top of XcodeBuildMCP. Use when automating end-to-end flows, capturing visual evidence for PRs or review, or scripting post-launch simulator interactions that do not fit inside an XCTest/Swift Testing target.
---

# visionOS UI Automation (AXe)

This skill wraps AXe, a standalone CLI that drives the Apple Vision Pro
simulator through accessibility and HID input. Use it for screenshots, video,
keyboard-driven flows, accessibility-tree inspection, and scripted
post-launch evidence capture outside the test target.

Use AXe after the app is already built, installed, and launched. It complements
XcodeBuildMCP, XCTest/Swift Testing, and unified logs; it does not replace their
build, launch, test, or telemetry evidence.

On visionOS, AXe is deliberately narrower than on iOS. Coordinate-based touch
and swipe automation are not the right abstraction for spatial UI. Route those
cases to XCUITest or in-app test hooks.

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/axe-preflight-and-boundaries.md`](references/axe-preflight-and-boundaries.md) | When you need AXe preflight, install checks, fallback behavior, or the visionOS support boundary. |
| [`references/axe-commands.md`](references/axe-commands.md) | When choosing concrete AXe commands for capture, keyboard input, hardware buttons, accessibility dumps, or batch steps. |
| [`references/visionos-automation-app-design.md`](references/visionos-automation-app-design.md) | When the app itself needs keyboard shortcuts, focusability, accessibility labels, or simulator-only debug hooks to make AXe reliable. |
| [`references/workflow-recipes.md`](references/workflow-recipes.md) | When you need end-to-end screenshot, video, accessibility, or performance-sweep patterns. |

## Workflow

1. Build and launch the app with `build-run-debug`.
2. Confirm the XcodeBuildMCP or fallback launch output names the intended Apple
   Vision Pro simulator.
3. Run AXe preflight once and resolve the simulator UDID.
4. Choose the capture or interaction path: screenshot, video, keyboard input,
   accessibility dump, or a batched flow.
5. If the task needs spatial gesture automation, stop and route to
   `test-triage` or in-app test hooks.
6. Verify the produced artifact or parsed accessibility output.

## When To Switch Skills

- Switch to `build-run-debug` when the app will not launch, the simulator is
  not booted, or logs must be captured through XcodeBuildMCP.
- Switch to `test-triage` when the work is running XCTest / Swift Testing
  targets or narrowing failing scopes — AXe is not a test harness.
- Switch to `telemetry` when the question is "did the app emit this event?"
  — AXe inspects the UI surface, not the unified-logging stream.
- Switch to `realitykit-visionos-developer` for entity-level manipulation
  test hooks when a test needs to assert spatial gesture state.

## Guardrails

- Do not pretend AXe's `tap`/`swipe`/`gesture` commands drive the visionOS
  spatial UI. They are for iOS simulators and their behavior on visionOS is
  at best undefined.
- Do not treat AXe as a replacement for XCTest/XCUITest. It is a simulator
  automation layer, not an in-process test harness. Use it alongside tests,
  not in place of them.
- Do not commit captured screenshots or videos that contain private account
  data, unreleased assets under NDA, or anything the user has flagged as
  confidential.
- Do not assume `describe-ui` output shape is stable across AXe versions;
  pin the AXe version in CI and regenerate fixtures when upgrading.
- Always verify the target UDID corresponds to an Apple Vision Pro
  simulator before running commands — it is easy to type into the wrong
  booted device and get confusing results.

## Output Expectations

Provide:
- the AXe commands you ran with the resolved simulator UDID
- the artifact paths produced
- whether the captured evidence supports or rejects the current theory
- explicit routing back to `build-run-debug`, `test-triage`, or
  `telemetry` for the next step
