#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
plugin_root="$repo_root/plugins/build-visionos-apps"
plugin_name="build-visionos-apps"
legacy_plugin_names=(
  "visionos-codex-plugin"
)
marketplace_default="$HOME/.agents/plugins/marketplace.json"

print_usage() {
  cat <<'EOF'
Usage: install-plugin.sh [options]

Install this repo's packaged Codex plugin into a Codex home.
Any previously installed copy of this plugin is removed first.

Options:
      --home <path>         Override Codex home (installs to <home>/plugins).
      --plugins-dir <path>  Override plugin directory directly.
      --path <path>         Alias for --plugins-dir.
      --marketplace-file <path>
                            Override marketplace metadata file.
      --skip-marketplace    Do not update marketplace metadata.
      --dry-run             Print the planned install work without changing files.
  -h, --help                Show this help.

Environment variables:
  CODEX_HOME  Destination home when --home is not provided (default: ~/.codex)

Examples:
  ./scripts/install-plugin.sh
  ./scripts/install-plugin.sh --home ~/.codex
  ./scripts/install-plugin.sh --plugins-dir /tmp/codex/plugins
  ./scripts/install-plugin.sh --skip-marketplace --plugins-dir /tmp/codex/plugins
EOF
}

expand_tilde() {
  local path="$1"
  if [[ "$path" == "~" ]]; then
    printf '%s\n' "$HOME"
    return 0
  fi
  if [[ "$path" == "~/"* ]]; then
    printf '%s\n' "${HOME}${path:1}"
    return 0
  fi
  printf '%s\n' "$path"
}

home_override=""
plugins_dir_override=""
marketplace_file="$marketplace_default"
skip_marketplace=0
dry_run=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --home)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for $1" >&2
        print_usage >&2
        exit 2
      fi
      home_override="$2"
      shift 2
      ;;
    --plugins-dir|--path)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for $1" >&2
        print_usage >&2
        exit 2
      fi
      plugins_dir_override="$2"
      shift 2
      ;;
    --marketplace-file)
      if [[ $# -lt 2 ]]; then
        echo "Missing value for $1" >&2
        print_usage >&2
        exit 2
      fi
      marketplace_file="$2"
      shift 2
      ;;
    --skip-marketplace)
      skip_marketplace=1
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      print_usage >&2
      exit 2
      ;;
    *)
      echo "Unexpected argument: $1" >&2
      print_usage >&2
      exit 2
      ;;
  esac
done

if [[ ! -d "$plugin_root" ]]; then
  echo "Packaged plugin not found at $plugin_root" >&2
  exit 1
fi

plugins_dir=""
if [[ -n "$plugins_dir_override" ]]; then
  plugins_dir="$(expand_tilde "$plugins_dir_override")"
elif [[ -n "$home_override" ]]; then
  plugins_dir="$(expand_tilde "$home_override")/plugins"
else
  plugins_dir="$(expand_tilde "${CODEX_HOME:-$HOME/.codex}")/plugins"
fi

destination_dir="$plugins_dir/$plugin_name"
marketplace_file="$(expand_tilde "$marketplace_file")"
marketplace_plugin_path="$destination_dir"
if [[ "$destination_dir" == "$HOME/"* ]]; then
  marketplace_plugin_path="./${destination_dir#"$HOME"/}"
fi

echo "Source plugin: $plugin_root"
echo "Destination plugins dir: $plugins_dir"
echo "Destination plugin dir: $destination_dir"
if [[ $skip_marketplace -eq 1 ]]; then
  echo "Marketplace update: skipped"
else
  echo "Marketplace file: $marketplace_file"
  echo "Marketplace plugin path: $marketplace_plugin_path"
fi

remove_targets=("$destination_dir")
for legacy_name in "${legacy_plugin_names[@]}"; do
  legacy_dir="$plugins_dir/$legacy_name"
  if [[ "$legacy_dir" != "$destination_dir" ]]; then
    remove_targets+=("$legacy_dir")
  fi
done

for path in "${remove_targets[@]}"; do
  if [[ -e "$path" ]]; then
    echo "Removing existing install: $path"
  fi
done

if [[ $dry_run -eq 1 ]]; then
  echo "Dry run only; no files were changed."
  exit 0
fi

update_marketplace_metadata() {
  local path="$1"
  local plugin_path="$2"

  python3 - "$path" "$plugin_name" "$plugin_path" <<'PY'
import json
import sys
from pathlib import Path

marketplace_path = Path(sys.argv[1])
plugin_name = sys.argv[2]
plugin_path = sys.argv[3]

if marketplace_path.is_file():
    data = json.loads(marketplace_path.read_text(encoding="utf-8"))
else:
    data = {
        "name": "studio-meije",
        "interface": {"displayName": "Studio Meije"},
        "plugins": [],
    }

plugins = data.setdefault("plugins", [])
if not isinstance(plugins, list):
    raise SystemExit(f"marketplace plugins must be an array: {marketplace_path}")

entry = next(
    (candidate for candidate in plugins if candidate.get("name") == plugin_name),
    None,
)
if entry is None:
    entry = {"name": plugin_name}
    plugins.append(entry)

entry["source"] = {"source": "local", "path": plugin_path}
entry["policy"] = {
    "installation": "INSTALLED_BY_DEFAULT",
    "authentication": "ON_INSTALL",
}
entry["category"] = "Coding"

marketplace_path.parent.mkdir(parents=True, exist_ok=True)
marketplace_path.write_text(
    json.dumps(data, indent=2) + "\n",
    encoding="utf-8",
)
PY
}

mkdir -p "$plugins_dir"

for path in "${remove_targets[@]}"; do
  if [[ -e "$path" ]]; then
    rm -rf "$path"
  fi
done

if command -v rsync >/dev/null 2>&1; then
  mkdir -p "$destination_dir"
  rsync -a --delete \
    --exclude '.DS_Store' \
    --exclude '__pycache__' \
    --exclude '.gitkeep' \
    "$plugin_root/" "$destination_dir/"
else
  cp -R "$plugin_root" "$plugins_dir/"
fi

find "$destination_dir" -name '.DS_Store' -type f -delete
find "$destination_dir" -name '.gitkeep' -type f -delete
find "$destination_dir" -name '__pycache__' -type d -prune -exec rm -rf {} +

if [[ $skip_marketplace -eq 0 ]]; then
  update_marketplace_metadata "$marketplace_file" "$marketplace_plugin_path"
  echo "Updated marketplace metadata -> $marketplace_file"
fi

echo "Installed $plugin_name -> $destination_dir"
echo "Restart Codex to pick up the updated plugin."
