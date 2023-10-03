# KV Library

## Overview

The Canary KV Library is designed to offer a simple, efficient, persistent, and thread-safe key-value store. It's an abstraction layer that can support various backends (currently, only MySQL is supported). The library provides features such as scoped access to stored values, LRU caching, and type safety. Additionally, it includes a Lua API for easy integration into Lua-based applications.

## Features

- Thread-safe Operations: Multi-threaded environment friendly.
- Pluggable Backends: Support for various storage backends.
- Scoped Access: Organization-friendly scoped key-value pairs.
- LRU Caching: Cache management using LRU strategy.
- Strongly Typed: Type-safe value storage.
- Lua API Support: Manipulate KV store via Lua scripts.

## C++ API

### Initialization

```cpp
#include <kv/kv.h>

// In your class constructor
MyClass(KV &kv) : kv(kv) {}

// Or use the global singleton
KV &kv = g_kv();
```

### Basic Usage

```cpp
// Set an integer value
kv.set("age", 30);

// Get an integer value
int age = kv.get<int>("age");
```

### Scoped Access

```cpp
// Create a scoped KV store
auto scope = kv.scoped("raids");

// Set and get values in the scoped KV
scope->set("last-occurrence", getTimeNow());
int lastOccurrence = scope->get<int>("last-occurrence");
```

### Nested Scopes

```cpp
// Create a scoped KV store
auto scope = kv.scoped("raids")->scoped("raid-123");
scope->set("last-occurrence", getTimeNow());
int lastOccurrence = scope->get<int>("last-occurrence");
```

### Player Scope

```cpp
// Create a player-scoped KV store
auto player = g_game().getPlayerById(123);
auto playerKV = player->kv();
playerKV->set("coins", 100);
```

### Complex Types

```cpp
// arrays
kv.set("some-array", {1, 2, 3});
auto someArray = kv.get<ArrayType>("some-array");

// maps
kv.set("some-map", {{"a", 1}, {"b", 2}, {"c", 3}});
auto someMap = kv.get<MapType>("some-map");

// nested maps/arrays with non-uniform types
kv.set("some-nested", {{"a", {1, "string", 3}}, {"b", {"hehe", 5, 6}}});
auto someNested = kv.get<MapType>("some-nested");
```

## Lua API

### Error Handling

Errors are logged and return nil. Always check for nil when using kv.get().

### Basic Usage

```lua
-- Set and get an integer value
kv.set("age", 30)
local age = kv.get("age")
```

### Scoped Access

```lua
-- Create a scoped KV store
local scope = kv.scoped("raids")

-- Set and get values in the scoped KV
scope.set("last-occurrence", getTimeNow())
local lastOccurrence = scope:get("last-occurrence")
```

### Nested Scopes

```lua
-- Create a scoped KV store
local scope = kv.scoped("raids"):scoped("raid-123")
scope:set("last-occurrence", getTimeNow())
local lastOccurrence = scope:get("last-occurrence")
```

### Player Scope

```lua
-- Create a player-scoped KV store
local player = Player(123)
local playerKV = player:kv()
playerKV:set("coins", 100)
```

### Complex Types

```lua
-- arrays
kv.set("some-array", {1, 2, 3})
local someArray = kv.get("some-array")

-- maps
kv.set("some-map", {{"a", 1}, {"b", 2}, {"c", 3}})
local someMap = kv.get("some-map")

-- nested maps/arrays with non-uniform types
kv.set("some-nested", {{"a", {1, "string", 3}}, {"b", {"hehe", 5, 6}}})
local someNested = kv.get("some-nested")
```
