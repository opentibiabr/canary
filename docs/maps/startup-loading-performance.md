# Startup loading performance notes

## Summary

This document records the startup profiling work done around Lua script loading, map loading, map tile caching, zone lookup, and monster spawn startup.

The important lesson from the profiling cycle is that the startup bottleneck moved. At the beginning, Lua script loading and filesystem work dominated the profile. After the Lua cache and loader changes, the largest remaining cost moved to map parsing and tile cache construction, with monster spawn startup as a secondary hotspot.

These notes are intended to make future profiling rounds easier and to document the invariants that should not be broken while optimizing this path.

## Code areas touched

The work mainly touched these runtime areas:

- `config.lua.dist` for the Lua startup profiling and bytecode cache options.
- `src/config/config_enums.hpp` and `src/config/configmanager.cpp` for the new config keys.
- `src/lua/scripts/luascript.cpp`, `src/lua/scripts/luascript.hpp`, and `src/lua/scripts/scripts.cpp` for Lua metadata reuse, bytecode cache loading, bytecode pack files, memory-buffer loading, and loader telemetry.
- `src/io/filestream.hpp`, `src/io/filestream.cpp`, and `src/io/iomap.cpp` for map input parsing and OTBM tile loading.
- `src/map/mapcache.hpp`, `src/map/mapcache.cpp`, `src/map/map.hpp`, `src/map/map.cpp`, and `src/map/utils/mapsector.hpp` for item cache reuse, basic tile cache fast paths, cache ownership, reserve behavior, and floor/tile cache storage.
- `src/game/zones/zone.hpp` and `src/game/zones/zone.cpp` for indexed zone lookup.
- `src/creatures/monsters/spawns/spawn_monster.cpp` for startup spawn fast paths.
- `src/game/game.hpp`, `src/game/game.cpp`, and `src/items/tile.hpp` for avoiding repeated tile lookup and avoiding zone set copies during creature placement.
- `src/pch.hpp` for headers that became broadly used after the runtime changes.

## Profiling guidance

Use a release-like Windows preset for meaningful startup profiling. Debug, ASan, and test presets are useful for correctness, but they distort CPU and allocation profiles.

The `windows-release` preset emits symbols so profiler call trees can resolve Canary frames instead of showing only addresses. If symbols are missing, the profiler may show entries such as `canary.dll!0x...`; that is not enough to make precise optimization decisions.

When reading Visual Studio CPU Usage results:

- `Total CPU` is inclusive time. It includes child calls and is useful for finding expensive paths.
- `Self CPU`, also called exclusive CPU time, measures time spent directly in the function itself. It is useful for finding the function that directly burns CPU.
- `ntdll`, `kernelbase`, and other external frames are often just the outer sampled frame. Expand the Canary children before drawing conclusions.
- Compare repeated captures. Startup measurements are sensitive to filesystem cache state, antivirus activity, database timing, CPU frequency, and background load.
- Prefer comparing sample counts and call shape across captures, not only percentages. The denominator changes when other startup phases get faster or slower.

The startup log timings are also useful, especially these sections:

- `Loaded modules and scripts`
- `Loaded scripts from 'data/scripts'`
- `Loaded scripts from 'data-otservbr-global/scripts'`
- `Loaded scripts from 'data-otservbr-global/monster'`
- `Loaded scripts from 'data-otservbr-global/npc'`
- `Loaded house items`
- `Canary server online`

## Observed progression

The broad profile progression was:

1. Lua loading and filesystem metadata were initially the dominant startup cost.
2. Lua bytecode caching, metadata reuse, memory-buffer loading, and packed cache entries moved `Loaded modules and scripts` into low single-digit seconds in release profiling runs.
3. After Lua improved, map loading became dominant, especially `IOMap::parseTileArea`, `MapCache::setBasicTile`, and `MapCache::getOrCreateBasicTileFromCache`.
4. After map cache fast paths and reserve work, monster spawn startup became visible enough to optimize.
5. After spawn placement changes, the remaining hotspots were again mostly map parse/cache construction and floor allocation.

Representative post-optimization profiles showed map parsing around half of sampled startup CPU, tile cache construction around one fifth, and spawn startup below the earlier double-digit sample share. These ratios vary by run, so use them as direction, not as fixed performance claims.

## Measured before/after

