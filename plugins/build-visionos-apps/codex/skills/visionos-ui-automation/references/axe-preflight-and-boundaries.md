# AXe Reference Map

Load this file first when you need install checks, fallback behavior, or the
visionOS support boundary.

## Preflight

```bash
command -v axe >/dev/null 2>&1 && axe --version
```

If AXe is missing, stop and ask the user to install it with:

```bash
brew install cameroncooke/axe/axe
```

Then confirm a booted Apple Vision Pro simulator is available:

```bash
axe list-simulators 2>/dev/null | grep -i "Apple Vision Pro" || \
  xcrun simctl list devices booted | grep -i "Apple Vision Pro"
```

## Manual Fallback

- screenshots and video: `xcrun simctl io`
- hardware buttons: `xcrun simctl io <udid> pressHome`
- text input and key combos: interactive-only `osascript` fallback, not safe
  for unattended runs
- accessibility tree: no clean CLI fallback; use Accessibility Inspector or
  XCUITest debug output

When you fall back, say so explicitly in the summary.

## visionOS Support Boundary

What works well:
- screenshots and video
- keyboard input and key combinations
- simulator hardware buttons
- accessibility tree inspection
- batched post-launch flows

What does not map well:
- coordinate taps
- swipes
- 2D gesture automation

Route spatial gesture automation to XCUITest or in-app hooks.
