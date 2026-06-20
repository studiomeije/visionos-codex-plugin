# Automation-Ready App Design

Use this file when the app itself needs changes so first-party automation can
drive and assert it reliably.

## Accessibility Identifiers

Give stable identifiers to controls that XCUITest needs to locate:

```swift
Button("Open Immersive") {
    Task { await openImmersiveSpace(id: "main") }
}
.accessibilityIdentifier("openImmersiveButton")
```

Identifiers are for tests; labels are for users and assistive technologies.

## Keyboard Shortcuts

Expose important actions through `.keyboardShortcut()` only when the app should
support that shortcut for real users or internal builds. Prefer XCUITest
element interactions or explicit debug hooks for unattended automation.

```swift
Button("Open Immersive") {
    Task { await openImmersiveSpace(id: "main") }
}
.keyboardShortcut("i", modifiers: [.command])
```

## Focusability

Make primary controls focusable when keyboard or focus navigation is part of
the supported interaction model:

```swift
Button("Start Experience") { }
    .focusable()
```

## Accessibility Labels And Actions

Expose explicit labels and actions so XCUITest and Accessibility Inspector can
verify the user-facing accessibility surface:

```swift
Button(action: startExperience) {
    Image(systemName: "play.fill")
}
.accessibilityLabel("Start Experience")
.accessibilityAction(.default) { startExperience() }
```

## Simulator-Only Hooks

Add debug-only launch flags, URL routes, or visible debug controls for
immersive entry and motion sweeps when repeated automation is required.

Keep simulator hooks deterministic:

- guard them with `#if DEBUG` or an explicit internal build flag
- make one shortcut perform one observable action
- emit a `Logger` event from the action if telemetry will verify it
- avoid hidden production behavior that only exists for automation

## URL And Launch-Argument Hooks

Prefer explicit hooks when host-side simulator controls cannot represent the
visionOS interaction directly:

```swift
@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                    guard url.host == "automation" else { return }
                    AutomationRouter.shared.handle(url)
                }
        }
    }
}
```

Pair each hook with an observable result: an accessibility-visible status,
a test assertion, a screenshot/video artifact, or a telemetry event.
