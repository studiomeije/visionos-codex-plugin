# Package Shape

Use this file when `Package.swift` is the main artifact under review.

## What To Inspect

- `platforms:` includes `.visionOS(.v26)` for visionOS 26-first packages, or a
  documented lower minimum when the repo intentionally supports older systems.
- Products: executable, library, plugin, and test products.
- Targets that declare resources such as `.rkassets`, `.usdz`, or Shader Graph
  material assets.
- Cross-platform conditionals and availability guards.
- Whether the package is standalone, nested under an app workspace, or consumed
  by a host app target.

## Questions To Answer

- Is this package directly runnable, library-only, or app-consumed?
- Which targets actually depend on visionOS APIs?
- Are resources bundled in the package instead of assuming an app-level bundle?
- Does the package need a host app or `build-run-debug` path to prove runtime
  behavior?

## Discovery Notes

Do not treat every `Package.swift` as the app entrypoint. In visionOS repos it
is common to find library packages, generated `RealityKitContent` packages,
asset-pack packages, and the real app workspace in the same checkout.

If a sibling `.xcworkspace` or `.xcodeproj` owns the runnable app, inspect the
package here and return to `build-run-debug` for build, install, launch, logs,
or debugger work.
