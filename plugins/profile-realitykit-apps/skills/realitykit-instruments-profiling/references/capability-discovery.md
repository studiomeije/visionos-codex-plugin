# Capability Discovery

Use the selected full Xcode installation, not standalone Command Line Tools.

```bash
xcode-select -p
xcrun xctrace version
xcrun xctrace list devices
xcrun xctrace list templates
xcrun xctrace list instruments
```

Check command-specific syntax before recording:

```bash
xcrun xctrace help record
xcrun xctrace help export
```

Classify each needed capability as:

- supported
- unsupported on the selected platform
- physical-device only
- available but timing-distorting
- requires a human or Instruments/Xcode GUI gate

Do not infer capture success from template availability. Target connection,
attachment, permissions, recording, artifact production, and inspection are
separate evidence states.
