# Automation-Ready App Design

Use this file when the app itself needs changes so AXe can drive it
reliably.

## Keyboard Shortcuts

Expose important actions through `.keyboardShortcut()` so AXe can trigger them
with `axe key-combo`.

```swift
Button("Open Immersive") {
    Task { await openImmersiveSpace(id: "main") }
}
.keyboardShortcut("i", modifiers: [.command])
```

## Focusability

Make primary controls focusable so keyboard navigation can reach them:

```swift
Button("Start Experience") { }
    .focusable()
```

## Accessibility Labels And Actions

Expose explicit labels and actions so `axe describe-ui` is stable and
assertable:

```swift
Button(action: startExperience) {
    Image(systemName: "play.fill")
}
.accessibilityLabel("Start Experience")
.accessibilityAction(.default) { startExperience() }
```

## Simulator-Only Hooks

Add debug-only launch flags or keyboard shortcuts for immersive entry and
motion sweeps when repeated automation is required.
