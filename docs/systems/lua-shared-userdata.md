# Lua shared userdata ownership

Canary Lua bindings can expose C++ objects as full userdata. When the userdata
stores a `std::shared_ptr<T>`, the userdata memory contains a non-trivial C++
object that was constructed with placement-new. Lua owns the userdata memory,
but it does not know how to destroy the C++ `std::shared_ptr<T>` object unless
the userdata metatable has a matching `__gc` finalizer.

## What went wrong

The dangerous pattern is:

```cpp
Lua::pushUserdata<T>(L, sharedPtr);
Lua::setMetatable(L, -1, "TypeName");
```

`pushUserdata<T>(..., std::shared_ptr<T>)` constructs a `std::shared_ptr<T>`
inside Lua userdata. If the metatable does not register `__gc`, Lua can collect
the userdata block without running the `std::shared_ptr<T>` destructor. The
reference count is never decremented, the control block remains allocated, and
the pointed object can stay alive permanently.

This is especially easy to miss because `collectgarbage("collect")` may keep
Lua memory stable while process RSS keeps growing in the C++ heap.

The bug was observed in these high-risk bindings:

- `KV`: `kv:scoped()` and `player:kv()` returned shared userdata with no typed
  finalizer, so scoped KV objects could be retained indefinitely.
- `Condition`: `creature:getCondition()` returned shared userdata through a
  weak metatable. `setWeakMetatable` removes `__gc`; it does not store a real
  `std::weak_ptr`.
- `NetworkMessage`: module receive-byte callbacks wrapped a borrowed
  `NetworkMessage&` in `std::shared_ptr<NetworkMessage>(&msg)`. Without a
  no-op deleter and typed finalizer, this could leak the control block and made
  `networkMessage:delete()` unsafe for borrowed messages.

## Current contract

Shared userdata must use the typed helpers in
`src/lua/functions/lua_functions_loader.hpp`:

```cpp
template <>
struct LuaUserdataTraits<MyType> {
	static constexpr std::string_view name = "MyType";
};

Lua::registerSharedClass<MyType>(L, "", MyTypeFunctions::luaMyTypeCreate);
Lua::pushSharedUserdata<MyType>(L, mySharedPtr);
```

The trait is intentionally required. It keeps the C++ type, Lua metatable name,
and `__gc` finalizer tied together at compile time.

For borrowed callback objects, use:

```cpp
Lua::pushBorrowedSharedUserdata<MyType>(L, borrowedObject);
```

This creates a `std::shared_ptr<T>` with a no-op deleter and still uses the
typed `__gc` finalizer to destroy only the `std::shared_ptr<T>` stored in the
userdata. It prevents invalid `delete` and releases the control block. It does
not make the borrowed object safe to store after the callback returns.

## Rules

- Do not combine `pushUserdata<T>(..., std::shared_ptr<T>)` with a manual
  `setMetatable`.
- Do not use `setWeakMetatable` for userdata that stores `std::shared_ptr<T>`.
  It disables `__gc` and can leak the stored C++ object.
- Do not wrap borrowed objects with `std::shared_ptr<T>(&object)` unless a
  no-op deleter is used. Prefer `pushBorrowedSharedUserdata<T>`.
- Do not register new shared userdata with the untyped
  `registerSharedClass(lua_State*, className, baseClass, ctor)` overload.
  Prefer `registerSharedClass<T>`.
- Add a `LuaUserdataTraits<T>` specialization before pushing or registering a
  new shared userdata type.
- Use `pushSharedUserdata<T>` only for non-const `std::shared_ptr<T>`. If a Lua
  API needs a read-only object, introduce a separate read-only metatable instead
  of pushing `std::shared_ptr<const T>` through the normal mutable metatable.

## Review checklist

When reviewing Lua binding changes, check for:

```sh
rg -n "pushUserdata<.*std::shared_ptr|setWeakMetatable|std::shared_ptr<[^>]+>\\(&" src/lua
rg -n "registerSharedClass\\(L," src/lua
```

Any match must be justified. New shared userdata should normally use
`LuaUserdataTraits<T>`, `registerSharedClass<T>`, `pushSharedUserdata<T>`, or
`pushBorrowedSharedUserdata<T>`.

## What this PR fixes

The typed shared userdata helpers make the finalizer use the real C++ type:

```cpp
auto objPtr = static_cast<std::shared_ptr<T>*>(lua_touserdata(L, 1));
std::destroy_at(objPtr);
std::construct_at(objPtr);
```

That runs the `std::shared_ptr<T>` destructor, decrements the reference count,
and then leaves an empty `std::shared_ptr<T>` in the userdata slot. Rebuilding
the empty value mirrors the existing defensive pattern used by other userdata
cleanup code and reduces the impact of accidental repeated cleanup.

The PR also migrates the critical `KV`, `Condition`, and `NetworkMessage`
bindings to the typed path.

## Follow-up hardening

After the critical leak fixes, the next risky pattern was the legacy shared
class registration:

```cpp
Lua::registerSharedClass(L, "TypeName", "", TypeFunctions::luaCreate);
```

That overload installs `Lua::luaGarbageCollection`, which treats the userdata as
`std::shared_ptr<SharedObject>`. This is not correct for userdata that actually
stores `std::shared_ptr<T>` where `T` does not inherit from `SharedObject`.

The non-`SharedObject` shared userdata bindings were migrated to typed
finalizers as well:

- `Action`
- `BatchUpdate`
- `Charm`
- `Combat`
- `CreatureEvent`
- `EventCallback`
- `GlobalEvent`
- `Group`
- `Guild`
- `Loot`
- `ModalWindow`
- `MonsterSpell`
- `MonsterType`
- `Mount`
- `Shop`
- `Spell`
- `TalkAction`
- `Town`
- `Vocation`
- `Weapon`
- `Zone`

Some legacy `registerSharedClass(L, ...)` calls can still exist for userdata
whose stored type is part of the `SharedObject` hierarchy, and `Position` is a
Lua table rather than a shared userdata object. New code should still prefer the
typed helpers.

Do not mechanically migrate polymorphic core userdata such as `Creature`,
`Player`, `Monster`, `Npc`, `Item`, `Container`, `Tile`, or `Teleport` without a
separate audit. Those paths can push a userdata that stores a base
`std::shared_ptr<T>` and then assign a more specific Lua metatable. A typed
finalizer is only correct when the finalizer type matches the actual
`std::shared_ptr<T>` object stored in the userdata slot.
