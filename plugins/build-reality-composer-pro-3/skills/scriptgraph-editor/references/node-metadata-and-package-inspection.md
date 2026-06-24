# Node Metadata And Package Inspection

Use this file when checking installed Reality Composer Pro 3 Script Graph node
names, availability, inputs, outputs, or package internals.

## Installed Node Catalog

Treat the installed Reality Composer Pro app as the current source of truth for
the local node catalog:

```bash
mdls -name kMDItemVersion -name kMDItemCFBundleIdentifier /Applications/RealityComposerPro.app
plutil -p /Applications/RealityComposerPro.app/Contents/Frameworks/MosaicGraphTab.framework/Versions/A/Resources/ScriptGraphNodeMetadata.plist | sed -n '1,160p'
```

The metadata dictionary is keyed by node type name. Useful fields include:
- `typeName`
- `localizedName`
- `defaultNodeLabel`
- `availability`
- `nodeMenuDescription`
- `inputMetaData`
- `outputMetaData`

For targeted searches, use Python rather than relying on a long `plutil`
dump:

```bash
python3 - <<'PY'
import plistlib
from pathlib import Path

path = Path("/Applications/RealityComposerPro.app/Contents/Frameworks/MosaicGraphTab.framework/Versions/A/Resources/ScriptGraphNodeMetadata.plist")
nodes = plistlib.loads(path.read_bytes())
needle = "animation"
for name, meta in sorted(nodes.items()):
    text = " ".join(str(meta.get(k, "")) for k in ("localizedName", "defaultNodeLabel", "nodeMenuDescription"))
    if needle.lower() in text.lower():
        print(name, meta.get("availability"), "-", meta.get("localizedName"))
PY
```

Do not assume node names from memory. Verify the installed catalog before
recommending a concrete node type.

## Package Inspection

Reality Composer Pro packages contain private `.tm_*` data. Inspect them to
understand or repair authored content, but do not treat the format as a stable
public API.

Useful search commands:

```bash
find Path/To/Scene.realitycomposerpro -maxdepth 5 -type f -print
rg -n "ScriptGraph|script|RealityKitScripting|graph|trigger|action" Path/To/Scene.realitycomposerpro
rg -n "EntityName|GraphName|CustomComponentName" Path/To/Scene.realitycomposerpro
```

When text files are not enough, compare a known-good package change:

```bash
git diff -- Path/To/Scene.realitycomposerpro
find Path/To/Scene.realitycomposerpro -type f -print0 | xargs -0 file
```

If package files are binary or opaque, stop and use Reality Composer Pro UI or
runtime validation instead of guessing a serialization patch.

## Local RCP3 Handles

The local Reality Composer Pro 3.0 bundle exposes Script Graph support through:
- `MosaicGraphTab.framework/.../ScriptGraphNodeMetadata.plist`
- `RealityKitScripting.framework`
- `libtm-gameplay_scripting.dylib`

Use these as inspection handles only. They do not imply a public Swift API for
editing Script Graphs at runtime.
