---
name: realitykit-observability
description: Instrument and inspect an already-running RealityKit app with Logger, OSLog, OSSignposter, Console, and bounded log predicates. Use for RealityKit lifecycle ordering, missing or duplicated entity and system events, asset-loading spans, immersive transitions, runtime warnings, signpost design, and correlating app-owned work with an Instruments capture. If the app cannot build, install, or launch, use build-run-debug.
---

# RealityKit Observability

## Quick Start

1. Define the runtime question before adding instrumentation.
2. Use stable subsystem/category pairs and a small RealityKit event vocabulary.
3. Log boundaries and failures; signpost bounded operations.
4. Build and launch through `build-run-debug`.
5. Capture with narrow process, subsystem, category, and time predicates.
6. Verify that the expected event sequence fired, then remove or demote noisy
   temporary instrumentation.

## Load References When

| Reference | When to Use |
|---|---|
| [`references/runtime-logging.md`](references/runtime-logging.md) | Add privacy-safe structured `Logger` or `OSLog` events. |
| [`references/signposts-instruments.md`](references/signposts-instruments.md) | Add `OSSignposter` spans and correlate them with Instruments. |
| [`references/runtime-verification.md`](references/runtime-verification.md) | Prove the expected logs or signposts fired in the selected runtime path. |
| [`references/realitykit-event-schema.md`](references/realitykit-event-schema.md) | Choose consistent RealityKit categories, interval names, identifiers, and event boundaries. |

## Guardrails

- Never log credentials, personal data, raw spatial maps, camera frames, hand
  data, or world-sensing payloads.
- Do not log every frame or every entity mutation.
- Do not use `print` as the primary evidence mechanism.
- Do not claim a performance improvement from signpost duration alone when the
  broader trace or target conditions differ.
- Keep `.logarchive` and related captures outside source control.

## Output Expectations

Provide:

- the runtime question and event schema
- the added log or signpost boundaries
- the exact capture predicate and target
- the observed sequence and relevant timestamps
- the matching trace time range, when applicable
- the remaining uncertainty or next profiler
