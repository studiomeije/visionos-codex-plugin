# Evidence Contract

Record this information with every retained capture or optimization report.

| Field | Required Content |
|---|---|
| Source | Commit, dirty state, branch, app binary UUID, matching dSYM when available |
| Build | Workspace/project, scheme, configuration, optimization mode, launch arguments |
| Toolchain | Xcode build, `DEVELOPER_DIR`, SDK and runtime versions |
| Target | Simulator or device, model, OS build, stable anonymized target identifier |
| Scenario | Exact steps, input data, start/stop markers, duration, cold/warm state |
| Environment | Debugger attached, validation layers, logging level, thermal state |
| Capture | Tool and version, template/instruments, options, status, time range |
| Artifacts | Local path, size, hash, sanitization status, matching logs |
| Analysis | Observed bottleneck, inferred cause, confidence, alternative hypotheses |
| Result | Implementation owner, acceptance metric, before/after statistic and variance |

Use precise evidence states:

- **available** — the tool or template exists
- **started** — recording began
- **produced** — an artifact was written
- **inspected** — the relevant trace/log data was actually reviewed
- **verified** — matched evidence supports the claimed change

Never collapse these states into a generic "profiling succeeded."
