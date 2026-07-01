# Internals

Reference for maintainers. How the wrappers map to the underlying
control block, the refcount protocol, the QSBR drain, and the multi-
threading model. If you're reading this, you're either fixing a bug
in `worldpointer.hpp` or extending it.

## Layout

### `WorldPtr<T>::Block`

```cpp
struct Block {
    std::atomic_size_t reference_count;   // 8 bytes
    void* next;                            // 8 bytes (intrusive retire list)
    T value;                               // sizeof(T), at offset 16
};
```

The wrappers (`Owning`, `Borrowed`, `Shared`) hold a single `T*
inner_` (8 bytes). `getBlock()` recovers the `Block*` from `inner_`
via `offsetof(Block, value)`:

```cpp
Block* getBlock() const noexcept {
    static_assert(std::is_standard_layout_v<Block>);
    return inner_
        ? reinterpret_cast<Block*>(
              reinterpret_cast<char*>(inner_) - offsetof(Block, value))
        : nullptr;
}
```

The static_assert is the **only** constraint on `T`: it must be
**standard-layout** so that `offsetof(Block, value)` is well-defined.
In practice this means `T` must have:

- All non-static data members with the same access control.
- No virtual functions, no virtual base classes.
- No multiple inheritance with non-empty bases.
- No reference members.

`std::string`, `std::vector`, and other STL containers ARE
standard-layout under MSVC's STL, libstdc++, and libc++ — the
`Mount`/`Outfit` migrations work. `Tile` (with virtual functions) is
NOT standard-layout — hence `PolyPtr`.

### `PolyPtr<T>::Header`

For polymorphic types, the control block is split:

```cpp
struct Header {
    std::atomic_size_t strong_refcount;   // 8 bytes
    std::atomic_size_t weak_refcount;     // 8 bytes
    void* next;                            // 8 bytes (intrusive retire list)
    const DeleterTable* deleter_table;     // 8 bytes
};

template <typename Concrete>
struct ConcreteBlock {
    Header header;                         // 32 bytes
    alignas(Concrete) std::byte storage[sizeof(Concrete)];
};
```

The wrappers carry `Header* + T*` (16 bytes). The `T*` may point
anywhere inside the value subobject (cross-type upcast adjusts it
via `static_cast`); the `Header*` is invariant under upcast.

`deleter_table` carries type-erased function pointers for
destructing the value and deallocating the block — needed because
the drain doesn't know the concrete type at call time:

```cpp
struct DeleterTable {
    void (*destroy_value)(Header*);
    void (*deallocate)(Header*);
};
```

One `DeleterTable` per `(Concrete, Allocator)` pair lives as a
constexpr static (`deleterTableFor<Concrete, Allocator>`); the
header stores a pointer to it.

## Refcount protocol

### WorldPtr — single refcount

The block has one counter: `reference_count`, initialised to 1 in
`Block::Block(args...)`.

- Each `Owning` / `Shared` holds 1 ref.
- Each `Borrowed` holds 0 refs.

Lifecycle:

```
make()                  → refcount = 1 (Owning holds it)
.share()                → refcount = 2 (Shared bumps existing block)
Shared copy             → refcount = 3
~Shared (2 copies)      → refcount = 1
Owning::~Owning         → retire-push (refcount UNCHANGED at 1)
quiescentState()        → decrementReferenceCount: 1 → 0 → destroy + dealloc
```

`Owning::~Owning` does NOT decrement — it only pushes to the retire
list. The decrement-and-maybe-destroy happens during the drain. That
delay is the QSBR window: any Borrowed that observed the value
during the tick can safely be promoted to a Shared (CAS bumps from
1 → 2) until the drain runs.

### PolyPtr — strong + weak

The header has two counters: `strong_refcount` and `weak_refcount`.

- Each `Owning` / `Shared` adds 1 to `strong_refcount`.
- Each `Weak` adds 1 to `weak_refcount`.
- The **strong group as a whole** adds 1 to `weak_refcount` while
  strong is > 0. This +1 is decremented in `quiescentState` when the
  strong group reaches 0.

The split lets a `Weak` survive past the value's destruction (block
memory alive until weak hits 0).

Initial state in `Owning::make`:

```cpp
block->header.strong_refcount.store(1, std::memory_order_relaxed);
block->header.weak_refcount.store(1, std::memory_order_relaxed);
```

Lifecycle:

```
make()                  → strong=1, weak=1
weak = owning.share()   → temp Shared bumps strong (→2),
                          Weak ctor bumps weak (→2),
                          temp Shared dies → strong = 1 again
.share() (returns Shared) → strong=2, weak=2
Shared dies             → strong=1 (still alive)
Owning::~Owning         → decrementStrong:
                            fetch_sub → strong=0 → retirePush
                          weak unchanged at 2
quiescentState()        → exchange retire list:
                            run destroy_value(header)
                              → ~T runs (Tile destructor etc.)
                            decrementWeak(header)
                              → fetch_sub → weak=1
                          Block memory ALIVE (Weak still observing)
Weak dies               → decrementWeak: 1 → 0 → deallocate block
```