The captures are sampling profiles, so percentages represent share of sampled CPU in each run. They are useful for comparing where startup time is being spent, but repeated runs can move a few percentage points because of filesystem cache state, antivirus activity, database timing, CPU frequency, and background load.

The best observed post-change startup log showed `Loaded modules and scripts` at `1.516s`. A later capture from the same profiling round showed `2.997s`, which still remained far below the original baseline.

| Area | Before | After | Result |
| --- | ---: | ---: | --- |
| `Loaded modules and scripts` wall time | ~54s | 1.516s best observed, 2.997s latest capture | About 94-97% less wall time |
| `Scripts::loadScripts` | 17.60% | 9.31-15.00% across later captures | Lua loader no longer primary startup bottleneck |
| `LuaScriptInterface::loadFile` | 18.20% | 11.83-19.06% across later captures | File loading cost reduced, remaining share varies with profile noise and workload |
| `luaL_loadfile` | hot in the original profile | 1.60-2.80% | Raw file parsing is no longer the dominant Lua cost |
| `getLuaBytecodeCacheEntry` | not present | ~0.49-0.51% | Cache lookup is cheap compared to the old file-load path |
| `CanaryServer::loadMaps` | 65.59% after Lua improved | 57.68% latest capture | Map loading remains the largest hotspot, but lower than the post-Lua baseline |
| `IOMap::parseTileArea` | 59.58% | 53.87% | Tile area parsing reduced, still the main map cost |
| `MapCache::setBasicTile` | 24.96% | 20.50% | Lower tile cache insertion/setup overhead |
| `phmap::try_emplace` for cached basic tiles | 7.25% | 0.99% | Generic hash-map insertion pressure greatly reduced |
| `MapSector::createFloor` | 7.17% | 5.76% | Less sector/floor growth and lookup overhead |
| `SpawnMonster::startup` | 11.74% | 9.56% | Spawn startup cost reduced after tile reuse and zone-copy changes |
| `SpawnMonster::spawnMonster` | 10.64% | 9.13% | Spawn placement path reduced without changing behavior |

Latest startup log sample after the changes:

```text
Loaded modules and scripts in 1-2 seconds.
```

## Lua startup changes

The first profiling pass showed heavy cost in `Scripts::loadScripts`, `LuaScriptInterface::loadFile`, `luaL_loadfile`, filesystem metadata queries, and script loader telemetry.

The Lua-side work added the following behavior:

- `luaScriptDebugHook` gates the Lua debug hook.
- `luaScriptDebugHookInterval` controls the hook interval when the hook is enabled.
- `luaStartupLoadTelemetry` gates verbose startup loader timing logs.
- `luaScriptBytecodeCache` enables startup bytecode reuse.
- `luaScriptBytecodeCachePath` controls the bytecode cache directory.
- Lua source file metadata is reused during startup loading.
- Lua chunks can be loaded from memory buffers instead of forcing `luaL_loadfile` to reopen paths.
- Bytecode cache entries are packed so repeated startup loads avoid thousands of tiny cache files.
- Loader telemetry overhead was reduced so the instrumentation is useful without becoming the bottleneck.

The default config is intentionally conservative:

```lua
luaStartupLoadTelemetry = false
luaScriptBytecodeCache = true
luaScriptBytecodeCachePath = "cache/lua-bytecode"
luaScriptDebugHook = false
luaScriptDebugHookInterval = 30000
```

Enable `luaStartupLoadTelemetry` only when measuring startup. Keeping it off avoids extra logging cost and noisy production logs.

When both `luaStartupLoadTelemetry` and `luaScriptBytecodeCache` are enabled, each script folder load also logs bytecode cache counters:

```text
Lua bytecode cache for 'data/scripts': pack hits: 0, file hits: 0, misses: 499, writes: 499, pack invalidations: 0, file invalidations: 0
```

Use these counters to verify cache behavior during repeated startup or reload tests:

- `pack hits` means a script chunk was loaded from the packed `.luapack` cache.
- `file hits` means a script chunk was loaded from an individual `.luac` cache file and then repacked.
- `misses` means the source `.lua` was loaded because no valid bytecode cache entry was available.
- `writes` means new bytecode was generated from a source `.lua` chunk and published to the cache.
- `pack invalidations` means a packed cache file was removed because it was invalid or failed to load.
- `file invalidations` means an individual `.luac` file was removed because it failed to load.

