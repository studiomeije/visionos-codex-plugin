# Direct Shell Workflow

Use this file for deterministic project discovery, build, test, simulator,
logging, and debugger work through first-party command-line tools.

## Core Tools

- `xcodebuild`
- `xcrun simctl`
- `log stream`
- `lldb`
- project-local `./script/build_and_run.sh` when available

## Developer Directory

Start with the active developer directory. The visionOS 27 SDK and simulator
runtime ship with Xcode 27 beta. If the selected Xcode cannot see a visionOS
27 SDK, point `DEVELOPER_DIR` at
`/Applications/Xcode-beta.app/Contents/Developer`:

```bash
xcode-select -p
xcodebuild -version
xcodebuild -showsdks | grep -i -E 'vision|xros'
```

For a one-off override, prefix the command instead of changing global
`xcode-select` state:

```bash
DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcodebuild -version
```

## Common Operations

| Operation | Command |
|-----------|---------|
| Discover projects | `find . -maxdepth 3 \( -name '*.xcworkspace' -o -name '*.xcodeproj' -o -name 'Package.swift' \)` |
| List schemes | `xcodebuild -list -project <path>` or `-workspace <path>` |
| List simulators | `xcrun simctl list devices available \| grep -i "Apple Vision Pro"` |
| Build | `xcodebuild build -scheme <s> -destination 'platform=visionOS Simulator,name=Apple Vision Pro' -derivedDataPath .build` |
| Build and run | `./script/build_and_run.sh` or explicit build → install → launch |
| Launch with console | `xcrun simctl launch --console <udid> <bundle-id>` |
| Capture logs | `xcrun simctl spawn <udid> log stream --predicate 'subsystem == "<bundle-id>"'` |
| Attach debugger | `lldb -n <process-name>` or `lldb --attach-pid <pid>` |

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
