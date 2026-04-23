# Rerun Strategy

Use this file when deciding how broadly to rerun.

## Rules

- Start with the smallest failing scope.
- Use the harness-appropriate `-only-testing:` filter whenever possible.
- Keep the same scheme, destination, simulator runtime, and launch arguments
  when checking reproducibility.
- Do not rerun the full suite without evidence that the failure crosses target
  boundaries.
- Mark likely flakes explicitly instead of overstating confidence.

## Rerun Ladder

1. Rerun the single failing test with the same destination and arguments.
2. Rerun the containing suite or XCTestCase only if the single test is order
   dependent or the first rerun passes unexpectedly.
3. Rerun the target only if the suite result suggests shared state or fixture
   setup is involved.
4. Rerun the full scheme only after the target-level rerun shows cross-target
   interaction or the user explicitly asks for broad confidence.

## Summary Shape

Include:
- the exact command
- the narrowest failing scope
- whether the rerun reproduced
- the next best rerun or fix step
