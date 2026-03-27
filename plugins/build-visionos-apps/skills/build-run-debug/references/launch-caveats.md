# Launch Caveats

Use this file when a launch symptom may not actually be a build failure.

- A cold Apple Vision Pro simulator boot can take 30 to 60 seconds.
- Apps that declare an `ImmersiveSpace` still usually launch into a window
  first; the immersive space only opens when the app calls
  `openImmersiveSpace(id:)`.
- Slow first launch is not the same as a broken launch.
- If the simulator is up and the bundle launches but the immersive surface is
  missing, debug the call path rather than the installer.
