# Launch Caveats

Use this file when a launch symptom may not actually be a build failure.

- A cold Apple Vision Pro simulator boot can take 30 to 60 seconds.
- A simulator named "Apple Vision Pro" can exist for more than one runtime;
  confirm the selected device uses the expected visionOS 26 runtime.
- Apps that declare an `ImmersiveSpace` still usually launch into a window
  first; the immersive space only opens when the app calls
  `openImmersiveSpace(id:)`.
- Slow first launch is not the same as a broken launch.
- If the simulator is up and the bundle launches but the immersive surface is
  missing, debug the call path rather than the installer.
- If the simulator list is empty or the destination is unavailable, verify the
  active Xcode before changing app code.