Reload behavior follows the normal script directory scan. The loader does not scan `cache/lua-bytecode` looking for standalone scripts. If a `.lua` file is removed from the datapack, it is not discovered by `Scripts::loadScripts`, so its old bytecode is not executed. The old cache entry can still remain on disk or inside an append-only pack, but without a matching source file in the scan it is unreachable.

The bytecode cache key intentionally uses a fast validation identity:

```text
Lua or LuaJIT version
process pointer size
normalized source path
source file size
source file last-write timestamp
source content hash
```

The content hash prevents stale bytecode reuse when a script changes without a size or timestamp change. Source bytes are already needed when a cache miss falls back to loading the Lua file, so the stronger identity keeps cache behavior correct while preserving the loader's normal source-load fallback path.

## Map loading changes

After the Lua path improved, profiling showed the hot path moving to:

- `CanaryServer::loadMaps`
- `IOMap::parseTileArea`
- `MapCache::setBasicTile`
- `MapCache::getOrCreateBasicTileFromCache`
- `phmap` lookups for `BasicTile`
- `MapSector::createFloor`
- `operator new` and allocator frames

The map-side work focused on reducing allocation, hashing, copying, and unnecessary cache work during OTBM parsing.

The main changes were:

- Map data is parsed directly from memory-mapped input.
- Simple map cache items are reused.
- Simple cache items are indexed by item id.
- Per-tile `BasicTile` allocations are avoided where the tile is cacheable.
- Complex map tiles skip dedupe because deduping them is expensive and less likely to pay off.
- Simple tile cache fast paths handle common ground-only and simple-item tile shapes.
- Compact tile lookup paths avoid the full generic `BasicTile` hash when possible.
- Recent compact tile lookups are cached to reduce repeated `phmap` probing.
- Map cache containers are reserved after the map header is known.
- Parsed item vectors reserve capacity when the OTBM node makes that useful.
- Tile item lists reserve capacity when materializing cached tiles.
- `MapCache::setBasicTile` accepts a reusable floor cursor so repeated tile writes avoid repeated sector/floor lookup.
- `MapSector::Floor` stores the runtime `Tile` pointer and cached `BasicTile` pointer separately.

The `MapCache::flush()` call happens at the end of map loading. That means preserving capacity in `clear()` can help later reloads, but it does not explain cold-start gains. For cold start, the useful reservation happens after the map header is read, through `MapCache::reserveForMap`.

## Basic tile cache ownership

The map cache now uses raw `const BasicTile*` on the hot read path, but ownership is still retained by `MapCache`.

The lifetime rule is:

- Shared ownership remains inside cache storage and `retainedBasicTiles`.
- Hot paths can store and pass `const BasicTile*` because the pointed objects are retained by the cache owner.
- `flush()` clears retained entries and resets the lookup cache.
- Do not store these raw pointers outside the lifetime of the map cache that produced them.

This was done because replacing hot-path `shared_ptr` movement with raw pointers removes reference count churn without changing ownership semantics.

## Zone and spawn startup changes

Monster spawn startup became visible after map and Lua costs were reduced. The relevant sampled path was:

- `SpawnsMonster::startup`
- `SpawnMonster::startup`
- `SpawnMonster::spawnMonster`
- `Game::internalPlaceCreature`
- `Map::getTile`
- zone enter/leave callbacks

The work here stayed conservative because spawn and zone behavior is visible to datapacks.

The main changes were:

- Zones are indexed by position for faster lookup.
- Startup monster event rescans are skipped where the event list is already known.
- Single-monster spawn blocks use a fast path.
- Weighted spawn choices avoid sorting where it is unnecessary.
- `Game::internalPlaceCreature` passes the already resolved tile into `Map::placeCreature`.
- `Tile::getZones()` returns a const reference instead of copying the zone set.

Do not remove zone callbacks from startup placement just to reduce CPU. Datapacks can depend on zone entry behavior, monster variants, and spawn-related side effects.

## Spawn selection behavior change

`spawnBlock_t::getMonsterType()` now uses a weighted-random selection for multi-monster spawn blocks:

- Single-monster blocks still return that monster directly.
- For non-singleton blocks, boss monsters still take precedence exactly as before.
- The combined weights of non-boss monster types are summed, and the function now safely returns `nullptr` when `totalWeight == 0`.
- A random value in `[0, totalWeight - 1]` is used to pick the winner by subtracting weights from the random value as we iterate candidates.

