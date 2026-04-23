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

if [[ "$derived_data_rel" == /* ]]; then
  echo "--derived-data must be project-relative." >&2
  exit 2
fi

project_kind="project"
source_path="$project"
if [[ -n "$workspace" ]]; then
  project_kind="workspace"
  source_path="$workspace"
fi

if [[ ! -e "$source_path" ]]; then
  echo "Source path does not exist: $source_path" >&2
  exit 2
fi

if [[ -z "$project_root" ]]; then
  project_root="$(dirname "$source_path")"
fi

if [[ ! -d "$project_root" ]]; then
  echo "Project root does not exist: $project_root" >&2
  exit 2
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

SIMULATOR_NAME="\${SIMULATOR_NAME:-\$DEFAULT_SIMULATOR_NAME}"
BUNDLE_ID="\${BUNDLE_ID:-\$DEFAULT_BUNDLE_ID}"

resolve_under_root() {
  case "\$1" in
    /*) printf '%s\n' "\$1" ;;
    *) printf '%s\n' "\$ROOT_DIR/\$1" ;;
  esac
}

PROJECT_PATH="\$(resolve_under_root "\$PROJECT_PATH_REL")"
DERIVED_DATA_PATH="\$(resolve_under_root "\$DERIVED_DATA_REL")"

require_command() {
  if ! command -v "\$1" >/dev/null 2>&1; then
    echo "Required command not found: \$1" >&2
    exit 1
  fi
}

check_prerequisites() {
  require_command xcodebuild
  require_command xcrun
  require_command python3

  if [[ ! -e "\$PROJECT_PATH" ]]; then
    echo "Project path does not exist: \$PROJECT_PATH" >&2
    exit 1
  fi
}

resolve_device_udid() {
  python3 - "\$SIMULATOR_NAME" <<'PY'
import json
import re
import subprocess
import sys

simulator_name = sys.argv[1]
data = json.loads(
    subprocess.check_output(["xcrun", "simctl", "list", "devices", "available", "-j"])
)

def runtime_version_key(runtime):
    numbers = [int(part) for part in re.findall(r"\d+", runtime)]
    padded = (numbers + [0, 0, 0])[:3]
    return tuple(-number for number in padded)

candidates = []
available_names = set()
for runtime, devices in data.get("devices", {}).items():
    if "visionOS" not in runtime and "xrOS" not in runtime:
        continue
    for device in devices:
        if not device.get("isAvailable", True):
            continue
        name = device.get("name", "")
        available_names.add(name)
        if name != simulator_name:
            continue
        score = (
            0 if device.get("state") == "Booted" else 1,
            runtime_version_key(runtime),
            device.get("udid", ""),
        )
        candidates.append((score, device.get("udid", "")))

if not candidates:
    names = ", ".join(sorted(name for name in available_names if name)) or "none"
    sys.exit(
        f"No available visionOS simulator named {simulator_name!r} was found. "
        f"Available visionOS devices: {names}"
    )

candidates.sort(key=lambda item: item[0])
print(candidates[0][1], end="")
PY
}

ensure_device_booted() {
  local udid="\$1"
  xcrun simctl boot "\$udid" >/dev/null 2>&1 || true
  xcrun simctl bootstatus "\$udid" -b >/dev/null
}

build_app() {
  local udid="\$1"
  local project_flags=()
  if [[ "\$PROJECT_KIND" == "project" ]]; then
    project_flags=(-project "\$PROJECT_PATH")
  else
    project_flags=(-workspace "\$PROJECT_PATH")
  fi

  xcodebuild "\${project_flags[@]}" \
    -scheme "\$SCHEME" \
    -configuration "\$CONFIGURATION" \
    -sdk xrsimulator \
    -destination "id=\$udid" \
    -derivedDataPath "\$DERIVED_DATA_PATH" \
    build
}

resolve_app_bundle() {
  local products_dir="\$DERIVED_DATA_PATH/Build/Products"
  local exact_bundle=""
  local fallback_bundle=""
  local candidate=""
  local bundle_count=0

  if [[ ! -d "\$products_dir" ]]; then
    echo "Unable to find build products under \$products_dir" >&2
    exit 1
  fi

  while IFS= read -r candidate; do
    if [[ -z "\$exact_bundle" ]]; then
      exact_bundle="\$candidate"
    fi
  done < <(find "\$products_dir" -type d -path '*-xrsimulator/*.app' -name "\$APP_NAME.app" -print | sort)

  if [[ -n "\$exact_bundle" ]]; then
    printf '%s\n' "\$exact_bundle"
    return
  fi

  while IFS= read -r candidate; do
    bundle_count=\$((bundle_count + 1))
    if [[ \$bundle_count -eq 1 ]]; then
      fallback_bundle="\$candidate"
    fi
  done < <(find "\$products_dir" -type d -path '*-xrsimulator/*.app' -name '*.app' -print | sort)

  if [[ \$bundle_count -eq 0 ]]; then
    echo "Unable to find a built .app bundle under \$products_dir" >&2
    exit 1
  fi

  if [[ \$bundle_count -eq 1 ]]; then
    printf '%s\n' "\$fallback_bundle"
    return
  fi

  echo "Found multiple built .app bundles and none matched \$APP_NAME.app." >&2
  echo "Re-run bootstrap with --app-name set to the built app bundle name." >&2
  find "\$products_dir" -type d -path '*-xrsimulator/*.app' -name '*.app' -print | sort | sed 's/^/  /' >&2
  exit 1
}

resolve_bundle_id() {
  local app_bundle="\$1"
  if [[ -n "\$BUNDLE_ID" ]]; then
    printf '%s\n' "\$BUNDLE_ID"
    return
  fi

  if [[ ! -x /usr/libexec/PlistBuddy ]]; then
    echo "Required command not found: /usr/libexec/PlistBuddy" >&2
    exit 1
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
  check_prerequisites
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
