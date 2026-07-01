# API reference

Every public type, member function, and free function exposed by
[`src/utils/worldpointer.hpp`](../../../src/utils/worldpointer.hpp).
Where two type families (`WorldPtr<T>` and `PolyPtr<T>`) provide the
same operation, they are listed side by side.

For higher-level usage patterns see the [usage guide](usage-guide.md).

## `WorldPtr<T>` — intrusive 8-byte wrapper

`WorldPtr<T>` is a placeholder struct, not instantiable. It carries
the family of inner types:

```cpp
WorldPtr<T>::Owning<Allocator>
WorldPtr<T>::Borrowed<Allocator>
WorldPtr<T>::Shared<Allocator>
WorldPtr<T>::DefaultAllocator    // std::allocator<Block>
WorldPtr<T>::Block               // internal — control block + value
WorldPtr<T>::BlockAllocator<Allocator>
```

The `Allocator` template parameter defaults to
`std::allocator<Block>`. All four wrappers are **standard-layout, 1
pointer wide** — they hold only a `T*` (the value pointer); the
control block is recovered from it via
`offsetof(Block, value)`.

### `WorldPtr<T>::Owning<Allocator>`

Move-only holder. One Owning per object, ever. The affine invariant
the API enforces.

```cpp
class Owning {
    Owning();                                    // empty (null)
    Owning(std::nullptr_t);                      // explicit
    Owning(Owning &&) noexcept;                  // move ctor
    Owning &operator=(Owning &&) noexcept;       // move-assign retires old
    Owning &operator=(std::nullptr_t) noexcept;  // == reset()

    Owning(const Owning &) = delete;             // copy DELETED — affine
    Owning &operator=(const Owning &) = delete;

    template <typename... Args>
    static Owning make(Args &&... args);         // ONLY entry point

    operator Shared<Allocator>() const noexcept; // promote: +1 atomic
    operator Borrowed<Allocator>() const noexcept; // demote: 0 atomic
    Shared<Allocator> share() const noexcept;    // == operator Shared
    Borrowed<Allocator> borrow() const noexcept; // == operator Borrowed

    void reset() noexcept;                        // retire + null

    T* get() const noexcept;
    T &operator*() const noexcept;                // asserts non-null
    T* operator->() const noexcept;               // asserts non-null
    explicit operator bool() const noexcept;
    bool operator==(const Owning &) const noexcept;  // affine identity
    bool operator==(std::nullptr_t) const noexcept;
};
```

**`make(args...)`** is the only way to create an Owning. It allocates
a `Block { atomic refcount; void* next; T value; }`, in-place
constructs the value with `args...`, and returns the Owning. The
control block is co-located with the value — one heap allocation per
object.

**`operator Shared`** / **`share()`** bumps the existing block's
refcount by one (1 atomic ADD) and returns a Shared. Use to pin a
reference past the current tick (Lua userdata, deferred dispatcher
event, network message).

**`operator Borrowed`** / **`borrow()`** returns a non-bumping view
(zero atomic ops). Use for transient reads inside the current tick.

**`reset()`** retires the value (pushes the block to the
per-`(T, Allocator)` retire list) and clears the local pointer. The
value destructor does NOT run inline — it runs at the next
`quiescentState()`. Same semantics as `operator=(nullptr)`.

**`operator==(Owning&)`** compares pointee identity. Because the
affine invariant guarantees at most one Owning per pointee, distinct
non-null Ownings are never equal. A debug-only assert enforces this
invariant.

### `WorldPtr<T>::Borrowed<Allocator>`

Non-owning view. Copyable. Zero atomic ops on construction, copy, or
access.

```cpp
class Borrowed {
    Borrowed();
    Borrowed(std::nullptr_t);              // explicit
    Borrowed(const Borrowed &) = default;
    Borrowed(Borrowed &&) = default;
    Borrowed &operator=(const Borrowed &) = default;
    Borrowed &operator=(Borrowed &&) = default;

    operator Shared<Allocator>() const noexcept;   // CAS-loop promote
    Shared<Allocator> share() const noexcept;      // == operator Shared

    T* get() const noexcept;
    T &operator*() const noexcept;                 // asserts non-null
    T* operator->() const noexcept;
    explicit operator bool() const noexcept;
    bool operator==(const Borrowed &) const noexcept;
    bool operator==(std::nullptr_t) const noexcept;
};
```

