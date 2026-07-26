# Trace Artifacts

## Recording

Use a bounded output directory outside the repository. Discover exact syntax
from the selected `xctrace` version before substituting target and process
values.

```bash
xcrun xctrace record \
  --template "RealityKit Trace" \
  --device "<device>" \
  --attach "<process-or-pid>" \
  --time-limit 20s \
  --output "/absolute/path/to/capture.trace"
```

After recording, inspect the table of contents before attempting a narrow
export:

```bash
xcrun xctrace export --input "/absolute/path/to/capture.trace" --toc
```

Export schemas and XPath expressions can change. Preserve the original trace
and report when detailed analysis requires Instruments GUI.

## Retention And Privacy

- Keep traces, log archives, GPU captures, sysdiagnose bundles, screenshots,
  videos, and crash artifacts out of git.
- Record size and a cryptographic hash before handoff.
- Preserve the matching app binary UUID and dSYM for symbolication.
- Sanitize filenames and exported summaries.
- Treat paths, symbols, entity names, URLs, logs, device names, and captured
  surroundings as potentially sensitive.
- Never auto-upload an artifact without explicit scope.
