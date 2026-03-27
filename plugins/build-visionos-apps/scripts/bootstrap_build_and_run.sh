#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF' >&2
Usage:
  bootstrap_build_and_run.sh (--project path.xcodeproj | --workspace path.xcworkspace) --scheme Scheme [options]

Options:
  --project PATH          Xcode project to target
  --workspace PATH        Xcode workspace to target
  --scheme NAME           Scheme name to build and launch
  --project-root PATH     Root directory where script/build_and_run.sh should be written
  --app-name NAME         App display/binary name (defaults to scheme)
  --bundle-id ID          Bundle identifier override for simctl launch and telemetry
  --simulator-name NAME   Simulator device name (default: Apple Vision Pro)
  --configuration NAME    Xcode build configuration (default: Debug)
  --derived-data PATH     Project-relative DerivedData path (default: .codex/build/DerivedData)
  --overwrite             Replace existing generated files

Result:
  Writes:
    script/build_and_run.sh
    .codex/environments/environment.toml
EOF
  exit 2
}

relative_path() {
  python3 - "$1" "$2" <<'PY'
import os
import sys

print(os.path.relpath(sys.argv[1], sys.argv[2]))
PY
}

project=""
workspace=""
scheme=""
project_root=""
app_name=""
bundle_id=""
simulator_name="${SIMULATOR_NAME:-Apple Vision Pro}"
configuration="${CONFIGURATION:-Debug}"
derived_data_rel=".codex/build/DerivedData"
overwrite=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      project="${2:-}"
      shift 2
      ;;
    --workspace)
      workspace="${2:-}"
      shift 2
      ;;
    --scheme)
      scheme="${2:-}"
      shift 2
      ;;
    --project-root)
      project_root="${2:-}"
      shift 2
      ;;
    --app-name)
      app_name="${2:-}"
      shift 2
      ;;
    --bundle-id)
      bundle_id="${2:-}"
      shift 2
      ;;
    --simulator-name)
      simulator_name="${2:-}"
      shift 2
      ;;
    --configuration)
      configuration="${2:-}"
      shift 2
      ;;
    --derived-data)
      derived_data_rel="${2:-}"
      shift 2
      ;;
    --overwrite)
      overwrite=1
      shift
      ;;
    *)
      usage
      ;;
  esac
done

if [[ -z "$scheme" ]]; then
  usage
fi

if [[ -n "$project" && -n "$workspace" ]]; then
  echo "Pass either --project or --workspace, not both." >&2
  exit 2
fi

if [[ -z "$project" && -z "$workspace" ]]; then
  usage
fi

project_kind="project"
source_path="$project"
if [[ -n "$workspace" ]]; then
  project_kind="workspace"
  source_path="$workspace"
fi

if [[ -z "$project_root" ]]; then
  project_root="$(dirname "$source_path")"
fi

project_root="$(cd "$project_root" && pwd)"
source_abs="$(cd "$(dirname "$source_path")" && pwd)/$(basename "$source_path")"
project_rel="$(relative_path "$source_abs" "$project_root")"

if [[ -z "$app_name" ]]; then
  app_name="$scheme"
fi

build_script_path="$project_root/script/build_and_run.sh"
environment_path="$project_root/.codex/environments/environment.toml"

if [[ $overwrite -ne 1 ]]; then
  if [[ -e "$build_script_path" || -e "$environment_path" ]]; then
    echo "Generated files already exist. Re-run with --overwrite to replace them." >&2
    exit 2
  fi
fi

mkdir -p "$(dirname "$build_script_path")" "$(dirname "$environment_path")"

printf -v project_kind_q '%q' "$project_kind"
printf -v project_rel_q '%q' "$project_rel"
printf -v scheme_q '%q' "$scheme"
printf -v app_name_q '%q' "$app_name"
printf -v bundle_id_q '%q' "$bundle_id"
printf -v simulator_name_q '%q' "$simulator_name"
printf -v configuration_q '%q' "$configuration"
printf -v derived_data_rel_q '%q' "$derived_data_rel"

cat >"$build_script_path" <<EOF
#!/usr/bin/env bash
set -euo pipefail

MODE="\${1:-run}"
ROOT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_KIND=$project_kind_q
PROJECT_PATH_REL=$project_rel_q
SCHEME=$scheme_q
APP_NAME=$app_name_q
DEFAULT_BUNDLE_ID=$bundle_id_q
DEFAULT_SIMULATOR_NAME=$simulator_name_q
CONFIGURATION=$configuration_q
DERIVED_DATA_REL=$derived_data_rel_q

PROJECT_PATH="\$ROOT_DIR/\$PROJECT_PATH_REL"
DERIVED_DATA_PATH="\$ROOT_DIR/\$DERIVED_DATA_REL"
SIMULATOR_NAME="\${SIMULATOR_NAME:-\$DEFAULT_SIMULATOR_NAME}"
BUNDLE_ID="\${BUNDLE_ID:-\$DEFAULT_BUNDLE_ID}"

