# `asc` Preflight

Run this once at the start of any task that needs App Store Connect.

Do not run upload, TestFlight distribution, metadata apply, or App Store
submission commands until this preflight passes. If `asc` is missing, continue
only with local archive/export validation and use `manual-fallback.md` for the
remaining release steps.

## Step 1: Confirm `asc` Is Installed

```bash
command -v asc >/dev/null 2>&1 && asc --version
```

- Exit 0: proceed.
- Non-zero exit: stop remote-release work and ask the user how they want `asc`
  installed or whether they want the manual fallback. Do not install a CLI or
  ask for credentials without explicit approval.

Source of truth for command shape: `asc --help`, `asc <command> --help`, and
the upstream README. Last checked: 2026-04-10.

Before any state-changing command, verify the specific subcommand locally:

```bash
asc --help
asc builds upload --help
asc publish testflight --help
asc publish appstore --help
```

## Step 2: Confirm Auth Profile

```bash
asc auth status --output json 2>/dev/null || asc auth list --output json 2>/dev/null
```

If no active profile is configured, ask the user to run:

```bash
asc auth login --name "<profile>" --key-id "<KEY_ID>" --issuer-id "<ISSUER_ID>" --private-key <path/AuthKey.p8>
```

Do not ask them to paste raw credentials into the conversation.

Credential-safe handling:

- Profile names are okay to discuss; key contents are not.
- Do not echo `.p8` file contents, API key IDs, issuer IDs, or environment
  variables into logs or chat.
- Prefer keychain-backed local profiles on developer machines.
- Prefer CI secret references over literal values in command examples.

## Step 3: Sanity Check Connectivity

```bash
asc apps list --limit 1 --output json
```

- Success: proceed.
- 401 / 403: the profile is stale; ask the user to refresh it.
- Network error: surface it and stop.

## Step 4: Capture App Context

Before upload or submission, capture the app and build identifiers from `asc`
instead of guessing:

```bash
asc apps list --limit 20 --output json
asc builds list --app <appId> --limit 20 --output json
```

Use JSON output for parsing. If the user supplies an app ID manually, still run
a read-only command to confirm the profile can see it.
