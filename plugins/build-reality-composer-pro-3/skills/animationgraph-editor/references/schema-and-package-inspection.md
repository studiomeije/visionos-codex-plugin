# Schema And Package Inspection

Use this file when checking installed Reality Composer Pro 3 Animation Graph
schema handles, package internals, graph files, or component references.

## Installed Schema Handles

Treat the installed Reality Composer Pro app and bundled RealityKit resources
as the current source of truth for local schema handles:

```bash
mdls -name kMDItemVersion -name kMDItemCFBundleIdentifier /Applications/RealityComposerPro.app
test -f /Applications/RealityComposerPro.app/Contents/SystemFrameworks/RealityKit.framework/Versions/A/Resources/AnimationGraphSchema.json
python3 -m json.tool /Applications/RealityComposerPro.app/Contents/SystemFrameworks/RealityKit.framework/Versions/A/Resources/AnimationGraphSchema.json >/dev/null
```

Useful local handles include:
- `RealityKit.framework/.../Resources/AnimationGraphSchema.json`
- `libtm-animation_graph.dylib`
- `tm_re_animation_graph`
- `tm_re_animation_graph_component`
- `tm_re_animation_graph_parameters`
- `tm_re_animation_graph_tags`

Use these as inspection handles only. They do not imply a stable public package
format or a public Swift API for editing authored Animation Graphs at runtime.

## Package Inspection

Reality Composer Pro packages contain private `.tm_*` data. Inspect them to
understand or repair authored content, but do not treat the format as a stable
public API.

Useful search commands:

```bash
find Path/To/Scene.realitycomposerpro -maxdepth 6 -type f -print
rg -n "animation_graph|AnimationGraph|AnimatorGraph|tm_re_animation_graph|animation library|Animation Library|clip|transition|parameter|tag" Path/To/Scene.realitycomposerpro
rg -n "EntityName|GraphName|ClipName|ParameterName" Path/To/Scene.realitycomposerpro
```

When text files are not enough, compare a known-good package change:

```bash
git diff -- Path/To/Scene.realitycomposerpro
find Path/To/Scene.realitycomposerpro -type f -print0 | xargs -0 file
```

If package files are binary or opaque, stop and use Reality Composer Pro UI or
runtime validation instead of guessing a serialization patch.

## Runtime Evidence

For app-runtime issues, inspect the generated RealityKit side without editing
the authored project:
- `AnimationGraphResource.validate(...)` errors
- `AnimationGraphComponent` presence on the expected entity
- graph `parameterNames`
- active nodes, active state-machine nodes, active clip nodes, and active tags
- animation library clip names and resource mappings

Route those checks to `realitykit-animation-physics` once the authored RCP3
project question is answered.