This means mixed spawn blocks now follow weighted distribution instead of the previous deterministic threshold order. Server operators should expect non-deterministic ordering when monitoring spawn logs and map scripts that relied on fixed ordering.

## What improved

Across the profiling captures, the largest improvement was the Lua loader path. `Loaded modules and scripts` moved from tens of seconds to low single-digit seconds in release profiling runs, and `luaL_loadfile` stopped being the main cost.

After that, the biggest measurable wins came from map cache and spawn startup changes:

- `MapCache::setBasicTile` and `MapCache::getOrCreateBasicTileFromCache` moved down after simple tile fast paths, raw cache pointers, and cache reservation.
- `BasicTile::hash` and `phmap` lookup cost reduced but did not disappear.
- Spawn startup samples moved down after reusing the resolved tile and avoiding zone set copies.
- The split `Floor` storage removed the old cost of initializing arrays of `std::pair<std::shared_ptr<Tile>, const BasicTile*>`.

The remaining main hotspot is still map parsing and cache construction, not Lua.

## Current remaining hotspots

The current profile shape still tends to show these as the next relevant areas:

- `IOMap::parseTileArea`
- `MapCache::setBasicTile`
- `MapCache::getOrCreateBasicTileFromCache`
- `phmap` lookup for `BasicTile`
- `MapSector::createFloor`
- `Floor::Floor`

The next low-to-medium risk improvement would likely be another compact lookup cache for common simple tile keys before falling back to the generic `phmap` path.

The higher-risk improvement would be changing `Floor` storage to avoid initializing full tile-pointer grids for floors that remain sparse. That touches central map storage and should be treated as a separate design change, not a small profiling patch.

## Deferred Lua cache work

These Lua cache improvements were intentionally left out of this profiling PR:

- Manual cache clearing: useful for operators, but it touches command or startup-option behavior rather than the measured startup hot path. It should be added separately with clear permissions and logging.
- Cache pruning or garbage collection: safe for loose `.luac` files, but packed `.luapack` files are append-only and need a rebuild step to remove stale chunks. Doing that during every reload would add I/O to the path this PR is trying to keep fast.
- Optional pack compaction: content-hash keys can leave old chunks in append-only `.luapack` files after source edits. Rebuilding packs to drop unreachable chunks should be a separate maintenance path with clear logging.
- Automated reload/cache tests: The expected scenarios are documented below, but a robust test harness requires isolated temporary datapacks, separate cache directories, controlled reload calls, and simulated corruption cases. That should be a focused test follow-up rather than being mixed into this performance patch.

Useful future test scenarios:

- First load misses cache and writes bytecode.
- Reload without source changes reuses bytecode.
- Editing a source file changes the cache key and writes fresh bytecode.
- Removing a source file prevents the old bytecode from being loaded.
- Corrupting a `.luac` file invalidates it and recompiles from source.
- Corrupting a `.luapack` file invalidates or bypasses the pack and falls back to `.luac` or source.

## Invariants to preserve

Map loading optimizations must preserve these behaviors:

- Do not dedupe complex tiles in a way that can merge mutable state.
- Do not change item creation order for action id, unique id, containers, or item attributes.
- Do not let cached `BasicTile` raw pointers outlive the owning map cache.
- Do not skip zone callbacks during real creature placement.
- Keep monster spawn weighting behavior in `spawnBlock_t::getMonsterType()` aligned with weighted-random selection and `totalWeight == 0` guard semantics unless intentionally changing it later.
- Do not enable Lua debug hooks by default.
- Do not leave startup telemetry enabled by default.
- Keep widely used new headers in the precompiled header when appropriate, otherwise compile time can regress even if runtime improves.

## Validation checklist

For future profiling rounds:

1. Build with a release-like preset that emits symbols.
2. Confirm the executable and symbol file are from the same build.
3. Run startup several times and keep the log timings.
4. Capture CPU Usage and inspect expanded Canary frames under external system frames.
5. Compare repeated captures by both wall-clock startup log timings and sampled call shape.
6. Verify map behavior with action ids, unique ids, containers, houses, zones, monster spawns, and NPC/monster script loading.
7. Treat datapack warnings separately from performance changes unless the warning appears only after a specific code change and has a reproducible minimal case.
