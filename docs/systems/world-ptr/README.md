# World Pointer (`WorldPtr<T>` / `PolyPtr<T>`)

An affine pointer pair built on top of intrusive ref-counting, designed
to replace `std::shared_ptr` on the hot read paths of the game world.
The legacy `shared_ptr` stays at the boundary (Lua, network) — the
affine layer sits above it so atomic refcount ops are paid only when a
reference LEAVES the world, not on every traversal.

Header: [`src/utils/worldpointer.hpp`](../../../src/utils/worldpointer.hpp)
Tests: [`tests/unit/utils/worldpointer_test.cpp`](../../../tests/unit/utils/worldpointer_test.cpp)

## When you need this

You are about to write `std::shared_ptr<T>` for a long-lived game-world
object that:

- Lives in a storage container (`Floor`, `Map`, `Mounts`, …), and
- Gets handed out frequently to read paths (`getTile`, `getMount`,
  iteration over a collection), and
- Each hand-out paid an atomic refcount increment + decrement under the
  legacy design.

`WorldPtr` / `PolyPtr` cut that to **zero atomic ops per read** by
splitting ownership into three (or four) wrapper types: one **Owning**
holder lives in storage, callers receive non-owning **Borrowed** views,
and **Shared** pinning only happens at the world boundary (Lua,
network, deferred dispatcher events). For polymorphic hierarchies
there's a fourth: **Weak**, used to break refcount cycles (Item ↔ Tile,
Creature ↔ Tile).

## Which family to pick

| Property                          | `WorldPtr<T>`            | `PolyPtr<T>`              |
| --------------------------------- | ------------------------ | ------------------------- |
| Wrapper size                      | 8 bytes (one `T*`)       | 16 bytes (`Header*`, `T*`)|
| Block memory                      | One alloc, value inline  | One alloc, value inline   |
| Supports abstract `T` / virtual inheritance | ❌              | ✅                        |
| Supports polymorphic up/downcast  | ❌                       | ✅                        |
| Has a `Weak<T>` observer          | ❌                       | ✅                        |
| Drain                             | Per-`(T, Allocator)`     | Single global             |

Rule of thumb:

- Non-polymorphic final value types (`Mount`, `Outfit`, configs) →
  **`WorldPtr<T>`**. Smaller, simpler.
- Anything that needs RTTI, virtual inheritance, or a Weak (Item, Tile,
  Cylinder hierarchy) → **`PolyPtr<T>`**.

If you're not sure, **`AnyPtr<T>`** auto-selects via
`is_polymorphic_v<T>`.

## Navigation

- [API reference](api-reference.md) — every public type and free
  function, with signatures, semantics, and worked examples.
- [Usage guide](usage-guide.md) — patterns, best practices, common
  mistakes, and the rules for crossing thread / tick boundaries.
- [Migration guide](migration-guide.md) — how to port a `shared_ptr<T>`
  type to the affine model, walking through the Mounts / Outfits / Tile
  case studies in this repo.
- [Internals](internals.md) — refcount model, QSBR drain protocol,
  intrusive layout, why the type-erased header is needed for
  polymorphism, multi-threading model.

## Quick example

A non-polymorphic value type stored in a hash set:

```cpp
#include "utils/worldpointer.hpp"

struct Mount {
    uint8_t id;
    std::string name;
    /* ... */
};

class Mounts {
public:
    using OwningMount   = WorldPtr<Mount>::Owning<>;
    using BorrowedMount = WorldPtr<Mount>::Borrowed<>;

    // Storage holds the single Owning; callers get a zero-bump Borrowed.
    bool loadFromXml() {
        // ...
        mounts.emplace(OwningMount::make(id, name, /* ... */));
        return true;
    }

    BorrowedMount getMountByID(uint8_t id) const {
        for (const auto &owning : mounts) {
            if (owning->id == id) {
                return owning.borrow();  // zero atomic ops
            }
        }
        return {};
    }

private:
    phmap::parallel_flat_hash_set<
        OwningMount,
        WorldPtrOwningHash<Mount>
    > mounts;
};
```

A read site:

```cpp
// Inside game logic — no atomic ops, no pinning.
if (auto mount = mounts.getMountByID(42)) {
    player->mount(mount->id);
}
```

Crossing into Lua:

```cpp
// Boundary: Lua keeps a Shared so the Mount survives reload.
Lua::pushUserdataAffine<Mount>(L, mount.share());  // 1 atomic op
```

That's the entire shape. See the [usage guide](usage-guide.md) for the
polymorphic (`PolyPtr<Tile>`) and Weak-observer patterns.

## Status

Single-threaded by design today. The QSBR drain runs once per
dispatcher tick. Multi-threaded dispatch requires epoch coordination
that is not yet implemented — see
[internals.md](internals.md#multi-threading-model).
