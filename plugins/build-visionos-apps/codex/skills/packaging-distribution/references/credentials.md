# Credential Handling

Use this file for any task that touches App Store Connect authentication.

## Rules

- Treat the App Store Connect API key as a credential.
- Never commit the `.p8` file.
- Never echo raw key contents into logs or chat.
- Prefer `asc auth login` with keychain storage on developer machines.
- In CI, pass secrets through the secret manager or documented environment
  variables.

## What The Agent Should Not Do

- Do not ask the user to paste Key ID, Issuer ID, or `.p8` contents into the
  conversation.
- Do not configure `asc auth login` on the user's behalf with pasted
  credentials.
- Do not submit to the App Store without explicit confirmation.
