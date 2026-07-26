# Regression Comparison

## Comparable Captures

Before comparing, match or explicitly account for:

- source revision and implementation change
- device model, OS build, Xcode, SDK, and runtime
- scheme, configuration, optimization, debugger, validation, and log levels
- scenario inputs, duration, warm-up, cold/warm resource state
- immersive presentation mode and relevant permissions
- thermal state and competing workload
- template, selected instruments, and capture options

Run enough repetitions to expose variance. Declare the chosen statistic and
sample count; use median and a tail statistic when the data supports them.

## Result Language

- **Improved** — matched repeated captures show a meaningful change in the
  acceptance metric and the dominant bottleneck moved as expected.
- **Regressed** — matched captures show a meaningful adverse change.
- **No material change** — observed delta is smaller than the declared
  tolerance or normal variance.
- **Inconclusive** — captures are unmatched, too noisy, incomplete, or not
  inspected.

Never claim "optimized" from one simulator run, code review, signpost duration,
or a trace that was merely produced but not inspected.
