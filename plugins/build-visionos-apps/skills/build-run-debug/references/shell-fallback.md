# Shell Fallback

Use this file when XcodeBuildMCP is unavailable or when direct shell control is
the better fit.

## Core Tools

- `xcodebuild`
- `xcrun simctl`
- `log stream`
- `lldb`
- project-local `./script/build_and_run.sh` when available

## Common Equivalents

| MCP tool | Shell equivalent |
|----------|------------------|
| `discover_projs` | `find . -name '*.xcodeproj' -o -name '*.xcworkspace' -o -name 'Package.swift'` |
| `list_schemes` | `xcodebuild -list -project <path>` or `-workspace <path>` |
| `list_sims` | `xcrun simctl list devices available \| grep -i "Apple Vision Pro"` |
| `build_sim` | `xcodebuild build -scheme <s> -destination 'platform=visionOS Simulator,name=Apple Vision Pro' -derivedDataPath .build` |
| `build_run_sim` | `./script/build_and_run.sh` or manual build → install → launch |
| `launch_app_logs_sim` | `xcrun simctl launch --console <udid> <bundle-id>` |
| sim log capture | `xcrun simctl spawn <udid> log stream --predicate 'subsystem == "<bundle-id>"'` |
| `debug_attach_sim` | `lldb -n <process-name>` or `lldb --attach-pid <pid>` |

## Run Script Modes

- `./script/build_and_run.sh`
- `./script/build_and_run.sh --debug`
- `./script/build_and_run.sh --logs`
- `./script/build_and_run.sh --telemetry`
- `./script/build_and_run.sh --verify`
