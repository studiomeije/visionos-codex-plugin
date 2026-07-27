# MeshInstancesComponent


## Overview

Renders many instances of a mesh efficiently. This component allows you to render multiple copies of the same mesh with different transforms, which is much more efficient than creating separate entities for each instance. Ideal for rendering crowds, forests, particle-like objects, or any scenario where you need many copies of the same geometry.

## When to Use

- Rendering many copies of the same mesh (trees, characters, objects)
- Creating particle-like effects with geometry
- Optimizing performance for repeated geometry
- Building crowds or large collections of objects
- Instancing geometry for performance

## How to Use

### Basic Setup

`MeshInstancesComponent` takes a `LowLevelInstanceData` buffer of transforms.
It carries no `materials:` argument - materials come from the entity's
`ModelComponent`.

```swift
import RealityKit

// Allocate the instance buffer and fill in per-instance transforms
let data = try LowLevelInstanceData(instanceCount: 100)
data.withMutableTransforms { transforms in
    for i in 0..<transforms.count {
        transforms[i] = Transform(
            translation: [Float(i) * 0.5, 0, 0]
        ).matrix
    }
}

let instances = try MeshInstancesComponent(mesh: meshResource, instances: data)
entity.components.set(instances)

// Materials still come from the model component on the same entity
entity.components.set(ModelComponent(mesh: meshResource, materials: [material]))
```

### Updating Instance Transforms

`LowLevelInstanceData` is a reference type, so transforms can be rewritten in
place without rebuilding the component.

```swift
data.replaceMutableTransforms { transforms in
    for i in 0..<transforms.count {
        transforms[i] = Transform(
            translation: [Float(i) * 0.5, sin(time + Float(i)), 0]
        ).matrix
    }
}
```

### MeshInstanceCollection Is A Different Type

`MeshInstanceCollection` holds `MeshResource.Instance` values for
instancing *inside a mesh resource*, and it uses `insert(_:)` / `update(_:)` /
`remove(id:)` - there is no `add(_:)`.

```swift
var collection = MeshInstanceCollection()
collection.insert(
    MeshResource.Instance(id: "tree-0", model: "tree", at: .init(diagonal: .one))
)
```

## Key Properties

- `mesh: MeshResource` - The mesh to instance
- `materials: [Material]` - Materials to apply to instances
- `instances: MeshInstanceCollection` - Collection of instance transforms

## Important Notes

- Much more efficient than creating separate entities
- All instances share the same mesh and materials
- Each instance can have a different transform
- Ideal for static or infrequently updated instances

## Best Practices

- Use for rendering many copies of the same geometry
- Prefer over individual entities for performance
- Use appropriate instance counts for your target device
- Consider LOD (Level of Detail) for very large instance counts
- Update instance collections efficiently when needed

## Related Components

- `ModelComponent` - Alternative for single mesh rendering
- `MeshResource` - The mesh resource being instanced
