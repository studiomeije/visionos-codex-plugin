# USD Command-Line Tools

Which tool to reach for, and the behavior that is not obvious from `--help`.
**`--help` is the source of truth for flags** - it reflects the installed
version, this page does not. Run `<tool> --help` before composing a command with
options you have not used recently.

## What Ships On macOS

Apple installs a subset in `/usr/bin`:

| Tool | Ships with macOS | Purpose |
|---|---|---|
| `usdcat` | yes | Convert, flatten, or print a stage as text |
| `usdchecker` | yes | Validate a stage or USDZ package |
| `usdtree` | yes | Print the prim hierarchy |
| `usdzip` | yes | Create and inspect USDZ packages |
| `usdrecord` | yes | Render images from a stage |
| `usdedit` | **no** | Round-trip a binary file through a temp `.usda` |
| `usdview`, `usdstitch` | **no** | Full-USD-install tools |

Check availability before recommending a command:

```bash
command -v usdedit || echo "usdedit is not installed"
```

`usdedit`, `usdview`, and `usdstitch` come from a full OpenUSD install, not from
macOS. When `usdedit` is missing, do the round-trip explicitly instead:
`usdcat -o tmp.usda Model.usdc`, edit, then `usdcat -o Model.usdc tmp.usda`.

## Choosing A Tool

- **Inspect structure before editing** - `usdtree` for the hierarchy,
  `usdcat` for the text.
- **Cheap syntax check after a hand edit** - `usdcat --loadOnly Scene.usda`
  reports `OK` or `ERR` per input without composing the whole stage. Run this
  before any heavier validation.
- **See the composed result** - `usdcat --flatten` resolves composition arcs;
  `--flattenLayerStack` flattens only the layer stack and keeps arcs. Use
  `--mask` (requires `--flatten`) to limit population to specific prims on large
  stages.
- **Validate** - `usdchecker`.
- **Package** - `usdzip`.
- **Render a proof image** - `usdrecord`.

## The visionOS Shipping Gate

Two commands decide whether an asset works on Apple Vision Pro:

```bash
usdzip --arkitAsset Model.usda Model.usdz
usdchecker --arkit --strict Model.usdz
```

- `--arkitAsset` gathers dependencies and transforms data to satisfy RealityKit
  packaging requirements. Prefer it over hand-assembling a package.
- `--arkit` applies restrictive rules for distributable consumer content on top
  of the general USD checks; `--strict` turns warnings into a non-zero exit so
  CI can gate on it.
- **Run `usdchecker` even when `usdzip -c` succeeded.** Compliance-on-package and
  the ARKit rule set are not the same checks.

## usdchecker Behavior Worth Knowing

- It only checks the **first sample** of any time-sampled attribute. Animated
  data is effectively unvalidated past frame one.
- `--noAssetChecks` is a diagnostic aid for isolating asset-reference problems,
  never a final-validation flag.
- `--rootPackageOnly` skips nested packages and dependencies - wrong for a final
  USDZ check if either matters at runtime.
- `-d` / `--dumpRules` prints the rule set that would run, which is the fastest
  way to see what `--arkit` actually adds.
- Variants are only validated for the default selections unless you pass
  `--variantSets` or `--variants`.

## usdzip And usdrecord Notes

- `usdzip -l` lists package contents and `-d -` dumps them to stdout - use these
  to confirm what actually landed in a package rather than assuming.
- A USDZ is a zip: standard `unzip` can extract one when you only need the
  contents. Never hand-edit inside a package - unpack, edit the source layer,
  repackage, re-validate.
- Keep root layer and asset paths deterministic. Runtime bundle loading is
  sensitive to package names and case.
- `usdrecord` needs exactly one frame placeholder (`###`) in the output path when
  rendering a range, and `--disableGpu` forces CPU rendering when a GPU path is
  unavailable. Treat a rendered image as evidence for a change, not as proof the
  asset loads correctly in RealityKit - for that, build and run the app.
