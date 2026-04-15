# /test-visionos-app

Run the smallest meaningful visionOS test scope first and classify failures by type.

## Arguments

$ARGUMENTS - Optional: scheme name, test target, filter expression, or configuration

## Workflow

1. Detect the test harness and scope
   - Prefer xcodebuild test for visionOS app and integration testing
   - Use the smallest focused target or filter before any broader suite

2. Choose a simulator destination deliberately
   - Prefer a Vision Pro simulator destination
   - Keep the destination aligned with the app's scene requirements

3. Classify the failure precisely
   - Build failure
   - Assertion failure
   - Crash or signal
   - Async timing or flake
   - Simulator or environment issue
   - Missing privacy key or entitlement
   - Scene lifecycle or immersive bootstrapping failure

4. Route to the right skill when needed
   - skills/debugging-triage for systematic root-cause analysis
   - skills/signing-entitlements for privacy or capability issues

5. Summarize the narrowest next step
   - Prefer a focused rerun over a full suite rerun
   - Call out when the blocker is app launch, scene startup, or entitlement setup

## Guardrails

- Do not rerun the full suite if a smaller rerun is available
- Do not treat simulator setup as a product bug
- Distinguish compile failures from test execution failures
