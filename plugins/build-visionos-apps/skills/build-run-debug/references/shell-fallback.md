# Shell Fallback

Use this file when XcodeBuildMCP is unavailable or when direct shell control is
the better fit.

## Core Tools

- `xcodebuild`
- `xcrun simctl`
- `log stream`
- `lldb`
- project-local `./script/build_and_run.sh` when available

## Developer Directory Fallback

Start with the active developer directory. Use the beta path only when the
active Xcode does not expose the needed visionOS 26 SDK, simulator runtime, or
Swift language mode:

```bash
xcode-select -p
xcodebuild -version
xcodebuild -showsdks | grep -i -E 'vision|xros'
```

For a one-off fallback, prefix the command instead of changing global
`xcode-select` state:

```bash
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcodebuild -version
```

## Common Equivalents

| MCP tool | Shell equivalent |
|----------|------------------|
| `discover_projs` | `find . -maxdepth 3 \( -name '*.xcworkspace' -o -name '*.xcodeproj' -o -name 'Package.swift' \)` |
| `list_schemes` | `xcodebuild -list -project <path>` or `-workspace <path>` |
| `list_sims` | `xcrun simctl list devices available \| grep -i "Apple Vision Pro"` |
| `build_sim` | `xcodebuild build -scheme <s> -destination 'platform=visionOS Simulator,name=Apple Vision Pro' -derivedDataPath .build` |
| `build_run_sim` | `./script/build_and_run.sh` or manual build → install → launch |
| `launch_app_logs_sim` | `xcrun simctl launch --console <udid> <bundle-id>` |
| sim log capture | `xcrun simctl spawn <udid> log stream --predicate 'subsystem == "<bundle-id>"'` |
| `debug_attach_sim` | `lldb -n <process-name>` or `lldb --attach-pid <pid>` |

## Destination And Architecture

Use the Apple Vision Pro Simulator destination explicitly:

```bash
xcodebuild build \
  -scheme <Scheme> \
  -destination 'platform=visionOS Simulator,name=Apple Vision Pro' \
  -derivedDataPath .build
```

If an Apple silicon simulator build fails because a dependency lacks an
`x86_64` slice, validate the arm64 simulator path before escalating:

```bash
xcodebuild build \
  -scheme <Scheme> \
  -destination 'platform=visionOS Simulator,name=Apple Vision Pro' \
  ARCHS=arm64 ONLY_ACTIVE_ARCH=YES \
  -derivedDataPath .build
```

Keep `ARCHS=arm64 ONLY_ACTIVE_ARCH=YES` scoped to that validation unless the
repo already uses it in its build scripts or project settings.

## Run Script Modes

- `./script/build_and_run.sh`
- `./script/build_and_run.sh --debug`
- `./script/build_and_run.sh --logs`
- `./script/build_and_run.sh --telemetry`
- `./script/build_and_run.sh --verify`
