# Instrument Families

Choose by symptom and locally available capability, not by a static checklist.

| Symptom | First Follow-Up | What to Inspect | Likely Fix Owner |
|---|---|---|---|
| Main-thread stall or high CPU | Time Profiler, Hangs, System Trace | Hot stacks, blocking work, scheduling, runloop delays | `realitykit-visionos-developer` or app architecture |
| Hot custom systems or task storms | Time Profiler, Swift concurrency tools, System Trace | `System.update`, query cardinality, actor/task contention | `realitykit-ecs-systems` |
| Missed frames or GPU pressure | RealityKit Trace, Game/Metal tools when available | Frame lifetimes, CPU/GPU balance, render passes, resources | `realitykit-rendering-materials` or `shadergraph-editor` |
| Animation, physics, particles, or cloth spike | RealityKit Metrics plus Time Profiler/Metal follow-up | Module timing and affected content tier | `realitykit-animation-physics` |
| Spatial-audio overhead | RealityKit Metrics and Audio System tools when available | Playback lifecycle, server/client cost, acoustics | `realitykit-audio-spatial` |
| Memory growth or load hitch | Allocations, Leaks, VM tools, File Activity, Metal resource tools | Retained entities/resources, churn, residency, I/O | RealityKit loading, rendering, USDKit, or RCP owner |
| Sustained thermal or power degradation | Device RealityKit Trace plus Thermal/Power tools | Thermal transitions, CPU/GPU/power correlation | Dominant measured subsystem |
| Crash, hang, or runtime fault | Crash report, Hangs, logs, focused sanitizer run | Symbolicated failure and last verified lifecycle event | Build/debug or matching implementation skill |

Sanitizers and validation layers produce correctness evidence, not performance
benchmarks. MetricKit on visionOS can contribute diagnostic reports, but it is
not the active RealityKit performance-measurement backbone.
