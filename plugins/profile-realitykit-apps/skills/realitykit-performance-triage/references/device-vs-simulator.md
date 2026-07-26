# Device Versus Simulator

## Simulator Evidence

Use the Apple Vision Pro simulator for:

- build, install, launch, and deterministic scenario plumbing
- log categories, signpost pairing, and lifecycle ordering
- non-timing structural counts and some CPU or allocation hypotheses
- fast iteration before a physical-device capture

Label simulator timing as non-authoritative. Host CPU, GPU, display,
compositor, tracking, audio, thermal, and power behavior do not represent
Apple Vision Pro hardware.

## Physical-Device Evidence

Require a controlled Vision Pro run for final claims about:

- RealityKit frame pacing and missed render deadlines
- GPU or Metal performance and foveated rendering
- world-sensing, hand-tracking, or compositor behavior
- spatial audio hardware behavior
- power, thermal throttling, and sustained performance

Pairing, trust, Developer Mode, unlock, signing, and privacy prompts are human
or device gates. Detect and report them; do not silently change entitlements or
reset permissions.

## Evidence Ladder

1. Static source/build inspection
2. Simulator functional evidence
3. Simulator trace with timing caveat
4. Device Debug/Profile evidence with overhead disclosed
5. Device optimized-build matched comparison
