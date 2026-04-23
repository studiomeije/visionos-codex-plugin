# AXe Commands

Use this file when choosing concrete AXe commands.

## Common Commands

- `axe list-simulators`
- `axe screenshot --udid <udid> --output <path>.png`
- `axe record-video --udid <udid> --output <path>.mp4`
- `axe stream-video --udid <udid>`
- `axe type "<text>" --udid <udid>`
- `axe key <keycode> --udid <udid>`
- `axe key-combo --modifiers <hid,...> --key <hid> --udid <udid>`
- `axe key-sequence ...`
- `axe button home|lock|side-button --udid <udid>`
- `axe describe-ui --udid <udid>`
- `axe batch --udid <udid> --step "..." --step "..."`

## Command Choice

- Use screenshots and video for visual evidence after launch.
- Use `describe-ui` for labels, focusability, visible controls, and basic UI
  state that accessibility can expose.
- Use keyboard and hardware-button commands for flows the app deliberately
  exposes through shortcuts or simulator controls.
- Do not use AXe tap, swipe, or gesture commands as proof of visionOS spatial
  interaction behavior.

Prefer `axe --help` and `axe <command> --help` when command syntax and local
AXe version differ from this file.
