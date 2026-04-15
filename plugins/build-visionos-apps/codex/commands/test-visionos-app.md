# /test-visionos-app

Run the smallest meaningful visionOS test scope first and classify failures by
type. Use `xcodebuild test` with a simulator destination unless the project
shape clearly requires something else.

## Arguments

- `scheme`: Xcode scheme name, if known
- `target`: test target or product name, if known
- `filter`: test filter expression, if known
- `configuration`: `Debug` or `Release` (optional, default: `Debug`)

## Workflow

1. Detect the test harness and scope.
   - Prefer `xcodebuild test` for visionOS app and integration testing.
   - Use the smallest focused target or filter before any broader suite.

2. Choose a simulator destination deliberately.
   - Prefer a Vision Pro simulator destination.
   - Keep the destination aligned with the app's scene and immersive-space
     requirements.

3. Classify the failure precisely.
   - Build failure
   - Assertion failure
   - Crash or signal
   - Async timing or flake
   - Simulator or environment issue
   - Missing privacy key or entitlement
   - Scene lifecycle or immersive bootstrapping failure

4. Tie failures back to the right skill when needed.
   - Use `../skills/build-run-debug/SKILL.md` if the failure is really a build
     or launch problem.
   - Use `../skills/signing-entitlements/SKILL.md` if the test points to a
     privacy or capability issue.
   - Use `../skills/test-triage/SKILL.md` for the deeper triage workflow,
     including Swift Testing (`@Test` / `#expect`) targets.
   - Use `../skills/visionos-ui-automation/SKILL.md` when post-launch
     evidence — screenshots, video, accessibility trees, keyboard-driven
     flows — is the cheapest way to confirm or reject a theory.

5. Summarize the narrowest next step.
   - Prefer a focused rerun over a full suite rerun.
   - Call out when the blocker is app launch, scene startup, or entitlement
     setup rather than test logic.

## Guardrails

- Do not rerun the full suite if a smaller rerun is available.
- Do not treat simulator setup or immersive-space startup as a product bug.
- Distinguish compile failures from actual test execution failures.
- Do not assume host-app lifecycle issues are test assertions.

