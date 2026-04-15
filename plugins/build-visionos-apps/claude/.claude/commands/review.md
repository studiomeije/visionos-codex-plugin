# /review

Review visionOS code across spatial, RealityKit, Swift, and engineering quality axes.

## Arguments

$ARGUMENTS - File paths, PR number, or branch to review

## Workflow

Review the specified code across these axes:

1. **Correctness** - Does the code do what the spec says? Are RealityKit components registered? Are ARKit providers correctly configured?
2. **Spatial design** - Is the right surface type used? Does the scene model match the user intent? Are entity lifecycles clean?
3. **Swift quality** - Modern Swift 6 patterns, concurrency safety, observation framework usage
4. **Security and privacy** - Are entitlements minimal? Are privacy keys present and accurate? Is user data handled correctly?
5. **Performance** - Will this sustain 90fps? Are there unnecessary allocations in the render loop? Is hand tracking data processed efficiently?

For each finding:
- State the issue clearly
- Classify severity: blocker, warning, or suggestion
- Provide the minimal fix

Invoke the spatial-architect agent for architectural concerns.
Invoke the realitykit-debugger agent for runtime behaviour questions.
