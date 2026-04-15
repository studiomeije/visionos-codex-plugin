#!/usr/bin/env bash
# post-build-log-capture.sh
# After every XcodeBuildMCP build, capture the full log output and
# inject it into the Claude Code session context.
#
# This hook feeds the xcode-build-agent the evidence it needs
# without manual copy-paste.
#
# Usage: Called automatically as a post-build hook.
# Expects XCODE_BUILD_LOG_PATH to be set by the build system,
# or falls back to the most recent log in DerivedData.

set -euo pipefail

LOG_PATH="${XCODE_BUILD_LOG_PATH:-}"

if [ -z "$LOG_PATH" ]; then
  DERIVED_DATA="${DERIVED_DATA_PATH:-$HOME/Library/Developer/Xcode/DerivedData}"
  LOG_PATH=$(find "$DERIVED_DATA" -name "*.xcactivitylog" -type f -print0 \
    | xargs -0 ls -t 2>/dev/null \
    | head -1)
fi

if [ -z "$LOG_PATH" ] || [ ! -f "$LOG_PATH" ]; then
  echo "post-build-log-capture: no build log found, skipping" >&2
  exit 0
fi

# xcactivitylog files are gzipped - decompress for readability
if [[ "$LOG_PATH" == *.xcactivitylog ]]; then
  gunzip -c "$LOG_PATH" 2>/dev/null || cat "$LOG_PATH"
else
  cat "$LOG_PATH"
fi
