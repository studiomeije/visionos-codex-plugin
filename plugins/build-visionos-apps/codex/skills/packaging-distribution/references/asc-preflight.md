# `asc` Preflight

Run this once at the start of any task that needs App Store Connect.

## Step 1: Confirm `asc` Is Installed

```bash
command -v asc >/dev/null 2>&1 && asc --version
```

- Exit 0: proceed.
- Non-zero exit: stop and ask the user to install it with `brew install asc`.

Source of truth for command shape: `asc --help`, `asc <command> --help`, and
the upstream README. Last checked: 2026-04-10.

## Step 2: Confirm Auth Profile

```bash
asc auth status --output json 2>/dev/null || asc auth list --output json 2>/dev/null
```

If no active profile is configured, ask the user to run:

```bash
asc auth login --name "<profile>" --key-id "<KEY_ID>" --issuer-id "<ISSUER_ID>" --private-key <path/AuthKey.p8>
```

Do not ask them to paste raw credentials into the conversation.

## Step 3: Sanity Check Connectivity

```bash
asc apps list --limit 1 --output json
```

- Success: proceed.
- 401 / 403: the profile is stale; ask the user to refresh it.
- Network error: surface it and stop.
