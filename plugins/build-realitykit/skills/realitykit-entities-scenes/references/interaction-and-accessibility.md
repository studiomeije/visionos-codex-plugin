# Input, Gestures, Hover, and Accessibility

Semantics and wiring rules. For exact signatures and availability, query the SDK
with `apple-sdk-lookup`.

## The Interaction Component Stack

Nothing on an entity is interactive until two components are present together:

- `CollisionComponent` - defines the **hit-test shape**. Without it there is
  nothing to hit.
- `InputTargetComponent` - declares that the entity accepts system input.

Every other interaction component builds on that pair. `HoverEffectComponent`
and `ManipulationComponent` both silently do nothing without it - the single
most common "my entity ignores taps" cause.

Collision shapes serve both physics and hit testing. Before changing one to fix
input, check whether physics depends on it - see
[`collisioncomponent.md`](../../realitykit-animation-physics/references/collisioncomponent.md).

## InputTargetComponent

- **Hierarchical.** Put it on a parent and any descendant carrying a
  `CollisionComponent` becomes an input target. This is usually what you want:
  one component at the root of an interactive assembly.
- `allowedInputTypes` narrows to direct or indirect interaction. It also
  propagates down, and a descendant can override it.
- `isEnabled` toggles participation without removing the component - prefer it
  over add/remove churn.

## Choosing A Manipulation Path

Try these in order; drop down a level only when the level above cannot express
the interaction.

1. **`ManipulationComponent`** - built-in move, rotate, scale, and release
   behavior with audio feedback, tuned to feel right on visionOS. Configure via
   `dynamics`, `releaseBehavior`, and `audioConfiguration`, and prefer
   `ManipulationComponent.configureEntity(...)` to wire the required components
   in one call.

   It **writes the entity's transform directly**. If you need your own transform
   on top, apply it to a child entity rather than fighting the system for the
   same transform. Subscribe to its events for custom feedback.

2. **`GestureComponent`** - attach a specific SwiftUI gesture to one entity when
   the built-in manipulation behavior is the wrong shape.

3. **SwiftUI targeted gestures** in the `RealityView` - when the interaction is
   really view-scoped rather than entity-scoped. See `spatial-swiftui-developer`.

## HoverEffectComponent

Provides the look-at / touch feedback that tells a user something is
interactive. It applies to the whole entity hierarchy and supports spotlight,
highlight, and shader-driven effects, and effects can be grouped so several
entities light up together.

On visionOS hover fires from **gaze as well as touch**, so treat it as a
discoverability affordance, not a pointer state - anything hoverable should
actually be actionable.

## AccessibilityComponent

Spatial content is opaque to VoiceOver unless you describe it. Add this to
anything interactive or informational:

- `isAccessibilityElement` to expose the entity at all
- `label` (what it is), `value` (its current state), `hint` (what will happen)
- `traits` to describe behavior, and `customActions` for actions that have no
  direct gesture equivalent

An interactive entity with a hover effect and no accessibility label is a bug,
not a polish item.
