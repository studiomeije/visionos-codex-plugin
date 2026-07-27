---
name: realitykit-entities-scenes
description: Build and debug the RealityKit scene graph on visionOS 27 - loading entities from assets, RealityView setup, making entities interactive with input targets, gestures, hover and manipulation, accessibility metadata, SwiftUI attachments and popovers, in-world text, image and video presentation, anchoring and spatial tracking, portals and worlds, environment blending, synchronization, and the USDStage bridge. Use when the task is placing, loading, structuring, or interacting with entities rather than their materials, motion, or sound.
---

# RealityKit Entities and Scenes

Core scene-graph work: what exists, where it sits, and how a person interacts
with it. Appearance goes to `realitykit-rendering-materials`, motion to
`realitykit-animation-physics`, sound to `realitykit-audio-spatial`.

## Workflow

1. Establish ownership first: which entity owns this content, and which layer
   mutates it. Scene mutation belongs in `RealityView` make/update closures,
   event handlers, or a registered system - never in SwiftUI `body`.
2. Load assets asynchronously; do not block the main actor.
3. Prefer a documented component over custom ECS. Check
   `realitykit-visionos-developer` component selection when unsure.
4. Load only the reference that matches the task.
5. Build to verify before reporting done.

## Load References When

| Reference | When to Use |
|---|---|
| [`references/entity-loading-and-stored-entities.md`](references/entity-loading-and-stored-entities.md) | Load named stored entities, file URLs, package-bundled assets, USD/USDZ, `.reality`, or Reality Composer Pro output. |
| [`references/interaction-and-accessibility.md`](references/interaction-and-accessibility.md) | Make an entity respond to input: collision plus input target, manipulation vs gesture, hover feedback, VoiceOver metadata. |
| [`references/attachments-and-presentation.md`](references/attachments-and-presentation.md) | Put SwiftUI, text, images, or video into the scene: view attachments, popovers, `ImagePresentationComponent`, `VideoPlayerComponent`. |
| [`references/anchoringcomponent.md`](references/anchoringcomponent.md) | Anchor content to hands, head, planes, images, objects, or the world origin. |
| [`references/spatialtrackingsession.md`](references/spatialtrackingsession.md) | Decide whether RealityKit-managed tracking is enough, and request scene-understanding capabilities. |
| [`references/entity-structure-and-lifecycle.md`](references/entity-structure-and-lifecycle.md) | Attach entities to pins or joints, billboard content, mark entities transient, synchronize across participants, dock system video, read ARKit anchor data, use scene understanding. |
| [`references/portals-and-worlds.md`](references/portals-and-worlds.md) | Compose portals, world roots, portal crossing, and occlusion by real surroundings. |
| [`references/portal-volumes-and-accessory-anchoring.md`](references/portal-volumes-and-accessory-anchoring.md) | visionOS 27 volumetric portal clipping/crossing and accessory anchoring. |
| [`references/usdstagecomponent.md`](references/usdstagecomponent.md) | Render a live USDKit stage inside RealityKit, or export entity hierarchies to USD. |

For exact signatures, property lists, enum cases, and availability, query the
installed SDK with `apple-sdk-lookup` rather than relying on recall.

## Cross-Routing

- Use `realitykit-visionos-developer` when the owner is genuinely unclear or the
  task spans several RealityKit areas.
- Use `realitykit-rendering-materials` for meshes, materials, lights, shadows,
  cameras, and render cost.
- Use `realitykit-animation-physics` for motion, collision shapes as physics,
  character control, particles, and cloth.
- Use `realitykit-ecs-systems` when behavior needs a custom component or a
  per-frame system across many entities.
- Use `usdkit-runtime-developer` for Swift USDKit stage authoring; this skill
  covers only the RealityKit-side `USDStageComponent` bridge.
- Use `spatial-swiftui-developer` for windows, volumes, immersive space
  lifecycle, and SwiftUI-side layout.
- Use `arkit-visionos-developer` when you need the raw provider streams rather
  than RealityKit-managed anchoring.

## Guardrails

- Use `RealityView`; `ARView` is not available on visionOS.
- Keep entity and asset loading asynchronous and off the main actor.
- Mutate RealityKit content through `RealityView` closures, events, or systems -
  not from SwiftUI body code.
- Register custom components and systems once at startup, before any scene or
  asset that references them loads.
- An entity is not interactive without both `CollisionComponent` and
  `InputTargetComponent`. Check that pair before debugging anything else.
- Prefer `ManipulationComponent.configureEntity(...)` when built-in direct
  manipulation fits.
- Anything interactive needs `AccessibilityComponent` metadata.
- Verify written Swift by building. Many components here are visionOS 27 beta
  API; confirm the symbols exist in the installed SDK by compiling, not from
  memory. Route the build through `build-run-debug`.
- Apply `coding-standards-enforcer` to Swift you write here: Swift 6.2 strict
  concurrency, actor isolation, `Sendable`, and `@Observable` ownership.

## Skills In Other Plugins

These routes live in other plugins from this marketplace. If one is not
installed, say so plainly and continue with the best available path rather
than stalling or inventing the missing skill's guidance.

| Skill | Plugin |
|---|---|
| `arkit-visionos-developer` | Build visionOS 27 apps |
| `build-run-debug` | Build visionOS 27 apps |
| `coding-standards-enforcer` | Build visionOS 27 apps |
| `spatial-swiftui-developer` | Build visionOS 27 apps |

## Output Expectations

Provide the entity/ownership model chosen, which references were used, the
component path taken, the main constraint or pitfall, and the build verification
result.
