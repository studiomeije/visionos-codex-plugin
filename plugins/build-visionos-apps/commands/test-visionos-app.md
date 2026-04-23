# /test-visionos-app

Run the smallest meaningful visionOS test scope first and classify failures by
type. Use `test-triage` for the failure workflow, and use XcodeBuildMCP first
for project, scheme, simulator, and build/run context. Use `xcodebuild test`
with a visionOS simulator destination unless the current MCP session exposes a
test runner or the project shape clearly requires something else.

## Arguments

- `scheme`: Xcode scheme name, if known
- `target`: test target or product name, if known
- `filter`: test filter expression, if known
- `configuration`: `Debug` or `Release` (optional, default: `Debug`)

## Workflow

1. Route through the real plugin skills.
   - Use `../skills/test-triage/SKILL.md` as the primary skill.
   - Use `../skills/build-run-debug/SKILL.md` first when project discovery,
     simulator selection, launch stability, or a build failure blocks test
     execution.
   - Use `../skills/swiftpm-visionos/SKILL.md` only for pure SwiftPM package
     tests with no app-hosted visionOS target.

2. Detect the test harness and scope.
   - Prefer `xcodebuild test` for visionOS app and integration testing.
   - Use the smallest focused target or filter before any broader suite.
   - For Swift Testing, keep the same focus rule: run the smallest target,
     suite, or test filter that can answer the question.

3. Choose a simulator destination deliberately.
   - Prefer a Vision Pro simulator destination.
   - Keep the destination aligned with the app's scene and immersive-space
     requirements.
   - Reuse the XcodeBuildMCP defaults from `build-run-debug` when they already
     point at the correct workspace/project, scheme, and simulator.

4. Classify the failure precisely.
   - Build failure
   - Assertion failure
   - Crash or signal
   - Async timing or flake
   - Simulator or environment issue
   - Missing privacy key or entitlement
   - Scene lifecycle or immersive bootstrapping failure

5. Tie failures back to the right skill when needed.
   - Use `../skills/signing-entitlements/SKILL.md` if the test points to a
     privacy or capability issue.
   - Use `../skills/visionos-ui-automation/SKILL.md` when post-launch
     evidence such as screenshots, video, accessibility trees, or keyboard
     flows is the cheapest way to confirm or reject a theory.
   - Return to `../skills/test-triage/SKILL.md` for the focused rerun after the
     blocker is resolved.

6. Summarize the narrowest next step.
   - Prefer a focused rerun over a full suite rerun.
   - Call out when the blocker is app launch, scene startup, or entitlement
     setup rather than test logic.

## Guardrails

- Do not rerun the full suite if a smaller rerun is available.
- Do not treat simulator setup or immersive-space startup as a product bug.
- Distinguish compile failures from actual test execution failures.
- Do not assume host-app lifecycle issues are test assertions.
- Do not use UI automation as a substitute for unit or integration tests when
  the failure is already reproducible in the test runner.
