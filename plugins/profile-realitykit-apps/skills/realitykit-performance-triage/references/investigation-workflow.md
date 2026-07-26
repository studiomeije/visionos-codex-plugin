# Investigation Workflow

## Loop

1. **Runnable gate** — prove the intended app, scheme, configuration, and target
   can build and launch.
2. **Scenario** — define one bounded interaction, its start and stop signal, and
   the user-visible symptom.
3. **Baseline** — record the build and target metadata before changing code.
4. **Classify** — begin with RealityKit Trace or the narrowest available
   capture; determine whether the dominant evidence is frame/GPU, CPU/ECS,
   memory/assets, audio/spatial, lifecycle, or thermal/power.
5. **Correlate** — add only the logs or signposts needed to locate app-owned
   work inside the trace.
6. **Change** — hand the evidence to the implementation skill that owns the
   code or authored asset.
7. **Verify** — repeat the identical scenario, capture, and comparison policy.

## Stop Conditions

Stop and report a gate instead of guessing when:

- the app cannot launch reproducibly
- the intended device is unpaired, locked, or unavailable
- privacy authorization or a physical interaction requires the user
- the installed Xcode does not expose the requested tool or template
- the artifact cannot be opened or inspected
- baseline and candidate captures are not comparable
