# /plan

Break a visionOS feature spec into ordered, verifiable implementation tasks.

## Arguments

$ARGUMENTS - Feature name or path to spec document

## Workflow

Given an approved spec (from /spec or provided directly):

1. Identify the thinnest first slice that proves the scene model works
2. Break remaining work into tasks, each with:
   - Clear acceptance criteria
   - Dependencies on prior tasks
   - Which skill or agent to invoke
3. Order tasks so each builds on the last verified slice
4. Ensure each task can be verified on Apple Vision Pro simulator
5. Include dedicated tasks for:
   - .xcodeproj changes
   - .entitlements and Info.plist changes
   - RealityKit component/system additions
   - ARKit provider setup
6. Output the task list with estimated scope (small/medium/large per task)

Hand off to incremental-build skill for execution.
