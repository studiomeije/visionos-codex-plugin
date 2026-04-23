# Credential Handling

Use this file for any task that touches App Store Connect authentication.

## Rules

- Treat the App Store Connect API key as a credential.
- Never commit the `.p8` file.
- Never echo raw key contents into logs or chat.
- Prefer `asc auth login` with keychain storage on developer machines.
- In CI, pass secrets through the secret manager or documented environment
  variables.
- Disable shell tracing before credential-bearing commands; do not use `set -x`
  around App Store Connect auth.
- Do not run broad `env`, `printenv`, or build commands that dump all build
  settings when API-key values may be present.
- Use temporary files with restrictive permissions if a local workflow requires
  a key file, and remove them after the command.
- Redact Team ID only when the user treats it as sensitive; redact Key ID,
  Issuer ID, private key paths, and private key contents by default.

## What The Agent Should Not Do

- Do not ask the user to paste Key ID, Issuer ID, or `.p8` contents into the
  conversation.
- Do not configure `asc auth login` on the user's behalf with pasted
  credentials.
- Do not submit to the App Store without explicit confirmation.
- Do not add `.p8`, `.mobileprovision`, exported `.ipa`, `.xcarchive`,
  Transporter logs, or `asc` auth-profile files to git.
- Do not copy credentials into project-local scripts, task files, or README
  snippets.
- Do not retry 401 or 403 responses by asking for raw secrets. Ask the user to
  refresh the local profile or CI secret outside the chat.

## Safe Patterns

Developer machine:

```bash
asc auth status --output json
asc auth login --name "<profile>" --key-id "<KEY_ID>" --issuer-id "<ISSUER_ID>" --private-key <path/AuthKey.p8>
```

CI:

```bash
# Use the CI provider's secret references or files; never literal values.
asc auth login --name ci --key-id "$ASC_KEY_ID" --issuer-id "$ASC_ISSUER_ID" --private-key "$ASC_PRIVATE_KEY_PATH"
```

After a user accidentally pastes a credential into the conversation, do not
repeat it back. Tell them to rotate or revoke it before continuing release work.
