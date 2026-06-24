# RCP3 Script Graph Workflow

Use this file when the task is to author, change, repair, or validate Reality
Composer Pro 3 Script Graph behavior.

## Locate The Owner

Start by finding the `.realitycomposerpro` project that owns the graph:

```bash
find . -name '*.realitycomposerpro' -print
find Path/To/Scene.realitycomposerpro -type f \( -name '*.tm_*' -o -name '*.usda' -o -name '*.json' \) -print
```

In Reality Composer Pro 3, the editable project target is the
`.realitycomposerpro` package. Do not search for or modify `.rkassets` or
`.reality` as the RCP3 project. Treat `RealityKitContent`, `.rkassets`, and
`.reality` as downstream package/runtime artifacts unless the task is explicitly
about build or app-bundle validation.

Then identify the exact authored surface:
- `.realitycomposerpro` project name
- scene or asset name
- entity name or path
- Script Graph name if visible in RCP
- trigger/event that starts the behavior
- action, conditional, state, or entity reference that must change

## Edit Strategy

Prefer Reality Composer Pro UI edits for graph structure. Use package text
inspection or edits only for narrow cases:
- compare before/after graph changes
- recover a small broken reference
- audit node type names and connections
- explain why exported behavior is not loading
- apply a user-requested known-good patch

Before direct package edits:
1. Check `git status --short`.
2. Duplicate the package if it is not tracked by Git.
3. Avoid editing the same package while Reality Composer Pro is actively
   writing it.
4. Make the smallest change and preserve existing identifiers, ordering, and
   file layout.

## Behavior Categories

Use Script Graph when the behavior is authored content:
- tap, hover, timeline, or scene event triggers
- conditional branches and simple state changes
- entity visibility, transforms, audio, animation playback, or scene actions
- behavior that a designer should maintain in Reality Composer Pro
- behavior attached to authored RCP3 project content

Route away from Script Graph when:
- the logic needs per-frame code, broad entity queries, tests, networking, or
  persistent app state
- the task is material shading, particle compute, USD composition, package
  wiring, or SwiftUI layout

## Validation

Use the narrowest validation that proves the graph still loads and behaves:
- reopen the package in Reality Composer Pro
- check the graph opens without editor errors
- verify referenced entities and custom component types still resolve
- rebuild the generated app/runtime artifact or host app
- launch the app and capture logs when the behavior only appears at runtime

If RCP does not reflect direct filesystem edits, close and reopen the package
or reimport through the `.realitycomposerpro` project path. Do not assume
package edits hot-reload.
