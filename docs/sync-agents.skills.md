# Sync With `visionOSAgents`

## Warning

This workflow exists only to keep this repo and `visionOSAgents` in sync for
the shared core skill set. It is not part of normal plugin installation or day
to day plugin usage.

## What Is Synced

Only the shared core skills listed in `sync/shared-skills.json` participate in
repo-to-repo sync.

Plugin-only workflow skills such as `build-run-debug`,
`packaging-distribution`, `visionos-ui-automation`, and `telemetry` stay local
to `visionos-plugin-codex` and must not be added to the shared-skill manifest.

Both repos keep the same lock file in `sync/shared-skills.lock.json`.

## Commands

Use the repo-root sync tool to inspect or move shared skill changes between
`visionos-plugin-codex` and `visionOSAgents`:

```bash
python3 scripts/sync_shared_skills.py status \
  --agents-repo /path/to/visionOSAgents \
  --plugin-repo /path/to/visionos-plugin-codex

python3 scripts/sync_shared_skills.py sync --from agents --to plugin \
  --agents-repo /path/to/visionOSAgents \
  --plugin-repo /path/to/visionos-plugin-codex

python3 scripts/sync_shared_skills.py sync --from plugin --to agents \
  --agents-repo /path/to/visionOSAgents \
  --plugin-repo /path/to/visionos-plugin-codex
```

If the same shared skill changed in both repos since the last successful sync,
the tool stops and those conflicts must be merged manually before rerunning it.