**`share()` / `operator Shared`** uses a **CAS-loop** that refuses to
bump the strong refcount if it has already reached zero (i.e. the
source Owning was destroyed and the block is in the retire list
pending drain). In that case it returns a **null Shared**. Callers
must check the result:

```cpp
if (auto pinned = borrowed.share()) {
    g_dispatcher().addEvent([pinned] { /* safe to deref */ }, "name");
}
```

The single-threaded dispatcher rarely triggers this null path today,
but the contract is explicit so multi-threaded dispatch can rely on
it.

### `WorldPtr<T>::Shared<Allocator>`

Pinning reference. Copyable. Each copy bumps the existing block's
refcount by one. Destructor decrements; if it hits zero, the block is
retired and its value will be destroyed at the next quiescent state.

```cpp
class Shared {
    Shared();
    Shared(std::nullptr_t);                // explicit
    Shared(Shared &&) noexcept;            // move (no bump)
    Shared(const Shared &) noexcept;       // copy (+1 atomic)
    ~Shared();                             // decrement
    Shared &operator=(Shared &&) noexcept;
    Shared &operator=(const Shared &) noexcept;
    Shared &operator=(std::nullptr_t) noexcept;

    T* get() const noexcept;
    T &operator*() const noexcept;
    T* operator->() const noexcept;
    explicit operator bool() const noexcept;
    bool operator==(const Shared &) const noexcept;
    bool operator==(std::nullptr_t) const noexcept;
    size_t useCount() const noexcept;      // asserts non-null
};
```

**No public `T*` constructor.** A Shared can only be obtained by
calling `.share()` / `.borrow()` on an Owning, or by copying from an
existing Shared/Borrowed. This preserves the affine pipeline — there
is no way to manufacture ownership out of a raw `T*`.

**`useCount()`** asserts that the Shared is non-null in debug builds.

### `WorldPtr<T>::quiescentState<Allocator>()`

```cpp
template <typename Allocator = DefaultAllocator>
static void quiescentState();
```

Drains the per-`(T, Allocator)` retire list. For each retired block,
calls `decrementReferenceCount` — which destroys the value (and frees
the block) when the refcount reaches zero, or leaves it alive if a
Shared elsewhere still pins it.

Call exactly once per dispatcher tick per `(T, Allocator)` pair. The
dispatcher (see [`src/game/scheduling/dispatcher.cpp`](../../../src/game/scheduling/dispatcher.cpp))
maintains the canonical list of types to drain.

The drain is **idempotent** and safe on empty lists.

## `PolyPtr<T>` — type-erased 16-byte wrapper

`PolyPtr<T>` supports polymorphic hierarchies, abstract bases, and
`Weak<T>` observers. The wrapper carries `Header* + T*` (16 bytes)
instead of recovering the block via `offsetof` — necessary because
multiple inheritance / virtual bases break the
`offsetof(Block, value)` trick.

```cpp
PolyPtr<T>::Owning
PolyPtr<T>::Borrowed
PolyPtr<T>::Shared
PolyPtr<T>::Weak
```

All four types are friended for cross-construction; the inner
`Header* / T*` constructors are private.

### `PolyPtr<T>::Owning::make<Allocator>(args...)` and `make_poly<Concrete>(args...)`

```cpp
template <typename Allocator = DefaultAllocator<T>, typename... Args>
    requires (!std::is_abstract_v<T>)
static Owning make(Args &&... args);

// Free helper for the common case (default allocator):
template <typename Concrete, typename... Args>
auto make_poly(Args &&... args);
```

