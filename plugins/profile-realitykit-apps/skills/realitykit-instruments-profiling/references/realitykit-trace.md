# RealityKit Trace

Use RealityKit Trace as the first classification capture for visionOS
rendering, responsiveness, and sustained-runtime symptoms.

## Primary Evidence

| Instrument Area | Questions |
|---|---|
| RealityKit Frames | Which frames approached or missed their recorded deadlines? Are CPU or GPU render rates dominant? |
| RealityKit Metrics | Which module dominates: 3D render, Core Animation render, entity commits, animation, physics, particles, audio, or spatial systems? |
| Runloops | Is app-owned runloop work delaying input or updates? |
| Time Profiler | Which stacks own CPU time in the affected interval? |
| Hangs | Was the main thread unresponsive, and what was it executing? |
| Metal Application | Does Metal-side activity correlate with the frame problem? |
| Thermal State | Does sustained performance change with thermal pressure? |

## Analysis Sequence

1. Mark the scenario start and stop using a log or signpost.
2. Find the same interval in RealityKit Frames and Metrics.
3. Classify CPU, GPU/render-server, simulation, spatial, audio, or power as the
   dominant measured family.
4. Open only the matching detail view or targeted follow-up instrument.
5. Record observations separately from inferred causes.

Do not use a fixed 60 FPS assumption or a universal content budget. Use the
deadlines and rates recorded for the actual device, presentation mode, and
scenario.
