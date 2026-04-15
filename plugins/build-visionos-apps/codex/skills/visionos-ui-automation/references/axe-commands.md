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

Prefer `axe --help` and `axe <command> --help` when command syntax and local
AXe version differ from this file.
