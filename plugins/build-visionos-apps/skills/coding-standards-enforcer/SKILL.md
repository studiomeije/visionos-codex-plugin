---
name: coding-standards-enforcer
description: Enforce Swift 6.2 coding standards in visionOS 27 code - strict concurrency, actor isolation, Sendable, @MainActor placement, @Observable models, SWIFT_APPROACHABLE_CONCURRENCY, @concurrent functions, and modern Swift APIs. Use whenever Swift source is written, reviewed, refactored, or migrated, including after another skill produces code.
---

# Coding Standards Enforcer

## Quick Start

Use this skill whenever Swift source changes are in scope - including code
another skill just produced - and the question is whether it matches the
repository's concurrency, observation, and modern API standards.

Classify the work first: a Swift 6.2 build-setting / language-mode problem,
a `MainActor` / actor isolation / `Sendable` problem, an Observation
`@Observable` / `@State` / `@Bindable` ownership problem, or a modern API,
style, and safety cleanup.

## Load References When

| Reference | When to Use |
|-----------|-------------|
| [`references/standards-review-map.md`](references/standards-review-map.md) | When you need the review order, routing, and repo-level standards map. |
| [`references/concurrency-guidelines.md`](references/concurrency-guidelines.md) | When the work touches actors, `@MainActor`, `Sendable`, `Task`, `async let`, task groups, or strict concurrency diagnostics. |
| [`references/observation-modeling.md`](references/observation-modeling.md) | When the work touches Observation `@Observable`, `@ObservationIgnored`, SwiftUI `@State`, `@Bindable`, `@Binding`, or typed environment data flow. |
| [`references/modern-swift-apis.md`](references/modern-swift-apis.md) | When the work is about API modernization, Foundation replacements, formatting, string matching, force unwraps, or Swift-native style. |

## Workflow

1. Inspect the changed Swift files and note the primary failure class.
2. Load the narrowest relevant reference file or files.
3. Review in this order: compiler diagnostics and isolation boundaries,
   then ownership and observation model, then API modernization and safety.
4. Apply the minimum change that restores compliance. Fix or flag deviations
   explicitly; do not leave standards violations implied.
5. Rebuild the affected scheme, and rerun the affected test scope if one
   exists. Concurrency and isolation changes are not verified until the
   compiler agrees; route the build through `build-run-debug`.
6. Summarize what was fixed, what was intentionally left alone, and any
   remaining migration debt.

## When To Switch Skills

- Switch to `spatial-app-architecture` when the core problem is scene
  ownership, feature decomposition, or state placement across surfaces.
- Switch to `build-run-debug` when the main blocker is a build failure or a
  runtime issue that still needs reproduction after standards fixes.
- Switch to `test-triage` when the work is primarily about narrowing a failing
  test scope rather than correcting standards violations directly.

## Guardrails

- Do not impose a blanket `@MainActor` policy. The isolation choice has to
  match ownership and runtime behavior.
- In new SwiftUI or visionOS code, do not introduce `ObservableObject`,
  `@StateObject`, or `@ObservedObject` unless the user explicitly states a
  compatibility constraint or the existing architecture cannot yet leave
  Combine-based observation.
- For Observation ownership, load
  [`observation-modeling.md`](references/observation-modeling.md) instead of
  duplicating its `@Observable`, `@State`, and `@Bindable` rules here.
- Do not "fix" concurrency warnings by introducing unnecessary `Task.detached`,
  `DispatchQueue.main.async`, or `@unchecked Sendable`.
- Do not assume Swift 6.2 default actor isolation from memory; inspect project
  build settings when that choice affects the fix.
- Do not modernize APIs mechanically if it changes semantics.

## Output Expectations

Provide:
- the files or symbols reviewed
- which standards category was applied
- the concrete violations fixed or still present
- the validation step used
- the next skill to use if the blocker is no longer a standards question
