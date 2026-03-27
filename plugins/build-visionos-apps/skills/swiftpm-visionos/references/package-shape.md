# Package Shape

Use this file when `Package.swift` is the main artifact under review.

## What To Inspect

- `platforms:` includes `.visionOS(.v2)` or later when the package claims
  visionOS support.
- Products: executable, library, plugin, and test products.
- Targets that declare resources such as `.rkassets`, `.usdz`, or Shader Graph
  material assets.
- Cross-platform conditionals and availability guards.

## Questions To Answer

- Is this package directly runnable, library-only, or app-consumed?
- Which targets actually depend on visionOS APIs?
- Are resources bundled in the package instead of assuming an app-level bundle?
