# Usage guide

Patterns, best practices, and common mistakes. For exhaustive type
signatures see the [API reference](api-reference.md).

## Picking the right wrapper at each call site

Think of the three (four with `Weak`) wrappers as a **boundary
declaration**:

| Wrapper      | What it means                                        | Cost     |
| ------------ | ---------------------------------------------------- | -------- |
| `Owning`     | "I am storage. There is exactly one of me."          | 1 alloc  |
| `Borrowed`   | "Transient read inside the current tick."            | 0 atomic |
| `Shared`     | "Pin this value across the tick / thread boundary."  | 1 atomic |
| `Weak`       | "Observe without pinning. May expire."               | 0 atomic |

The default at every call site should be **`Borrowed`**. Promote to
`Shared` only when crossing a tick or thread boundary; promote to
`Weak` only when breaking a refcount cycle.

```cpp
// ✅ DO: function arg, return value, local — Borrowed by default.
PolyPtr<Tile>::Borrowed Map::getTile(Position pos) const;
void someAlgorithm(PolyPtr<Tile>::Borrowed tile);
auto tile = floor->getTile(x, y);

// ❌ DON'T: copy a Shared around just because it's familiar from shared_ptr.
PolyPtr<Tile>::Shared Map::getTile(Position pos) const;       // bumps refcount per call
void someAlgorithm(const PolyPtr<Tile>::Shared &tile);        // requires the caller to have one
```

### When you need a Shared

