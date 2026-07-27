# Lighting and Shadows

Semantics and platform behavior. For exact signatures, defaults, and
availability, query the SDK with `apple-sdk-lookup`.

## On visionOS, Reach For IBL First

Analytic lights (point, spot, directional) exist on visionOS but behave
differently than on iOS or macOS, and a shared space gives you no control over
real-world light. `ImageBasedLightComponent` is the consistently supported path
for making content look correct on Apple Vision Pro. Use analytic lights for
deliberate, local effects - a spotlight beam, a lamp - not as the primary scene
lighting.

## What Each Light Responds To

| Light | Driven by | Casts shadows |
|---|---|---|
| `DirectionalLightComponent` | Entity **orientation** only; position is ignored | Yes, via `DirectionalLightComponent.Shadow` |
| `SpotLightComponent` | Position **and** orientation; emits along the entity's -Z axis | Yes, via `SpotLightComponent.Shadow` |
| `PointLightComponent` | Position only | **No.** Point lights do not cast shadows |

Use one directional light for primary lighting. Multiple directional lights are
not reliably composed.

`attenuationRadius` on point and spot lights is the distance where intensity
reaches zero. Keep it as small as the effect allows - it bounds how much
geometry the light has to touch.

## Shadow Is A Component, Not A Property

This is the single most common mistake. `Shadow` is a nested type that conforms
to `Component`; set it on the light entity next to the light component:

```swift
entity.components.set(SpotLightComponent())

var shadow = SpotLightComponent.Shadow()
shadow.depthBias = 0.01
shadow.zFar = .fixed(20.0)
entity.components.set(shadow)
```

`entity.shadow` does exist, but only on the legacy `HasSpotLight` /
`HasDirectionalLight` entity protocols - not on the component structs.

Shadow shape differs by light type:

- `DirectionalLightComponent.Shadow` - `shadowProjection`
  (`.automatic(maximumDistance:)` or `.fixed(zNear:zFar:orthographicScale:)`),
  `depthBias`, `cullModeOverride`, plus `cascades` and `layers` in visionOS 27.
  Its `maximumDistance` property is **unavailable on visionOS**; use
  `shadowProjection`.
- `SpotLightComponent.Shadow` - `depthBias`, `zNear` / `zFar`
  (`ShadowClippingPlane`), `quality`, `lightSize`, plus `layers` in visionOS 27.
  There is no `maximumDistance` here at all.

`DynamicLightShadowComponent` opts an individual entity **out** of casting into
dynamic light shadows (`castsShadow`, default `true`). It has no effect under a
point light, since point lights never cast.

## Grounding Shadows Are A Separate System

`GroundingShadowComponent` is not related to the analytic lights. It grounds
virtual content against real surfaces so an object reads as resting rather than
floating - the main depth cue in a shared space.

- Inside `RealityView` the system supplies an implicit downward light. Do not add
  a light or a shadow-catcher plane to make it work.
- `castsShadow` / `receivesShadow` control participation;
  `fadeBehaviorNearPhysicalObjects` controls how it fades near real geometry.
- Behavior differs between `ARView` (iOS) and `RealityView`; shadows read more
  strongly under `ARView`.

## Image-Based Lighting

IBL takes an `EnvironmentResource` (an HDR environment map) and uses it for
ambient light and reflections.

**It takes two components to work.** `ImageBasedLightComponent` supplies the
light; every entity that should respond needs
`ImageBasedLightReceiverComponent` pointing at the entity that carries the
light. An entity with no receiver ignores IBL entirely - this is the usual
reason a "nothing changed" IBL bug appears.

```swift
let iblEntity = Entity()
iblEntity.components.set(ImageBasedLightComponent(source: .single(environment)))

model.components.set(ImageBasedLightReceiverComponent(imageBasedLight: iblEntity))
```

- Light direction comes from where the bright areas sit in the image. A small
  bright dot on a dark background reads as a directional sun.
- `intensityExponent` scales brightness; `inheritsRotation` (default `false`)
  makes the lighting turn with the entity.

## Environment Lighting Weight And Probes

- `EnvironmentLightingConfigurationComponent` carries a single
  `environmentLightingWeight` (default `1.0`) - how strongly real-world
  environment lighting affects the entity. Drive it to `0` for content that
  should look self-lit, or animate it when an entity crosses a portal into a
  different lighting environment.
- `VirtualEnvironmentProbeComponent` supplies reflection probes for virtual
  environments, built from `Probe(environment:intensityExponent:)` values via
  its `source`. Probes affect how materials reflect their surroundings; place
  them where the reflected content actually is.

For baked lighting and diffuse probes, see
[`lightmaps-and-probes.md`](lightmaps-and-probes.md). For per-light render-layer
masks and cascaded shadows added in visionOS 27, see
[`render-layers-and-shadows.md`](render-layers-and-shadows.md).

## Verifying

Lighting is asset-, exposure-, and hardware-dependent. Check on device before
concluding a look is right, and prefer a screenshot comparison over reasoning
about intensity values.
