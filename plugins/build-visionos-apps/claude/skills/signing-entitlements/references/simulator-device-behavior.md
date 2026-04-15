# Simulator Vs Device Behavior

Use this file when the same capability behaves differently on simulator and
device.

## Important Distinctions

- World tracking, hand tracking, room tracking, scene reconstruction, image
  tracking, object tracking, and main camera access may authorize on simulator
  yet return empty or stub data.
- Enterprise entitlements are not enforced the same way on simulator as on a
  physical device.
- Privacy usage strings are required on both simulator and device.

If the expected entitlements are embedded and the API still fails, the likely
causes are usually privacy configuration or simulator-versus-device behavior,
not a broken code signature.
