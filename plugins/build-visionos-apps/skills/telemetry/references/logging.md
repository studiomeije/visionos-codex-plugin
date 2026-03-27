# Logging

Use this file when the task needs structured app logs.

## Guidelines

- Prefer `Logger` from `OSLog`.
- Give each feature a clear subsystem and category pair.
- Log boundaries and state transitions, not every frame or every mutation.
- Keep info logs concise and stable.
- Never log secrets, auth tokens, personal data, or raw world-sensing payloads.

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