`Owning::make` requires `T` to be concrete (not abstract). For
abstract bases (e.g. `Tile`), use `make_poly<DerivedConcrete>(args...)`
and rely on the cross-type upcast from
`PolyPtr<DerivedConcrete>::Owning` to `PolyPtr<Base>::Owning`:

```cpp
PolyPtr<Tile>::Owning t = make_poly<DynamicTile>(x, y, z);
```

The cross-type Owning constructor is **rvalue-only** — preserves the
affine invariant (no two Ownings can coexist on the same pointee).

### `PolyPtr<T>::Borrowed`

Same shape as `WorldPtr<T>::Borrowed`, but supports:

```cpp
// Cross-type upcast (Derived → Base) — implicit.
PolyPtr<Base>::Borrowed b = derivedOwning.borrow();

// Promote to Shared — CAS-loop, returns null Shared if block retired.
operator Shared() const noexcept;
Shared share() const noexcept;
```

### `PolyPtr<T>::Shared`

Same as `WorldPtr<T>::Shared`, plus implicit cross-type upcast
(Derived → Base) via a templated constructor that bumps the
existing block's strong refcount.

```cpp
PolyPtr<Base>::Shared upcast = derivedShared;   // 1 atomic ADD
```

### `PolyPtr<T>::Weak`

Non-owning observer that keeps the block memory alive (via the weak
refcount group) but does NOT pin the value. Use to break ownership
cycles (Item.m_parent observing Tile; Creature.m_tile observing
Tile).

```cpp
class Weak {
    Weak();
    Weak(std::nullptr_t);                  // explicit
    Weak(const Weak &);                    // copy (+1 weak)
    Weak(Weak &&);                         // move (no bump)
    Weak(const Shared &);                  // from Shared (+1 weak)
    explicit Weak(const Borrowed &);       // from Borrowed (+1 weak)
    ~Weak();                               // decrement weak

    Weak &operator=(/* ... */) noexcept;   // see header

    bool expired() const noexcept;         // 1 atomic LOAD
    Borrowed borrowIfAlive() const noexcept;  // 1 atomic LOAD
    Shared lock() const noexcept;             // 1 CAS
    void reset() noexcept;

    T* get() const noexcept;                  // raw — may be dangling
                                              // after value destroyed
    bool operator==(const Weak &) const noexcept;
};
```

**`Weak(Borrowed)` is `explicit`.** Implicit would let a tick-bound
Borrowed silently extend observability past the current tick (across
a QSBR drain). The caller has to opt in.

**`expired()`** returns `true` when the strong refcount has reached
zero (value destroyed or pending destruction at the next drain).

**`borrowIfAlive()`** is the fast read path — 1 atomic LOAD,
returns a Borrowed if the value is still alive at this moment. The
returned Borrowed is intended for use WITHIN the current tick (no
pinning); after the next `quiescentState()` the value may be
destroyed.

**`lock()`** is the safe pin path — 1 CAS that atomically bumps the
strong refcount only if it is currently `> 0`. Returns a Shared (may
be null if the value already expired). Use when capturing across the
dispatcher boundary or any other tick crossing.

### Cross-type cast helpers

```cpp
// static_cast equivalent — caller asserts the runtime type matches.
template <typename Derived, typename Base>
PolyPtr<Derived>::Shared    static_pointer_cast_poly(const PolyPtr<Base>::Shared &);
template <typename Derived, typename Base>
PolyPtr<Derived>::Borrowed  static_pointer_cast_poly(const PolyPtr<Base>::Borrowed &);
template <typename Derived, typename Base>
PolyPtr<Derived>::Weak      static_pointer_cast_poly(const PolyPtr<Base>::Weak &);

// dynamic_cast equivalent — returns null on runtime-type mismatch.
template <typename Derived, typename Base>
PolyPtr<Derived>::Shared    dynamic_pointer_cast_poly(const PolyPtr<Base>::Shared &);
template <typename Derived, typename Base>
PolyPtr<Derived>::Borrowed  dynamic_pointer_cast_poly(const PolyPtr<Base>::Borrowed &);
template <typename Derived, typename Base>
PolyPtr<Derived>::Weak      dynamic_pointer_cast_poly(const PolyPtr<Base>::Weak &);
```