resolve_device_udid() {
  python3 - "\$SIMULATOR_NAME" <<'PY'
import json
import subprocess
import sys

simulator_name = sys.argv[1]
data = json.loads(
    subprocess.check_output(["xcrun", "simctl", "list", "devices", "available", "-j"])
)

candidates = []
for runtime, devices in data.get("devices", {}).items():
    if "visionOS" not in runtime and "xrOS" not in runtime:
        continue
    for device in devices:
        if not device.get("isAvailable", True):
            continue
        score = (
            0 if device.get("state") == "Booted" else 1,
            0 if device.get("name") == simulator_name else 1,
            device.get("name", ""),
            device.get("udid", ""),
        )
        candidates.append((score, device.get("udid", "")))

if not candidates:
    sys.exit("No available visionOS simulator device was found.")

candidates.sort(key=lambda item: item[0])
print(candidates[0][1], end="")
PY
}

ensure_device_booted() {
  local udid="\$1"
  xcrun simctl boot "\$udid" >/dev/null 2>&1 || true
  xcrun simctl bootstatus "\$udid" -b >/dev/null
}

resolve_project_flags() {
  if [[ "\$PROJECT_KIND" == "project" ]]; then
    printf '%s\n' -project "\$PROJECT_PATH"
  else
    printf '%s\n' -workspace "\$PROJECT_PATH"
  fi
}

build_app() {
  local udid="\$1"
  mapfile -t project_flags < <(resolve_project_flags)
  xcodebuild "\${project_flags[@]}" \
    -scheme "\$SCHEME" \
    -configuration "\$CONFIGURATION" \
    -sdk xrsimulator \
    -destination "id=\$udid" \
    -derivedDataPath "\$DERIVED_DATA_PATH" \
    build
}

resolve_app_bundle() {
  local bundle=""
  bundle="\$(find "\$DERIVED_DATA_PATH/Build/Products" -type d -path '*-xrsimulator/*.app' -name "\$APP_NAME.app" | sort | head -n 1)"
  if [[ -z "\$bundle" ]]; then
    bundle="\$(find "\$DERIVED_DATA_PATH/Build/Products" -type d -path '*-xrsimulator/*.app' -name '*.app' | sort | head -n 1)"
  fi

  if [[ -z "\$bundle" ]]; then
    echo "Unable to find a built .app bundle under \$DERIVED_DATA_PATH/Build/Products" >&2
    exit 1
  fi

  printf '%s\n' "\$bundle"
}

resolve_bundle_id() {
  local app_bundle="\$1"
  if [[ -n "\$BUNDLE_ID" ]]; then
    printf '%s\n' "\$BUNDLE_ID"
    return
  fi

  /usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "\$app_bundle/Info.plist"
}

install_app() {
  local udid="\$1"
  local app_bundle="\$2"
  xcrun simctl install "\$udid" "\$app_bundle" >/dev/null
}

terminate_existing() {
  local udid="\$1"
  local resolved_bundle_id="\$2"
  xcrun simctl terminate "\$udid" "\$resolved_bundle_id" >/dev/null 2>&1 || true
}

launch_and_print() {
  local udid="\$1"
  local resolved_bundle_id="\$2"
  xcrun simctl launch "\$udid" "\$resolved_bundle_id"
}

main() {
  local udid app_bundle resolved_bundle_id launch_output
  udid="\$(resolve_device_udid)"
  ensure_device_booted "\$udid"
  build_app "\$udid"
  app_bundle="\$(resolve_app_bundle)"
  resolved_bundle_id="\$(resolve_bundle_id "\$app_bundle")"
  install_app "\$udid" "\$app_bundle"
  terminate_existing "\$udid" "\$resolved_bundle_id"

  case "\$MODE" in
    run)
      launch_and_print "\$udid" "\$resolved_bundle_id"
      ;;
    --debug|debug)
      xcrun simctl launch --wait-for-debugger "\$udid" "\$resolved_bundle_id"
      ;;
    --logs|logs)
      xcrun simctl launch --console-pty "\$udid" "\$resolved_bundle_id"
      ;;
    --telemetry|telemetry)
      launch_and_print "\$udid" "\$resolved_bundle_id" >/dev/null
      /usr/bin/log stream --info --style compact --predicate "subsystem == \"\$resolved_bundle_id\""
      ;;
    --verify|verify)
      launch_output="\$(launch_and_print "\$udid" "\$resolved_bundle_id")"
      printf '%s\n' "\$launch_output"
      grep -Eq ': [0-9]+$' <<<"\$launch_output"
      ;;
    *)
      echo "usage: \$0 [run|--debug|--logs|--telemetry|--verify]" >&2
      exit 2
      ;;
  esac
}

main "\$@"
EOF

chmod +x "$build_script_path"

cat >"$environment_path" <<EOF
# THIS IS AUTOGENERATED. DO NOT EDIT MANUALLY
version = 1
name = "$(basename "$project_root")"

[setup]
script = ""

[[actions]]
name = "Run"
icon = "run"
command = "./script/build_and_run.sh"
EOF

printf 'Generated %s\n' "$build_script_path"
printf 'Generated %s\n' "$environment_path"
