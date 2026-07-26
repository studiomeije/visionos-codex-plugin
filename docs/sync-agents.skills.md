# Sync With `visionOSAgents`

## Warning

This workflow exists only to keep this repo and `visionOSAgents` in sync for
the shared core skill set. It is not part of normal plugin installation or day
to day plugin usage.

## What Is Synced

Only the shared core skills listed in `sync/shared-skills.json` participate in
repo-to-repo sync.

Plugin-only workflow and Vision Pro-adjacent tooling skills such as
`build-run-debug`, `packaging-distribution`, and `visionos-ui-automation` stay
local to `visionos-codex-plugin` and must not be added to the shared-skill
manifest.

All skills under `profile-realitykit-apps` are operational profiling workflows
and also remain plugin-local.

Both repos keep the same lock file in `sync/shared-skills.lock.json`.

## Commands

Use the repo-root sync tool to inspect or move shared skill changes between
`visionos-codex-plugin` and `visionOSAgents`:

```bash
python3 scripts/sync_shared_skills.py status \
  --agents-repo /path/to/visionOSAgents \
  --plugin-repo /path/to/visionos-codex-plugin

python3 scripts/sync_shared_skills.py sync --from agents --to plugin \
  --agents-repo /path/to/visionOSAgents \
  --plugin-repo /path/to/visionos-codex-plugin

python3 scripts/sync_shared_skills.py sync --from plugin --to agents \
  --agents-repo /path/to/visionOSAgents \
  --plugin-repo /path/to/visionos-codex-plugin
```

Use `--from agents --to plugin` when the shared skill source change was made in
`visionOSAgents`. Use `--from plugin --to agents` only when a shared skill was
intentionally changed in this plugin repo and must be upstreamed.

The status command is the gate after every sync. A healthy shared-skill state
prints `status: initialized` and each shared skill line ends up classified as
`clean`.

If the same shared skill changed in both repos since the last successful sync,
the tool stops and those conflicts must be merged manually before rerunning it.

## After Syncing

Repo-to-repo sync does not update installed Codex plugins. After a successful
sync, validate the marketplace checkout and use the normal Codex marketplace
installation or update flow. For a local checkout, configure it once:

```bash
codex plugin marketplace add /absolute/path/to/visionos-codex-plugin
```

Install a plugin from that marketplace when needed:

```bash
codex plugin add build-visionos-apps@visionos-codex-marketplace
```

Do not copy plugin directories or edit Codex marketplace metadata manually.
