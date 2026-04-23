# Logging

Use this file when the task needs structured app logs.

## Guidelines

- Prefer `Logger` from `OSLog`.
- Give each feature a clear subsystem and category pair.
- Log boundaries and state transitions, not every frame or every mutation.
- Keep info logs concise and stable.
- Include stable identifiers, counts, and state names needed for verification.
- Never log secrets, auth tokens, personal data, or raw world-sensing payloads.
- Use privacy annotations deliberately; default sensitive values to private.

## Example

```swift
import OSLog

private let logger = Logger(
  subsystem: Bundle.main.bundleIdentifier ?? "SampleApp",
  category: "ImmersiveSpace"
)

@MainActor
func openImmersiveSpace(id: String) async {
  logger.info("Opening immersive space id=\(id, privacy: .public)")
  let result = await openImmersiveSpaceAction(id: id)
  logger.info("Immersive space open result=\(String(describing: result), privacy: .public)")
}
```

## Verification-Friendly Messages

Prefer messages that can answer a concrete post-build question:

- did the window or immersive space request start?
- did the async result return, and with which public enum case?
- did a RealityKit entity load, attach, detach, or fail?
- did the expected SharePlay, ARKit, or media lifecycle transition happen?

Avoid messages whose only value is "reached here"; they are hard to verify and
usually become permanent noise.
