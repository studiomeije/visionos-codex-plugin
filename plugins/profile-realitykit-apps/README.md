# Profile & Optimize RealityKit Plugin

This plugin measures and explains RealityKit runtime behavior. It owns
reproduction design, observability, Instruments capture, bottleneck
classification, and before-and-after evidence. It does not own general app
construction or speculative optimization.

## Included Skills

| Skill | Use When |
|---|---|
| `realitykit-performance-triage` | The bottleneck is unknown, the request is broad, or an investigation needs a reproducible baseline and evidence plan. |
| `realitykit-observability` | Runtime event ordering needs Console, unified logging, `Logger`, or `OSSignposter` evidence. |
| `realitykit-instruments-profiling` | The task needs Instruments, `xctrace`, RealityKit Trace, CPU/GPU/memory analysis, or matched performance captures. |

## Ownership Boundary

- Use `build-visionos-apps` to discover, build, install, launch, sign, test, or
  attach a debugger to the app.
- Use `build-realitykit` to implement the measured RealityKit code change.
- Use `build-reality-composer-pro-3` to correct authored graphs, packages,
  shaders, USD, or USDZ assets identified as the source of runtime cost.
- Return here to repeat the same scenario and verify the result.

## Evidence Contract

Every performance conclusion should record:

- source revision and dirty state
- scheme, build configuration, optimization mode, and launch arguments
- Xcode, SDK, operating system, device or simulator, and thermal state
- exact scenario, warm-up policy, capture duration, and selected tool
- raw artifact path and the inspected time range
- observed bottleneck, proposed owner, confidence, and limitations
- matched before-and-after result when claiming improvement

Simulator evidence can validate workflow and instrumentation, but final GPU,
frame-pacing, thermal, power, tracking, and sustained-performance conclusions
require a controlled physical-device run.

## Installation

Install this plugin only through the Studio Meije Codex marketplace:

```bash
codex plugin marketplace add studiomeije/visionos-codex-plugin --ref main
codex plugin add profile-realitykit-apps@visionos-codex-marketplace
```

For local development, replace the GitHub source with the absolute path to this
repository. Do not copy this plugin into a Codex home manually.
