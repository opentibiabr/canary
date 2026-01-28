# Player Components

This directory gathers modular components that implement specific `Player` features.
Each class is designed to keep the `Player` entity decoupled, improving maintainability, readability, and testability.

---

## PlayerStorage

`PlayerStorage` centralizes the management of a player's storages.
Previously, the storage map was directly managed by `Player`, which made the codebase more difficult to maintain and test. 
By encapsulating it, several benefits are gained:

### Key Improvements

- **Unified interface**: all read, write, and remove operations are exposed through a single API, avoiding direct manipulation of raw maps.
- **Performance optimization**:
  - Only **modified keys** are tracked and persisted to the database.
  - This avoids rewriting the entire storage map each save cycle.
  - The larger the storage set, the bigger the performance gains, especially on characters with thousands of storages.
- **Support for reserved ranges**:
  Special ranges are reserved for features like **outfits**, **familiars**, **mounts**, **auras**, and more.
  These are automatically expanded or serialized by the component.
- **Improved readability in reserved ranges**:
  Previously, some ranges (like mounts, wings, effects) were represented by empty `if` blocks that did nothing.
  These were confusing and gave the impression of incomplete code.
  The ranges were refactored into a **pass-through list**: a clear, explicit collection of ranges that are persisted normally without warnings.
  This makes the intent much clearer to future maintainers.
- **Event integration**:
  When storages are updated, the system automatically triggers events and callbacks (`eventOnStorageUpdate`, `playerOnStorageUpdate`).
  Scripts and subsystems can react instantly without requiring manual value checks. 
- **Consistency**:
  Database writes happen in controlled, batched queries (DELETE + UPSERT). This reduces the query count and maintains data consistency. 

---

### Usage Examples

#### Basic set and get
```cpp
// Assign a value to a storage
player.storage().add(1000, 1);

// Read the value
int value = player.storage().get(1000);
if (value != -1) {
	g_logger().info("Storage 1000 = {}", value);
}

```

#### Removal
```cpp
if (player.storage().remove(1000)) {
	g_logger().info("Key 1000 removed successfully");
}
```

#### Existence check
```cpp
if (player.storage().has(2000)) {
	g_logger().info("Tutorial step storage exists");
}
```

#### Persisting and loading
```cpp
// Save only modified/removed keys
if (!player.storage().save()) {
	g_logger().error("Failed to persist storages for player {}", player.getName());
}

// Reload everything on login
player.storage().load();
```

---

### Reserved Ranges

Certain storages are grouped into ranges that represent special systems.
For example:

```cpp
// Outfit storage: encoded as << 16 | addons
player.storage().add(PSTRG_OUTFITS_RANGE_START + 1, << 16 | addons);

// Familiar storage: encoded as << 16
player.storage().add(PSTRG_FAMILIARS_RANGE_START + 1, familiarLookType, 16);
```

#### Refactored Pass-Through Ranges

Mounts, wings, effects, auras, and shaders are defined as **pass-through ranges**.
This means:
- They belong to the reserved space.
- They are persisted like regular keys. 
- They no longer generate warnings or confusing empty blocks.

Implementation detail:
```cpp
static constexpr std::array<std::pair<uint32_t, uint32_t>, 5> passThroughRanges {{
	{PSTRG_MOUNTS_RANGE_START, PSTRG_MOUNTS_RANGE_SIZE},
	{PSTRG_WING_RANGE_START, PSTRG_WING_RANGE_SIZE},
	{PSTRG_EFFECT_RANGE_START, PSTRG_EFFECT_RANGE_SIZE},
	{PSTRG_AURA_RANGE_START, PSTRG_AURA_RANGE_SIZE},
	{PSTRG_SHADER_RANGE_START, PSTRG_SHADER_RANGE_SIZE},
}};
```

This makes the design intention explicit: some ranges exist purely to be persisted, while others (such as outfits/familiars) also update player state. 

---

### Performance Notes

- **Legacy approach**:
  Each save cycle rewrote all storages, regardless of whether they changed.
  On characters with thousands of storages, this caused unnecessary I/O and database load.
- **New approach (with PlayerStorage)**:
  - Tracks **only the keys that changed** (`m_modifiedKeys`) and **only the keys that were removed** (`m_removedKeys`).
  - `save()` performs:
    1. A single `DELETE` for all removed keys.
    2. A single `UPSERT` for all modified keys.
  - Keys untouched during the session are skipped, resulting in **smaller queries, fewer locks, and better scalability**.

This optimization significantly reduces save time during global save or player logout.

---

### Best Practices

- Always use `player.storage().add()` and `player.storage().get()` instead of manipulating maps directly.
- Call `remove(key)` explicitly when you want to delete a storage key.
- Although `add(key, -1)` is technically supported, prefer `remove()` for clarity and maintainability.
- Use `has()` to check for existence before assuming a key is present.
- Do **not** call `save()` manually after every change. Storages are automatically:
  - **Loaded on login** (`load()`).
  - **Saved on logout** (`save()`), persisting only keys that were actually modified or removed.
- This incremental approach ensures that logout remains efficient even for players with thousands of storages, while avoiding unnecessary writes during gameplay.

---

### Summary

`PlayerStorage` provides a **clean, efficient, and extensible** way to manage player storages.
It improves modularity, prevents direct map misuse, optimizes persistence, and integrates naturally with the rest of the game engine.
The recent refactoring of reserved ranges (into explicit **pass-through lists**) further improves code readability and clarifies the design intent for future contributors.
