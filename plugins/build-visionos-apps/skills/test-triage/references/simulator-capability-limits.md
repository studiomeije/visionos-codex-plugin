# Simulator Capability Limits

Use this file when a test depends on hardware-backed visionOS features.

The Apple Vision Pro simulator may stub, no-op, or authorize-fail for features
that require real hardware. Common examples:

- world tracking
- hand tracking
- room tracking
- image tracking
- scene reconstruction
- main camera access
- accessory tracking

If a test requires real provider data, do not call it a product regression
without first confirming it is expected to pass on simulator.

## Verification Guidance

- Prefer mocks, recorded fixtures, or dependency injection for simulator tests
  that exercise ARKit provider consumers.
- If the test is intentionally device-only, say that and do not keep rerunning
  it on the simulator.
- If the simulator should still exercise an authorization or error path, verify
  that path through the test assertion or unified logs before classifying it as
  a capability gap.
