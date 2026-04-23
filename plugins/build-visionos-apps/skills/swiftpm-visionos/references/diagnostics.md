# Diagnostics

Use this file when the build or test result needs classification.

## Failure Classes

- Platform-condition mismatch
- Missing or downgraded `.visionOS(.v26)` when the package is meant to be
  visionOS 26-first
- Active Xcode cannot see the required visionOS SDK or simulator runtime
- Apple silicon simulator build selected `x86_64` when dependencies only ship
  arm64 simulator slices
- Module or import resolution failure
- Package graph or dependency issue
- Resource bundling issue
- Linker failure
- Runtime-only failure that should route back to simulator or device workflows
- Package is library-only or asset-only, so there is no app bundle to launch

Summarize the failure by class before switching skills.