- **Capturing into a deferred dispatcher event** (lambda runs in the
  next tick, after the current tick's QSBR drain):

  ```cpp
  g_dispatcher().addEvent(
      [pin = borrowed.share()] {
          if (!pin) return;            // share() may now fail — check!
          pin->doSomething();
      },
      "deferred work"
  );
  ```

- **Lua userdata** — Lua holds onto the Shared until its `__gc` fires
  on GC. The Shared participates in the storage's refcount, so a
  Lua-held value survives `reload()`.

  ```cpp
  Lua::pushUserdataPoly<Tile>(L, tile);            // Borrowed → Shared via ctor
  Lua::pushUserdataAffine<Mount>(L, mount.share()); // Owning → Shared via .share()
  ```

- **Storage inside a hash container** keyed by identity:

  ```cpp
  std::unordered_set<
      PolyPtr<Tile>::Shared,
      PolyPtrTransparentHash<Tile>,
      PolyPtrTransparentEqual<Tile>
  > tilesToClean;
  ```

  The transparent hasher lets `find(borrowed_tile)` work without
  paying a `.share()` atomic.

### When you need a Weak

- **Item.m_parent observing Tile**: Tile owns its `items` vector
  (`shared_ptr<Item>`); if Item kept a strong ref back to Tile, the
  pair pins each other forever (refcount cycle). Item.m_parent is a
  `PolyPtr<Tile>::Weak`. Inside `Item::getTile()`:

  ```cpp
  PolyPtr<Tile>::Borrowed Item::getTile() const {
      return m_parent.borrowIfAlive();    // 1 atomic LOAD
  }
  ```

- **Creature.m_tile**: same shape. Creature observes its current
  tile via Weak.

- **External cache / index** that doesn't want to extend lifetime —
  e.g. a debugger introspection table that wants to display all
  known tiles without keeping any alive.

## Crossing boundaries

### Inside the current tick

`Borrowed` is sufficient. The dispatcher's QSBR drain happens
**after** all of a tick's events have run, so any Borrowed observed
within the tick is valid for the rest of it. Pass it around freely,
copy it, store it in locals.

### Across the dispatcher boundary (`addEvent` / `addWalkEvent`)

The deferred lambda runs **next tick**, after the current tick's
drain. A captured Borrowed may by then be observing a destroyed
value. **Use `.share()` or `.lock()` instead** and check the
result:

```cpp
// ❌ DON'T:
g_dispatcher().addEvent(
    [tileBorrowed] {              // captured Borrowed — may be stale
        tileBorrowed->doStuff();
    }, "ctx"
);

// ✅ DO (for PolyPtr — recommended):
if (auto pin = tileBorrowed.share()) {
    g_dispatcher().addEvent(
        [pin] {
            pin->doStuff();        // pin is a Shared — value alive
        }, "ctx"
    );
}

// ✅ DO (alternative): capture identity and re-resolve.
g_dispatcher().addEvent(
    [pos = tile->getPosition()] {
        if (auto fresh = g_game().map.getTile(pos)) {
            fresh->doStuff();
        }
    }, "ctx"
);
```

The re-resolve pattern is preferred when the object's identity is
naturally addressable (a Position, an ID) — it avoids holding a
refcount across the boundary. The `.share()` pattern is preferred
when the object is the only handle you have.

### Across thread boundaries

Today the dispatcher is single-threaded. The QSBR drain runs once
per tick on the dispatcher thread. Parallel tasks
(`TaskGroup::GenericParallel`) ARE joined before the drain in the
same tick, so they may safely hold Borrowed views.

**Do not** stash a Borrowed in a thread-local cache or a static
across-tick singleton. The lifetime contract is one tick only.

When the dispatcher becomes multi-threaded (epoch-based QSBR), the
contract may extend across coordinating threads but the general
rule — "Borrowed is tick-bound, use Shared/Weak to extend" — still
holds.

## Common patterns

### 1. Storage container with affine values

The storage's value type is `Owning<T>`. The container is move-only
through the Owning, but transparent hashing lets lookup go through
Borrowed / raw pointer.

```cpp
class Mounts {
    using OwningMount   = WorldPtr<Mount>::Owning<>;
    using BorrowedMount = WorldPtr<Mount>::Borrowed<>;

    phmap::parallel_flat_hash_set<
        OwningMount,
        WorldPtrOwningHash<Mount>
    > mounts;

public:
    bool loadFromXml() {
        for (auto &element : parsedXml) {
            mounts.emplace(OwningMount::make(element.id, /* ... */));
        }
        return true;
    }

    void reload() {
        mounts.clear();                  // each Owning::~ retires its block
    }

    BorrowedMount getMountByID(uint8_t id) const {
        for (const auto &m : mounts) {   // iteration over Owning — zero refcount work
            if (m->id == id) return m.borrow();
        }
        return {};
    }
};
```

### 2. Polymorphic storage (Tile)

```cpp
// Floor.tiles is std::pair<PolyPtr<Tile>::Owning, const BasicTile*>[N][N]
struct Floor {
    PolyPtr<Tile>::Borrowed getTile(uint16_t x, uint16_t y) const {
        std::shared_lock lock(mutex);
        return tiles[x & SECTOR_MASK][y & SECTOR_MASK].first;
        // Owning → Borrowed implicit conversion is zero-cost.
    }

    void setTile(uint16_t x, uint16_t y, PolyPtr<Tile>::Owning tile) {
        std::scoped_lock lock(mutex);    // exclusive — torn read otherwise
        tiles[x & SECTOR_MASK][y & SECTOR_MASK].first = std::move(tile);
        // Move-assign drops the old Owning → retire push.
    }
};
```

Create via `make_poly<Concrete>`:

```cpp
PolyPtr<Tile>::Owning t = make_poly<DynamicTile>(x, y, z);
floor->setTile(x, y, std::move(t));
```

The cross-type construction works because Owning has a templated
rvalue ctor `Owning<Base>::Owning(Owning<Derived> &&)`.

### 3. Breaking cycles with Weak

```cpp
class Item {
    PolyPtr<Tile>::Weak m_parent;        // observes, doesn't pin

public:
    void setParent(PolyPtr<Tile>::Borrowed tile) {
        m_parent = tile;                  // explicit Weak(Borrowed) ctor
    }

    PolyPtr<Tile>::Borrowed getParent() const {
        return m_parent.borrowIfAlive();  // null if tile gone
    }
};
```

The dispatcher drain destroys the Tile (and its `items` vector)
once nothing else pins it. Each Item's Weak then sees `expired()`,
and the Tile's storage block frees when all Weaks die.

### 4. Lua boundary

```cpp
// Get the mount (Borrowed), then push as Shared into Lua's userdata.
auto mount = g_game().mounts.getMountByID(id);
if (!mount) {
    lua_pushnil(L);
    return 1;
}
Lua::pushUserdataAffine<Mount>(L, mount.share());

// Polymorphic version for Tile:
auto tile = g_game().map.getTile(pos);
if (tile) {
    Lua::pushUserdataPoly<Tile>(L, tile);   // ctor takes Borrowed
}
```

Inside the Lua function reading the userdata:

```cpp
auto* rawMount = Lua::getUserdataAffine<Mount>(L, 1, "Mount");
if (!rawMount) {
    lua_pushnil(L);
    return 1;
}
// rawMount is valid for the duration of the Lua call — the userdata's
// Shared keeps the block alive.
```

### 5. Pinning `this` from within a method

For PolyPtr-managed types that need to capture `this` into a
deferred lambda, inherit from `enable_borrowed_from_this<T>`:

```cpp
class Tile : public Cylinder, public enable_borrowed_from_this<Tile> {
public:
    void safeCall(std::function<void(Borrowed)> &&action) const {
        auto self = const_cast<Tile*>(this)->borrowedFromThis();
        if (g_dispatcher().context().isAsync()) {
            auto pin = self.share();
            if (!pin) return;             // self gone — drop the work
            g_dispatcher().addEvent(
                [pin, action = std::move(action)] {
                    action(pin);
                }, "Tile::safeCall"
            );
        } else {
            action(self);                  // sync — caller's stack pins
        }
    }
};
```

`make_poly<DerivedTile>(...)` automatically wires the mixin's
`poly_header_`; stack-allocated Tiles will see
`borrowedFromThis()` return an empty Borrowed (the mixin's wiring
helper SFINAEs out for non-`make_poly` construction).

## Anti-patterns

### ❌ Storing a Borrowed past the current tick

```cpp
class SomeCache {
    PolyPtr<Tile>::Borrowed cached;   // ❌ NEVER

    void update(PolyPtr<Tile>::Borrowed tile) {
        cached = tile;                 // ❌ cached may dangle after drain
    }
};
```

Use `Weak<Tile>` instead. Then `cached.borrowIfAlive()` returns a
fresh Borrowed (or null) each query.

### ❌ Trying to construct a Shared from a raw pointer

```cpp
T* raw = /* ... */;
PolyPtr<T>::Shared s(raw);            // ❌ does not compile — by design
```

There is no public `Shared(T*)` constructor. The affine pipeline
requires going through an `Owning` first:

```cpp
auto owning = PolyPtr<T>::Owning::make(/* args */);
auto s = owning.share();               // ✅
```

If the value already lives in storage, get a Borrowed from the
storage's accessor and promote that:

```cpp
auto borrowed = storage.get(key);     // Borrowed
auto s = borrowed.share();             // ✅ Borrowed → Shared
```

### ❌ Ignoring the null return from `.share()`

After the CAS-loop fix, `Borrowed::share()` / `sharedFromThis()` /
`dynamic_pointer_cast_poly` can all return a null Shared (when the
source block was retired between observation and the promotion
call). Treat it like `std::weak_ptr::lock()`:

```cpp
auto pin = borrowed.share();
if (!pin) {
    return;                            // value gone — bail
}
pin->doStuff();
```

In single-threaded dispatcher today, the null path is unreachable
in practice, but multi-threaded dispatch will reach it.

### ❌ Capturing `Borrowed` into `createPlayerTask` / `addWalkEvent`

Player tasks run with explicit delays (hundreds of ms). The
captured Borrowed will outlive its source by many ticks. Capture
the **Position** (or any stable identity) instead, and re-resolve
inside the lambda:

```cpp
// ❌ DON'T
g_dispatcher().addWalkEvent(
    [tile = map.getTile(pos)] { tile->doStuff(); }
);

// ✅ DO
g_dispatcher().addWalkEvent(
    [pos] {
        if (auto fresh = g_game().map.getTile(pos)) {
            fresh->doStuff();
        }
    }
);
```

### ❌ `Weak(Borrowed)` implicit

The constructor is explicit on purpose — an implicit Borrowed → Weak
conversion would let you stash tick-bound observations in long-lived
state silently. Always use direct-init when you intend a Weak from a
Borrowed:

```cpp
PolyPtr<Tile>::Weak w = tile.borrow();      // ❌ does not compile
PolyPtr<Tile>::Weak w(tile.borrow());        // ✅ explicit opt-in
```

### ❌ Forgetting `quiescentState`

If a type is migrated to `WorldPtr<T>` but no `quiescentState<T>()`
call is added to the dispatcher's per-tick loop, the retire list
grows unbounded. Every drop becomes a memory leak until the next
drain (which never comes).

Check `src/game/scheduling/dispatcher.cpp` after adding a new
WorldPtr-managed type — add the drain call alongside `Mount` /
`Outfit`.

PolyPtr is easier: the **global retire list is shared**, so one
`polyPtrQuiescentState()` call drains every polymorphic type at
once.

### ❌ Manually retargeting `header_` / `value_` on a wrapper

The `Base` class exposes `header_` and `value_` as public to allow
cross-type constructors to read them without a maze of friend
declarations. They are marked "Treat as internal — direct mutation
breaks invariants" in the source. Don't.

The static_assert tests in `worldpointer_test.cpp` enforce that the
mixin's `poly_header_` is private (the mixin DOES hide it). The
`Base::header_`/`value_` are a deliberate trade-off.

## Static-assert and death-test diagnostics

When the API's compile-time guards trip, the failure modes look like:

| Symptom                              | Likely cause                                  |
| ------------------------------------ | --------------------------------------------- |
| `Owning is move-only` static_assert  | You're copying an Owning. Use `std::move()`.  |
| Block(Args&&...) `requires` fail     | You're calling `Block(some_block)` directly. Don't; use `Owning::make`. |
| No matching constructor for `Shared` | Trying to make `Shared(T*)`. Go through `Owning::make`. |
| `Weak(Borrowed)` does not compile    | Implicit conversion attempted. Use direct-init. |

Death tests in `tests/unit/utils/worldpointer_test.cpp` (`WorldPointerDeathTest`
and `PolyPointerDeathTest` fixtures) verify the runtime asserts on
null dereference. They run only in debug builds (`#ifndef NDEBUG`)
because release strips `assert()`. See
[internals.md](internals.md#runtime-guards-and-release-builds)
for the rationale.

## Performance characteristics

| Operation                    | WorldPtr      | PolyPtr       |
| ---------------------------- | ------------- | ------------- |
| `Owning::make(args...)`      | 1 alloc       | 1 alloc       |
| `Borrowed::Borrowed(const Borrowed&)` | 0 atomic | 0 atomic |
| `Borrowed::operator->()` / `operator*()` | 0 atomic | 0 atomic |
| `Owning::borrow()`           | 0 atomic       | 0 atomic       |
| `Owning::share()` / `Borrowed::share()` | 1 atomic ADD / 1 CAS | 1 CAS |
| `Shared::Shared(const Shared&)` | 1 atomic ADD | 1 atomic ADD |
| `Shared::~Shared`            | 1 atomic SUB  | 1 atomic SUB  |
| `Owning::~Owning`            | retire-push (no atomic) | 1 atomic SUB + retire-push if 0 |
| `Weak::expired()` / `borrowIfAlive()` | n/a    | 1 atomic LOAD |
| `Weak::lock()`               | n/a            | 1 CAS         |
| `Weak::Weak(const Weak&)`    | n/a            | 1 atomic ADD (weak) |
| `quiescentState()`           | one drain per (T, Allocator) | one global drain |

The `Tile::getCylinder()` bridge to legacy `shared_ptr<Cylinder>`
APIs costs **1 alloc + 1 atomic ADD per call** — that's the price of
the custom deleter that pins via `Shared` for the entire shared_ptr
lifetime. Avoid it on hot paths; use `Borrowed` / `PolyPtr<Tile>` end
to end where possible.
