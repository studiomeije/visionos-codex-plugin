# `asc` CLI Reference

Prefer `--output json` whenever you need to parse results.

Treat this file as a command-family map, not a replacement for local help.
Before running a state-changing command, verify the exact syntax with
`asc <command> --help` in the user's environment.

## Read-Only Discovery

- `asc --version`
- `asc auth status --output json`
- `asc auth list --output json`
- `asc apps list --limit 20 --output json`
- `asc builds list --app <appId> --limit 20 --output json`

## Builds And TestFlight

- `asc builds list --app <appId> --limit 20`
- `asc builds upload --app <appId> --ipa <path>.ipa`
- `asc builds next-build-number --app <appId>`
- `asc publish testflight --app <appId> --build <buildId> --group "<group>"`
- `asc testflight feedback list --app <appId>`
- `asc testflight crashes list --app <appId>`

## App Store Submission

- `asc publish appstore --app <appId> --ipa <path>.ipa --version <semver> --submit --confirm`
- `asc validate --app <appId> --version <semver>`
- `asc status --app <appId> --watch`
- `asc submit status --version-id "<versionId>"`
- `asc review status --app <appId> --watch`
- `asc review doctor --app <appId>`

## Metadata And Screenshots

- `asc metadata apply --app <appId> --version <semver> --dir ./metadata --dry-run`
- `asc localizations list --app <appId>`
- `asc metadata keywords audit --app <appId> --version <semver> --blocked-terms-file ./blocked-terms.txt`
- `asc screenshots plan --app <appId> --version <semver> --review-output-dir ./screenshots/review`
- `asc screenshots apply --app <appId> --version <semver> --review-output-dir ./screenshots/review --confirm`
- `asc video-previews list --app <appId>`

## Signing Assets

- `asc certificates list`
- `asc profiles list`
- `asc bundle-ids list`

## Xcode Cloud

- `asc xcode-cloud run --workflow-id "<workflowId>" --pull-request-id "<prId>"`
- `asc xcode-cloud build-runs get --id <runId>`

## State-Changing Boundaries

- Uploading a build changes App Store Connect state. Require a confirmed
  exported `.ipa`, working auth profile, and clear user intent.
- Publishing to TestFlight changes tester availability. Confirm group, build,
  and whether external testing requires review.
- Submitting to App Review requires explicit user confirmation in the current
  conversation. Prefer `asc validate`, `asc review doctor`, or documented
  dry-run modes first.
- Metadata and screenshot `apply` commands should use a dry run first and then
  a separate confirmed apply.
