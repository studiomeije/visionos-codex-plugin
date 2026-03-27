---
name: telemetry
description: Add lightweight runtime telemetry and debug instrumentation to visionOS apps, then verify those events after building and running. Use when wiring `Logger` / `OSLog`, adding log points for windows, immersive spaces, SharePlay flows, or RealityKit lifecycle events, or confirming those events after a local run.
---

# Telemetry

## Quick Start

Use this skill to add lightweight app instrumentation that helps debug behavior
without turning a spatial app into a logging landfill. Prefer Apple's unified
logging APIs and verify the events after an XcodeBuildMCP-backed build/run
loop, with the shell run script used only as a fallback.

Treat telemetry as a loop:
instrument -> run or observe -> decide -> tighten or remove.

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/logging.md`](references/logging.md) | When you need `Logger` categories, log-level guidance, or example instrumentation patterns. |
| [`references/signposts-instruments.md`](references/signposts-instruments.md) | When timing spans, Instruments, RealityKit budgets, or `sample` fallback are relevant. |
| [`references/verification.md`](references/verification.md) | When you need the concrete build-run-log verification loop, log streaming commands, or cleanup checklist. |

## Workflow

1. Identify the behavior that needs observability.
2. Add the smallest useful instrumentation.
3. Build and run the app.
4. Read runtime logs and verify the event fired.
5. Tighten or remove instrumentation.
6. Summarize what was observed and what should stay in the codebase.

## When To Switch Skills

- Switch to `build-run-debug` when build, install, launch, simulator, or LLDB
  debugging becomes the main blocker.
- Switch to `spatial-app-architecture` when telemetry shows a structural
  ownership problem in scene composition, state placement, or lifecycle
  boundaries.
- Switch to `signing-entitlements` when telemetry or launch output indicates
  capability, entitlement, privacy-key, or sandbox-denial configuration issues.
- Return to `telemetry` after fixes to confirm the corrected lifecycle path with
  a minimal high-signal log set.

## Guardrails

- Do not use `print` as the primary telemetry mechanism for a visionOS app.
- Do not leave a dense trail of permanent debug logs around every state mutation.
- Do not claim an event is wired correctly until you have a concrete verification path through `log stream`, captured launch output, or another observable signal.
- If the debugging task is mostly about crash/backtrace analysis rather than action telemetry, switch to `build-run-debug`.
- If telemetry indicates configuration denial instead of logic failure, route to
  `signing-entitlements` instead of expanding logs indefinitely.

## Output Expectations

Provide:
- the behavior instrumented
- which reference tracks were used
- the verification path
- what the logs or traces proved or disproved
- the cleanup or follow-up step
