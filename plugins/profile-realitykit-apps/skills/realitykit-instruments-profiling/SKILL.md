---
name: realitykit-instruments-profiling
description: Capture and inspect reproducible Apple Instruments traces for an already-running RealityKit app. Use when the user names Instruments, xctrace, RealityKit Trace, .trace files, frame pacing, missed frames, Time Profiler, Hangs, System Trace, Swift concurrency, Metal or GPU evidence, Allocations, Leaks, VM growth, asset residency, energy, thermal state, or before-and-after profiling.
---

# RealityKit Instruments Profiling

## Quick Start

1. Confirm the app and scenario through `realitykit-performance-triage`.
2. Discover tools, templates, instruments, and targets from the selected Xcode.
3. Begin with RealityKit Trace for visionOS rendering or responsiveness
   symptoms.
4. Add one narrow follow-up instrument family based on the dominant evidence.
5. Record a bounded capture outside the repository.
6. Inspect the trace or exportable summary before making a claim.
7. Route the measured fix to its implementation owner and repeat a matched
   capture.

## Load References When

| Reference | When to Use |
|---|---|
| [`references/capability-discovery.md`](references/capability-discovery.md) | Discover installed Xcode tools, templates, instruments, and target support. |
| [`references/realitykit-trace.md`](references/realitykit-trace.md) | Use RealityKit Trace to classify frames, render pipeline, runloop, hangs, CPU, GPU, simulation, audio, spatial, or power evidence. |
| [`references/instrument-families.md`](references/instrument-families.md) | Choose targeted CPU/ECS, GPU/rendering, memory/assets, audio, concurrency, or thermal follow-up tools. |
| [`references/trace-artifacts.md`](references/trace-artifacts.md) | Record, inspect, retain, sanitize, and hand off trace artifacts safely. |
| [`references/regression-comparison.md`](references/regression-comparison.md) | Compare matched baseline and candidate captures without overstating noisy results. |

## Guardrails

- Discover availability at runtime; Xcode templates and export schemas drift.
- Prefer an optimized Profile or Release-like build for final performance
  conclusions.
- Do not benchmark with sanitizers, validation layers, verbose logging, or
  screen recording unless their overhead is the subject of the test.
- Treat simulator GPU, thermal, power, tracking, and final frame timing as
  non-authoritative.
- Some traces require manual inspection in Instruments; report that gate rather
  than inventing an automated result.
- Do not commit `.trace`, `.logarchive`, GPU trace, crash, or sysdiagnose
  artifacts.

## Output Expectations

Provide:

- tool capability results and selected template/instruments
- target, build configuration, scenario, and capture duration
- raw artifact path and capture status
- the inspected time range and dominant evidence
- the implementation owner and proposed acceptance metric
- matched before-and-after result or the remaining device gate
