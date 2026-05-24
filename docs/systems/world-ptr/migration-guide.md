# Migration guide

How to port a `std::shared_ptr<T>`-based type to the affine pointer
model. The Mounts, Outfits, and Tile migrations in this repo follow
this exact recipe — refer to commits
`refactor(mounts)` / `refactor(outfits)` / `refactor(tile)` for the
worked diffs.

## Decision: which family?

Run through this checklist:

1. **Is `T` polymorphic?** (Has virtual functions, virtual
   inheritance, multiple inheritance, or is abstract.)
   - Yes → `PolyPtr<T>`.
   - No → continue.
2. **Does `T` need a `Weak` observer to break a refcount cycle?**
   (E.g., a child object that references back to its parent.)
   - Yes → `PolyPtr<T>`. (`WorldPtr` has no `Weak`.)
3. **Does the type need RTTI-checked downcasts?**
   - Yes → `PolyPtr<T>`.
4. Otherwise → `WorldPtr<T>`. 8 bytes per wrapper; simpler.

Mount and Outfit are plain final classes with `std::string` members
— they fit `WorldPtr`. Tile / Item / Cylinder need a polymorphic
hierarchy and a Weak for the Item↔Tile cycle — they need `PolyPtr`.

## The five steps

### 1. Define the alias triple in the storage class

```cpp
// Header where the storage type lives.
#include "utils/worldpointer.hpp"

class Mounts {
public:
    using MountAllocator = WorldPtr<Mount>::DefaultAllocator;
    using OwningMount    = WorldPtr<Mount>::Owning<MountAllocator>;
    using BorrowedMount  = WorldPtr<Mount>::Borrowed<MountAllocator>;
    // ...
};
```

For PolyPtr the aliases are slightly simpler (no `Allocator` on the
wrappers — it lives only on `Owning::make`):

```cpp
struct Floor {
    // Implicit — just use `PolyPtr<Tile>::Owning` etc. directly.
};
```

### 2. Replace the storage's value type

Before:

```cpp
phmap::parallel_flat_hash_set<std::shared_ptr<Mount>> mounts;
```

After:

```cpp
phmap::parallel_flat_hash_set<OwningMount, WorldPtrOwningHash<Mount>>
    mounts;
```

The transparent hash + equal means `find` / `erase` can still take
a raw `Mount*` or any wrapper as the lookup key.

For PolyPtr storage with mixed types, use
`PolyPtrTransparentHash<Base>` / `PolyPtrTransparentEqual<Base>`:

```cpp
phmap::flat_hash_map<
    PolyPtr<Tile>::Shared,
    std::weak_ptr<Container>,
    PolyPtrTransparentHash<Tile>,
    PolyPtrTransparentEqual<Tile>
> browseFields;
```

### 3. Migrate the constructors

`std::make_shared<T>(args...)` → `Owning::make(args...)` (non-poly)
or `make_poly<Concrete>(args...)` (poly):

```cpp
// Before:
mounts.emplace(std::make_shared<Mount>(id, clientId, name, /* ... */));

// After:
mounts.emplace(OwningMount::make(id, clientId, name, /* ... */));
```

For abstract bases use `make_poly`:

```cpp
// Before:
auto tile = std::make_shared<DynamicTile>(x, y, z);

// After:
PolyPtr<Tile>::Owning tile = make_poly<DynamicTile>(x, y, z);
// or, when storing as the derived type:
PolyPtr<DynamicTile>::Owning t = PolyPtr<DynamicTile>::Owning::make(x, y, z);
```

### 4. Migrate accessor return types

Getters that returned `std::shared_ptr<T>` should now return
`BorrowedT` (the zero-bump view). Callers will rarely need to change
their use sites — `Borrowed` exposes the same `->`, `*`, `bool`
surface.

```cpp
// Before:
std::shared_ptr<Mount> Mounts::getMountByID(uint8_t id) const;

// After:
BorrowedMount Mounts::getMountByID(uint8_t id) const;
```

Member functions that take `const std::shared_ptr<T> &` should
switch to either:

- `const T*` for read-only inspection (no refcount op needed at all).
- `BorrowedT` for transient reads that need the full wrapper.

Mounts went with `const Mount*`:

```cpp
// Before:
bool Player::hasMount(const std::shared_ptr<Mount> &mount) const;

// After:
bool Player::hasMount(const Mount* mount) const;
```

Callers convert at the site:

```cpp
auto mount = mounts->getMountByID(id);   // BorrowedMount
player->hasMount(mount.get());            // raw const Mount*
```

### 5. Wire the QSBR drain

The dispatcher must drain the retire list for every migrated type
once per tick. In
[`src/game/scheduling/dispatcher.cpp`](../../../src/game/scheduling/dispatcher.cpp)'s
`Dispatcher::init()` worker loop:

```cpp
while (!threadPool.isStopped()) {
    // ... executeEvents / mergeEvents / etc ...

    WorldPtr<Mount>::quiescentState<Mounts::MountAllocator>();
    WorldPtr<Outfit>::quiescentState<Outfits::OutfitAllocator>();
    polyPtrQuiescentState();     // single call drains all PolyPtr types

    // ...
}

// After the loop — final drain so destructors run on shutdown.
WorldPtr<Mount>::quiescentState<Mounts::MountAllocator>();
WorldPtr<Outfit>::quiescentState<Outfits::OutfitAllocator>();
polyPtrQuiescentState();
```

