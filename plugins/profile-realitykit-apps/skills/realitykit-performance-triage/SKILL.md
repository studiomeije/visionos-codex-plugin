---
name: realitykit-performance-triage
description: Diagnose broad or unknown RealityKit performance problems by defining a reproducible scenario, evidence level, baseline, capture plan, bottleneck hypothesis, implementation owner, and matched verification run. Use for optimize, profile, slow, stutter, dropped frames, high CPU or GPU, memory growth, thermal degradation, or performance-regression requests when the dominant subsystem is not yet proven.
---

# RealityKit Performance Triage

## Quick Start

1. Confirm the app already builds and launches. Otherwise route to
   `build-run-debug`.
2. Define one deterministic scenario and one reader-visible acceptance metric.
3. Record the build, target, device/runtime, warm-up policy, and evidence level.
4. Start with the smallest capture that can classify the bottleneck.
5. Route observability work to `realitykit-observability` and trace work to
   `realitykit-instruments-profiling`.
6. Route the measured fix to its implementation owner, then repeat the same
   capture.

## Load References When

| Reference | When to Use |
|---|---|
| [`references/investigation-workflow.md`](references/investigation-workflow.md) | Build an end-to-end reproduce, capture, diagnose, fix, and remeasure loop. |
| [`references/evidence-contract.md`](references/evidence-contract.md) | Record provenance, artifacts, confidence, and before-and-after comparability. |
| [`references/device-vs-simulator.md`](references/device-vs-simulator.md) | Decide what simulator evidence can prove and when physical Vision Pro evidence is required. |

## Routing

- Build, install, launch, signing, debugger, and startup failures:
  `build-run-debug`.
- Logger, unified logs, signposts, or event correlation:
  `realitykit-observability`.
- RealityKit Trace, `xctrace`, CPU, GPU, Metal, memory, energy, or thermal
  capture: `realitykit-instruments-profiling`.
- Runtime implementation changes: the matching `build-realitykit` skill.
- Authored shader, graph, package, USD, or USDZ changes: the matching Reality
  Composer Pro 3 skill.

## Guardrails

- Do not optimize from source inspection alone.
- Do not make a device-performance claim from simulator timing.
- Do not compare captures with different devices, configurations, scenarios,
  warm-up states, or Instruments overhead without disclosing the mismatch.
- Do not encode universal entity, draw-call, vertex, or frame-time limits.
  Derive budgets from the product target and matched measurements.
- Change one major variable at a time.

## Skills In Other Plugins

These routes live in other plugins from this marketplace. If one is not
installed, say so plainly and continue with the best available path rather
than stalling or inventing the missing skill's guidance.

| Skill | Plugin |
|---|---|
| `build-run-debug` | Build visionOS 27 apps |

## Output Expectations

Provide:

- the reproduction and acceptance metric
- the evidence level and capture plan
- the artifact and inspected time range
- the measured bottleneck and confidence
- the implementation owner
- the matched verification plan or result