The **CAS-loop** in `tryIncrementStrong` is what makes promotions
safe across the retire window:

```cpp
bool tryIncrementStrong(Header* h) noexcept {
    if (!h) return false;
    size_t cur = h->strong_refcount.load(std::memory_order_relaxed);
    while (cur != 0) {
        if (h->strong_refcount.compare_exchange_weak(
                cur, cur + 1, acq_rel, relaxed)) {
            return true;
        }
    }
    return false;     // strong already at 0 — block retired
}
```

A bare `fetch_add(1)` here would resurrect the block:
strong = 0 → 1, but the drain still runs `destroy_value` for it,
leaving a Shared pointing at destroyed memory (UAF). The CAS bails
out at `cur == 0` and returns null instead.

The five sites that go through `tryIncrementStrong`:

- `PolyPtr<T>::Borrowed::operator Shared()` / `.share()`
- `PolyPtr<T>::sharedDowncast_` (called by
  `static_pointer_cast_poly<Shared>`)
- `PolyPtr<T>::sharedDynamicDowncast_` (called by
  `dynamic_pointer_cast_poly<Shared>`)
- `PolyPtr<T>::Weak::lock()`
- `enable_borrowed_from_this<T>::sharedFromThis()`

WorldPtr has its own CAS-loop helper `Block::tryIncrementReferenceCount`
used only by `Borrowed::operator Shared()`. The other promotions in
WorldPtr (Shared copy ctor, Owning → Shared) hold guaranteed-alive
sources and use the bare `fetch_add` directly.

## QSBR drain

QSBR (Quiescent State-Based Reclamation) defers destructor execution
to a known "no reader can possibly hold a Borrowed" boundary — the
end of a dispatcher tick.

### WorldPtr drain

Per `(T, Allocator)`, in `WorldPtr<T>::quiescentState<Allocator>`:

```cpp
while (BlockAllocator<Allocator>::retirees != nullptr) {
    auto it = BlockAllocator<Allocator>::retirees;
    BlockAllocator<Allocator>::retirees = nullptr;
    while (it != nullptr) {
        auto next = static_cast<Block*>(it->next);
        Block::decrementReferenceCount<Allocator>(it);
        it = next;
    }
}
```

The outer `while` loops until the list is empty — because
destructors may push new retires (e.g., a Mount's dtor could drop
another Owning). The inner walk processes one snapshot of the list
at a time, atomically detaching it before iterating.

Single-threaded today: `retirees` is a plain `Block* inline static`
in `BlockAllocator`, not atomic. Push from `retire()`:

```cpp
block->next = BlockAllocator<Allocator>::retirees;
BlockAllocator<Allocator>::retirees = block;
```

Three lines, no synchronization. Fine while all retire-pushes
happen on the dispatcher thread. Multi-threaded WorldPtr would need
a CAS-based push like PolyPtr's.

### PolyPtr drain

The retire list is **global** (type-erased) and **atomic**, so
PolyPtr's `retirePush` is lock-free CAS:

```cpp
inline std::atomic<Header*> g_retirees { nullptr };

inline void retirePush(Header* h) noexcept {
    Header* old = g_retirees.load(std::memory_order_relaxed);
    do {
        h->next = old;
    } while (!g_retirees.compare_exchange_weak(
        old, h, std::memory_order_release, std::memory_order_relaxed));
}
```

The drain (`world_ptr_poly_detail::quiescentState`, called by
`polyPtrQuiescentState()`) snapshots the whole list with `exchange`:

```cpp
while (true) {
    Header* it = g_retirees.exchange(nullptr, std::memory_order_acquire);
    if (!it) break;
    while (it != nullptr) {
        auto next = it->next;
        it->deleter_table->destroy_value(it);   // ~T runs
        decrementWeak(it);                       // -1 from strong group
        it = next;
    }
}
```

The single `exchange` makes the drain itself safe under concurrent
pushes — pushes after the exchange go into a fresh list that the
next iteration of the outer `while` will process. No reader can
observe a partially-drained list because the snapshot is private to
the drain.

## Multi-threading model

Today: **single-threaded dispatcher**, period. The QSBR contract is
"a Borrowed never outlives a world tick", and the drain runs once
per tick on the dispatcher thread. Parallel tasks
(`TaskGroup::GenericParallel`, `WalkParallel`) are joined inside
`executeEvents` before the per-tick drain, so they may safely hold
Borrowed views; they must not retain them across the join.

The header comment at `worldpointer.hpp:63-67` documents:

> Since the game world is single-threaded for now, the quiescent
> states are always "global" and it's trivial for us to guarantee
> that a borrowed pointer never outlives a world tick. Once the game
> world becomes multi-threaded, we will need to synchronize the
> quiescent states across all threads, which is fairly trivial to
> do with epochs.

When the dispatcher becomes multi-threaded, the changes needed are:

1. **WorldPtr's retire push** must become a CAS-based push (matches
   PolyPtr today). The per-(T, Allocator) `retirees` head must be
   `std::atomic<Block*>`.
2. **QSBR coordination across threads.** Today the drain runs on
   the dispatcher thread immediately after the per-tick join. With
   independent tick boundaries per thread, an epoch counter is
   needed: each thread bumps its local epoch at quiescent points,
   and a block is safe to destroy only after every thread has
   observed an epoch strictly later than the retire-push epoch.
3. **Floor::setTile / setTileCache** need the exclusive lock the
   author commented out under the single-thread assumption.

The CAS-loop in PolyPtr's `tryIncrementStrong` is already
multi-thread safe. The "Borrowed → Shared returns null if expired"
contract is already documented and tested. The migrations'
boundary-crossing patterns (capture Position / use `Weak::lock()`)
are already correct.

So the multi-thread path is incremental: add atomic retire, add
epoch coordination, re-enable the locks. The wrapper APIs stay the
same.

## Why offsetof works for non-standard-layout types in practice

`Mount` and `Outfit` contain `std::string` members. On MSVC's STL,
libstdc++, and libc++, the `std::basic_string` template is
*technically* not required to be standard-layout (the C++ standard
leaves this implementation-defined), but the common implementations
ARE standard-layout — SSO is implemented with anonymous union of
standard-layout primitives, and the allocator is empty (EBO).

The compile-time `static_assert(is_standard_layout_v<Block>)` in
`Base::getBlock()` is the canary: if a future STL change made
`std::string` non-standard-layout under one of the supported
compilers, the assert would fire at compile time on that path —
caught before runtime.

Should that happen, the fix is to either:

- Move the type to `PolyPtr<T>` (type-erased header doesn't rely on
  offsetof); 16-byte wrapper instead of 8.
- Stop storing the offending member directly in `T` — use indirection
  through a `unique_ptr` or similar.

The current build matrix (MSVC release, MSVC debug, Linux GCC
release/debug, macOS Apple Clang release) all pass the
static_assert for `Mount`/`Outfit`.

## Auto-format and CI

This file ships with `.clang-format` rules; the project's
`autofix-ci` workflow runs `clang-format -i` and pushes any
formatting fixes back to the PR branch. The
`worldpointer_test.cpp` test additions in this migration triggered
the autofixer; the resulting style commit was folded into the
`test(utils)` commit during history cleanup.

If you edit `worldpointer.hpp` and want to preview the formatting:

```sh
clang-format -i src/utils/worldpointer.hpp
```

Same `clang-format` invocation the CI runs (DoozyX
clang-format-lint-action v17).

## Runtime guards and release builds

The wrapper methods (`operator*`, `operator->`, `useCount`, etc.)
use `assert(get() != nullptr)` to catch null-dereference at the
point of misuse. In **release builds** (`-DNDEBUG`), `assert` is a
no-op — the runtime guard simply doesn't exist, and a null
dereference becomes UB.

The death tests in `worldpointer_test.cpp` (`WorldPointerDeathTest`
and `PolyPointerDeathTest` fixtures) verify the asserts fire under
debug builds. They are **`#ifndef NDEBUG`-guarded** — release builds
exclude them entirely. Testing the no-op assert would be testing UB.

If a production deployment needs runtime null-check enforcement even
in release, the options are:

1. Build release with `-UNDEBUG` (asserts active project-wide; loses
   the perf optimization that release strips them for).
2. Replace `assert(...)` with a project-specific `WORLDPTR_ENFORCE`
   macro that always calls `std::abort()`. Costs a branch per
   dereference in the hot path.
3. Move the null-check into the type itself (return early instead
   of asserting) — changes API semantics: caller has to handle a
   silent no-op.

Currently neither (1) nor (2) is enabled. The static_assert
compile-time guards catch type-level misuse; runtime null deref is
a caller bug.

## Files

- [`src/utils/worldpointer.hpp`](../../../src/utils/worldpointer.hpp)
  — the entire API, ~1800 lines.
- [`src/utils/worldpointer.cpp`](../../../src/utils/worldpointer.cpp)
  — link target (the global PolyPtr retire-list head lives here).
- [`src/utils/CMakeLists.txt`](../../../src/utils/CMakeLists.txt)
  — adds both to the core library.
- [`src/lua/functions/lua_functions_loader.hpp`](../../../src/lua/functions/lua_functions_loader.hpp)
  — Lua boundary helpers.
- [`src/game/scheduling/dispatcher.cpp`](../../../src/game/scheduling/dispatcher.cpp)
  — per-tick `quiescentState` calls + post-loop final drain.
- [`tests/unit/utils/worldpointer_test.cpp`](../../../tests/unit/utils/worldpointer_test.cpp)
  — ~110 tests covering construction, refcount semantics, cross-type
  upcast / downcast, the mixin, Weak, drain, transparent hashers,
  static_assert guards, death tests.
