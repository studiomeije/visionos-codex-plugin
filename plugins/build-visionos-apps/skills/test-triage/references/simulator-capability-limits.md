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
