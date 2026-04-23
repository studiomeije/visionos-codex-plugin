# Project Discovery

Use this file before building when the runnable target is not already proven
by the user, repo docs, or current session defaults.

## Discovery Order

1. Honor explicit user inputs for workspace, project, scheme, package product,
   destination, and bundle id.
2. Inspect the repo root for `.xcworkspace`, `.xcodeproj`, and `Package.swift`
   entries.
3. Prefer a workspace over the sibling project when the workspace owns the app
   scheme or integrates packages, CocoaPods, generated content, or local
   dependencies.
4. Prefer an app-producing scheme over test bundles, libraries, package-only
   products, asset packages, sample helpers, and tooling targets.
5. If only `Package.swift` exists, switch to `swiftpm-visionos` unless the
   package exposes an executable that is explicitly meant to run on visionOS.

## What To Prove

- The selected workspace or project is the one used by the app entrypoint.
- The scheme builds a `.app` for `visionOS Simulator`, not just a library,
  command-line tool, test bundle, or Reality Composer Pro asset package.
- The destination is an Apple Vision Pro Simulator with a visionOS 26 runtime
  unless the user intentionally names a device or older runtime.
- The bundle identifier comes from build settings or the built app, not from a
  guessed reverse-DNS string.
- A repo-local run script, if present, points at the same workspace or project,
  scheme, destination, and bundle id you would choose manually.

## Shell Checks

Use these only as fallback checks or to explain an MCP discovery result:

```bash
find . -maxdepth 3 \( -name '*.xcworkspace' -o -name '*.xcodeproj' -o -name 'Package.swift' \)
xcodebuild -list -json -workspace <App.xcworkspace>
xcodebuild -list -json -project <App.xcodeproj>
xcodebuild -showBuildSettings -scheme <Scheme> -destination 'platform=visionOS Simulator,name=Apple Vision Pro'
```

For ambiguous repos, summarize why the chosen scheme is the real app path
before running the build.