The `Base` template parameter is deduced from the argument type, so
call sites only need to specify `Derived`:

```cpp
auto houseShared = dynamic_pointer_cast_poly<HouseTile>(tileShared);
```

The `Shared` overload's underlying implementation (`sharedDowncast_`)
uses the same CAS-loop as `Borrowed::share()` — if the source's
strong refcount has reached zero, the downcast returns a null Shared
instead of resurrecting a retired block.

### `polyPtrQuiescentState()`

```cpp
inline void polyPtrQuiescentState() noexcept;
```

Drains the single global PolyPtr retire list across every polymorphic
type (`Tile`, future `Item`, …) in one call. Equivalent to
`PolyPtr<AnyT>::quiescentState()` for any `AnyT` — the retire list is
type-erased.

Prefer this free function in dispatcher / shutdown code where the
specific `T` is arbitrary.

## `enable_borrowed_from_this<T>` mixin

```cpp
template <typename T>
class enable_borrowed_from_this {
public:
    PolyPtr<T>::Borrowed borrowedFromThis() noexcept;
    PolyPtr<T>::Shared sharedFromThis() noexcept;
};
```

Inherit from this to give a class the ability to produce a
Borrowed/Shared of itself from within a member function — analogous
to `std::enable_shared_from_this<T>`.

Wiring is automatic when the object is constructed via
`make_poly<T>` — the mixin's private `poly_header_` field is set by
the allocator's wiring helper. For stack-allocated objects (not
through `make_poly`), `borrowedFromThis()` returns an empty Borrowed.

