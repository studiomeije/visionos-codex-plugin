# BloomComponent

## Overview

Components that add a bloom (glow) effect to bright rendered content. `BloomComponent` enables bloom and sets its scope; `BloomOptionsComponent` tunes strength, threshold, and blur radius. Bright pixels above the threshold bleed light into neighboring pixels, making emissive materials and intense lights read as glowing.

New in visionOS 27. Beta API: names and shapes may change before release.

## How to Use

### Enable Bloom

```swift
import RealityKit

// Default scope is .unbounded
entity.components.set(BloomComponent())
```

### Choose a Scope

```swift
// Bloom only the entity's hierarchy
entity.components.set(BloomComponent(scope: .hierarchical))

// Bloom without hierarchy bounds
entity.components.set(BloomComponent(scope: .unbounded))
```

### Tune the Effect

```swift
var options = BloomOptionsComponent()
options.strength = 0.8     // Intensity of the glow
options.threshold = 1.0    // Brightness level where bloom starts
options.blurRadius = 12.0  // Spread of the glow
entity.components.set(options)
```

## Key Properties

`BloomComponent`:
- `scope: BloomScope` - `.hierarchical` or `.unbounded` (default: `.unbounded`)

`BloomOptionsComponent`:
- `strength: Float` - Intensity of the bloom contribution
- `threshold: Float` - Brightness cutoff; only pixels above it bloom
- `blurRadius: Float` - How far the glow spreads

## Important Notes

- New in visionOS 27; also available on macOS 27, iOS 27, tvOS 27,
  and macCatalyst 27.
- `BloomSettingsComponent` also exists in the SDK but is already deprecated
  with "Use BloomOptionsComponent instead" - it has the same `strength` /
  `threshold` / `blurRadius` properties. Write new code against
  `BloomOptionsComponent`.
- `BloomComponent` declares the effect and its scope; `BloomOptionsComponent`
  tunes it. Set both when customizing the look.
- `.hierarchical` scopes the effect to the entity's subtree; `.unbounded`
  does not bound it to the hierarchy.