For a new WorldPtr-managed type: add a `quiescentState<TAllocator>()`
line in the in-loop and post-loop drains. Skip this step and your
type leaks until the dispatcher's `quiescentState` is called for
something else (it isn't — drains are per-T).

For PolyPtr types: no new line needed — the global retire list is
shared. `polyPtrQuiescentState()` handles every polymorphic type.

## Cross-cutting refactors

When the migrated type appears in cross-cutting code (Player member
functions, ProtocolGame, Game), you'll usually need to:

- Update **signatures** of methods that take/return the migrated
  type.
- Update **container types** that store references to the migrated
  type (use the transparent hasher / equal).
- Convert **call sites** that copy the storage's value (the storage
  is move-only now — copying it would not compile):

  ```cpp
  // Before — copies the entire vector of shared_ptrs:
  const auto outfits = Outfits::getInstance().getOutfits(player->getSex());

  // After — bind by const reference (move-only Owning can't be copied):
  const auto &outfits = Outfits::getInstance().getOutfits(player->getSex());
  ```

## Lua boundary

For each migrated type, the Lua bindings need to be updated to use
the affine helpers in `lua_functions_loader.hpp`:

```cpp
// Before:
Lua::pushUserdata<Mount>(L, mount);
Lua::setMetatable(L, -1, "Mount");

// After:
Lua::pushUserdataAffine<Mount>(L, mount.share());  // Borrowed → Shared
Lua::setMetatable(L, -1, "Mount");
```

For PolyPtr-managed types (Tile), use the poly variant which accepts
either Borrowed or Shared:

```cpp
Lua::pushUserdataPoly<Tile>(L, tile);   // ctor bumps from Borrowed
```

Class registration with `__gc` wired:

```cpp
// Before:
Lua::registerClass(L, "Mount", "", luaCreateMount);

// After:
Lua::registerAffineClass<Mount>(L, "Mount", "", luaCreateMount);

// PolyPtr:
Lua::registerPolyClass<Tile>(L, "Tile", "", luaCreateTile);
```

The affine / poly variants of `registerClass` wire the type-specific
`__gc` metamethod that destroys the Shared (decrementing the
storage's refcount) when Lua collects the userdata.

## Worked case: Mounts (from `refactor(mounts)`)

| File                                          | What changed                                           |
| --------------------------------------------- | ------------------------------------------------------ |
| `src/creatures/appearance/mounts/mounts.hpp` | Storage type → `parallel_flat_hash_set<OwningMount>`. Aliases. Getter returns `BorrowedMount`. |
| `src/creatures/appearance/mounts/mounts.cpp` | `make_shared<Mount>` → `OwningMount::make`. `clear()` retires every entry. |
| `src/creatures/players/player.{cpp,hpp}`     | `hasMount(const Mount*)`. Call sites do `.get()`.       |
| `src/lua/functions/creatures/player/mount_functions.cpp` | `pushUserdataAffine<Mount>`, `getUserdataAffine<Mount>`, `registerAffineClass<Mount>`. |
| `src/lua/functions/creatures/player/player_functions.cpp` | `luaPlayerHasMount` updated to receive a `BorrowedMount` and pass `.get()`. |
| `src/lua/functions/creatures/player/player_functions.hpp` | `PlayerFunctions::init` made public so the test fixture can call it. |
| `src/creatures/players/components/player_title.cpp` | `hasMount(mount.get())`. |
| `src/game/game.cpp`                          | `hasMount(mount.get())` at three sites; `Mounts::BorrowedMount {}` default-construct for ternary fallback. |
| `src/server/network/protocol/protocolgame.cpp` | `for (const auto &mount : getMounts())` (vs. copying); `hasMount(mount.get())`; one site builds a `vector<BorrowedMount>` of player-owned mounts. |
| `src/game/scheduling/dispatcher.cpp`         | Added `WorldPtr<Mount>::quiescentState<Mounts::MountAllocator>();` in the main loop + final drain. |

## Worked case: Tile (from `refactor(tile)`)

The Tile migration is the most invasive — 60+ files. Beyond the
basic recipe above, it adds:

- **Weak<Tile> in Item.m_parent and Creature.m_tile** to break the
  Item↔Tile cycle. Use `borrowIfAlive()` on read paths.
- **`PolyPtr<Tile>::Shared` in `browseFields` and `tilesToClean`**
  (game.hpp). Transparent hash lets find/erase accept a Borrowed
  directly.
- **`Tile::getCylinder()` bridge** — Tile no longer participates in
  `shared_ptr`, but the legacy Cylinder API hasn't been migrated yet.
  `getCylinder()` returns a `shared_ptr<Cylinder>` with a custom
  deleter that captures a `PolyPtr<Tile>::Shared`. Cost: 1 alloc +
  1 atomic per call, only paid at the boundary to un-migrated APIs.
- **`Game::internalMoveCreature` / `internalMoveItem` overloads** —
  Tile-typed versions promote to `getCylinder()` internally so the
  un-migrated Cylinder API doesn't need to be touched in this step.
- **Async dispatcher captures** — `Map::moveCreature` async branch,
  `Tile::safeCall`, monster's `addWalkEvent`, player task creation
  all switched from capturing Borrowed across the boundary to either
  pinning via `.share()` (with a null-check) or capturing a Position
  and re-resolving.

The diff is in `refactor(tile)` of this PR. Read it alongside this
guide.

## Reverting a migration

Each pair (`refactor(X) + test(X)`) is independently revertible:

```bash
git revert <test_X_sha> <refactor_X_sha>
```

The `dispatcher.cpp` cross-cutting means reverts are easiest in
**reverse topological order**:

1. `test(tile)` + `refactor(tile)` first.
2. `test(outfits)` + `refactor(outfits)`.
3. `test(mounts)` + `refactor(mounts)`.
4. `test(utils)` + `feat(utils)`.

Reverting an earlier migration while a later one still references
the dispatcher's drain calls will conflict (the post-Mount `dispatcher.cpp`
state expects `WorldPtr<Mount>` to exist; reverting Mounts while
Outfits/Tile still need the drain line would leave the file
broken). Revert in stack order.
