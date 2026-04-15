# Rerun Strategy

Use this file when deciding how broadly to rerun.

## Rules

- Start with the smallest failing scope.
- Use the harness-appropriate `-only-testing:` filter whenever possible.
- Do not rerun the full suite without evidence that the failure crosses target
  boundaries.
- Mark likely flakes explicitly instead of overstating confidence.

## Summary Shape

Include:
- the exact command
- the narrowest failing scope
- whether the rerun reproduced
- the next best rerun or fix step