**`sharedFromThis()`** uses the same CAS-loop helper as the other
"promote to Shared" paths — if the strong refcount has reached zero
(object's Owning was destroyed, dtor pending at the next drain),
returns a null Shared. Mirrors
`std::enable_shared_from_this::shared_from_this`'s safety contract
(which throws `bad_weak_ptr` in the analogous case; we return null
instead).

The mixin's `poly_header_` member is **private** — external code
cannot read or mutate it directly; only the wiring helper in
`make_poly` can set it.

## Transparent hashers / comparators

For use as `Hash` + `KeyEqual` template parameters of unordered /
flat hash containers. `is_transparent` lets `find()` / `erase()`
accept any of the wrapper types (or a raw `T*`) as the lookup key
without materialising a `Shared` (which would cost an atomic).

```cpp
template <typename T, typename Allocator = WorldPtr<T>::DefaultAllocator>
struct WorldPtrTransparentHash {
    size_t operator()(const WorldPtr<T>::Shared<Allocator> &)   const noexcept;
    size_t operator()(const WorldPtr<T>::Borrowed<Allocator> &) const noexcept;
    size_t operator()(const WorldPtr<T>::Owning<Allocator> &)   const noexcept;
    size_t operator()(const T*) const noexcept;
};

template <typename T, typename Allocator = WorldPtr<T>::DefaultAllocator>
struct WorldPtrTransparentEqual { /* same overload set */ };

// Aliases for clarity at the call site:
template <typename T, typename Alloc = WorldPtr<T>::DefaultAllocator>
using WorldPtrOwningHash   = WorldPtrTransparentHash<T, Alloc>;
template <typename T, typename Alloc = WorldPtr<T>::DefaultAllocator>
using WorldPtrBorrowedHash = WorldPtrTransparentHash<T, Alloc>;
template <typename T, typename Alloc = WorldPtr<T>::DefaultAllocator>
using WorldPtrSharedHash   = WorldPtrTransparentHash<T, Alloc>;

template <typename T>
struct PolyPtrTransparentHash {
    size_t operator()(const PolyPtr<T>::Shared &)   const noexcept;
    size_t operator()(const PolyPtr<T>::Borrowed &) const noexcept;
    size_t operator()(const PolyPtr<T>::Owning &)   const noexcept;
    size_t operator()(const PolyPtr<T>::Weak &)     const noexcept;
    size_t operator()(const T*) const noexcept;
};

template <typename T>
struct PolyPtrTransparentEqual { /* same overload set */ };
```

The hash value is `std::hash<T*>` (or `std::hash<const T*>` for the
const overload) over the underlying value pointer — identical
regardless of which wrapper carried the key.

## `AnyPtr<T>` — auto-select WorldPtr vs PolyPtr

```cpp
template <typename T>
struct AnyPtrSelector {
    using type = std::conditional_t<std::is_polymorphic_v<T>,
                                    PolyPtr<T>, WorldPtr<T>>;
};

template <typename T>
using AnyPtr = typename AnyPtrSelector<T>::type;
```

Picks the right family based on whether `T` is polymorphic. Useful in
generic code that doesn't want to commit to either family.

> **Caveat**: `is_polymorphic_v<T>` requires `T` to be complete at the
> alias instantiation point. If `T` may be forward-declared at that
> point, prefer the explicit family name.

## Lua boundary helpers

In [`src/lua/functions/lua_functions_loader.hpp`](../../../src/lua/functions/lua_functions_loader.hpp):

```cpp
// Push a WorldPtr Shared into a Lua userdata; Lua's __gc releases it.
template <typename T, typename Allocator = WorldPtr<T>::DefaultAllocator>
static void pushUserdataAffine(lua_State* L,
                               WorldPtr<T>::Shared<Allocator> value);

template <typename T, typename Allocator = WorldPtr<T>::DefaultAllocator>
static T* getUserdataAffine(lua_State* L, int32_t arg,
                            const char* metatable);

template <typename T, typename Allocator = WorldPtr<T>::DefaultAllocator>
static void registerAffineClass(lua_State* L,
                                const std::string &className,
                                const std::string &baseClass,
                                lua_CFunction newFunction = nullptr);

// Same shape for PolyPtr — note the Borrowed and Shared overloads:
template <typename T>
static void pushUserdataPoly(lua_State* L, PolyPtr<T>::Borrowed value);
template <typename T>
static void pushUserdataPoly(lua_State* L, PolyPtr<T>::Shared value);

template <typename T>
static T* getUserdataPoly(lua_State* L, int32_t arg, const char* metatable);

template <typename T>
static void registerPolyClass(lua_State* L,
                              const std::string &className,
                              const std::string &baseClass,
                              lua_CFunction newFunction = nullptr);
```

`pushUserdataAffine` stores the Shared bit-pattern directly in the
Lua userdata; `__gc` runs the Shared destructor, decrementing the
block's refcount. The Mount goes back to refcount 1 (just the
storage's Owning).

`pushUserdataPoly(Borrowed)` constructs a `PolyPtr<T>::Shared` from
the Borrowed inside the userdata (1 atomic bump). The Borrowed
overload exists because Lua call sites typically receive a Borrowed
from a getter and want to extend its lifetime into Lua.

`registerAffineClass` / `registerPolyClass` are convenience wrappers
that call `registerClass` then wire the `__gc` metamethod to the
generated `luaAffineGarbageCollection<T>` / `luaPolyGarbageCollection<T>`
free function.

## Static invariants (compile-time guards)

`worldpointer.hpp`'s `quiescentState` function carries
defence-in-depth `static_assert`s that document the API
guarantees:

- `Owning` is move-only (copy ctor / assign deleted).
- `Borrowed` / `Shared` / `Weak` are copyable.
- Cross-conversions back to `Owning` are blocked
  (`!std::is_convertible_v<Shared, Owning>`).
- Cross-type Owning copy (lvalue) is blocked — only rvalue move
  allowed (preserves affinity across upcasts).
- `Weak(Borrowed)` is `explicit`.
- `Block` forwarding constructor's `requires` clause rejects
  `Block(B&)` / `Block(const B&)` / `Block(B&&)`.

Same assertions are mirrored in
[`tests/unit/utils/worldpointer_test.cpp`](../../../tests/unit/utils/worldpointer_test.cpp)
under `Guard*` test cases so they show up in the test report.
