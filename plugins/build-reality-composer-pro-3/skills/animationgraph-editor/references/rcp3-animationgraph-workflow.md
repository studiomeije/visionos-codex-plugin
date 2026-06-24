# RCP3 Animation Graph Workflow

Use this file when the task is to author, change, repair, or validate Reality
Composer Pro 3 Animation Graph or Animator Graph behavior.

## Locate The Owner

Start by finding the `.realitycomposerpro` project that owns the graph:

```bash
find . -name '*.realitycomposerpro' -print
find Path/To/Scene.realitycomposerpro -type f \( -name '*.tm_*' -o -name '*.json' -o -name '*.usda' \) -print
```

In Reality Composer Pro 3, the editable project target is the
`.realitycomposerpro` package. Do not search for or modify `.rkassets` or
`.reality` as the RCP3 project. Treat `RealityKitContent`, `.rkassets`, and
`.reality` as downstream package/runtime artifacts unless the task is
explicitly about build or app-bundle validation.

Then identify the exact authored surface:
- `.realitycomposerpro` project name
- scene or asset name
- entity name or path
- Animation Graph / Animator Graph name
- animation clips and library entries involved
- graph parameters, tags, states, transitions, and blend rules that must change

## Edit Strategy

Prefer Reality Composer Pro UI edits for graph structure. Use package text
inspection or edits only for narrow cases:
- compare before/after graph changes
- recover a small broken clip, graph, or entity reference
- audit graph parameters, state names, transition data, or animation bindings
- explain why authored animation behavior is not loading
- apply a user-requested known-good patch

Before direct package edits:
1. Check `git status --short`.
2. Duplicate the project if it is not tracked by Git.
3. Avoid editing the same project while Reality Composer Pro is actively
   writing it.
4. Make the smallest change and preserve existing identifiers, ordering, and
   file layout.

## Behavior Categories

Use Animation Graph when the behavior is authored animation state:
- idle/walk/run or other state-machine transitions
- clip selection, blends, transition timing, tags, and parameters
- animation graphs attached to entities through authored components
- designer-maintained animation flow inside Reality Composer Pro
- behavior that depends on imported animation clips and RCP3 asset state

Route away from Animation Graph when:
- the graph is only triggered by event/action logic; use `scriptgraph-editor`
- the behavior is runtime-generated, tested Swift code, or multi-entity app
  state; use `realitykit-animation-physics` or `realitykit-ecs-systems`
- the task is material shading, USD composition, package wiring, or SwiftUI
  layout

## Validation

Use the narrowest validation that proves the graph still loads and behaves:
- reopen the project in Reality Composer Pro
- check the graph opens without editor errors
- verify referenced entities, clips, animation library entries, and custom
  component types still resolve
- rebuild the generated app/runtime artifact or host app
- launch the app and capture logs when the behavior only appears at runtime

If RCP does not reflect direct filesystem edits, close and reopen the project
or reimport through the `.realitycomposerpro` project path. Do not assume
package edits hot-reload.
