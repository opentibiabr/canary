# Performance and lifetime roadmap

This document records the current Canary object lifetime contracts around
movement, spectators, monster AI, pathfinding, Lua userdata, and dispatcher
boundaries. It is a roadmap for reducing `std::shared_ptr` and `std::weak_ptr`
overhead in measured hotpaths without reintroducing manual lifetime bugs.

It is not approval to globally replace core objects with raw `new`/`delete`.
The safe target is narrower: keep strong ownership at system boundaries, use
borrowed raw pointers only inside proven synchronous scopes, and cross delayed
or async boundaries through a strong pin or a stable identity that can be
resolved again.

## Problem statement

Recent Avalorium profiling showed the dispatcher/main-game hotpath as the
pressure point, not broad CPU saturation. The repeated costs were concentrated
around:

- Movement and visibility fanout:
  `Map::moveCreature`, `Spectators::getSpectators`,
  `Monster::onCreatureMove`, and `Creature::sendAsyncTasks`.
- Monster AI and pathfinding:
  `Monster::getNextStep`, `Creature::getPathTo`,
  `Map::getPathMatchingCond`, `Map::canWalkTo`, and `Map::getTile`.
- Lifetime bookkeeping:
  `shared_ptr` release/copy, `weak_ptr` lock/release, and allocator churn.

The working assumption for this roadmap is:

- `shared_ptr` is too expensive when copied or locked repeatedly inside these
  hot loops.
- `shared_ptr` is still useful as the ownership and safety boundary for core
  gameplay objects.
- Raw pointers are acceptable only as borrowed views under a documented owner
  or lifetime pin.
- A full return to scattered manual `new`/`delete` for `Thing`, `Creature`,
  `Item`, `Tile`, and derived classes is higher risk than the current measured
  performance problem.

Refresh the profile before each phase. The exact percentages are workload
dependent, but the contracts below should remain valid unless the ownership
model is deliberately redesigned.

## Vocabulary

### Strong owner or pin

A `std::shared_ptr<T>` that keeps the object alive while code runs. This is the
current default for public APIs in `Thing`, `Cylinder`, `Tile`, `Creature`,
`Item`, `Map`, `Game`, and Lua userdata.

Use a strong owner when code:

- Crosses a dispatcher, scheduler, async, Lua, database, or network boundary.
- Stores an object in a member, cache, list, map, or event.
- Calls into code that may remove, move, transform, reload, or script the
  object.
- Must preserve the current object even if game state changes while the work is
  pending.

### Weak observer

A `std::weak_ptr<T>` records interest without owning the object. It must be
locked before use, and the result must be treated as a short-lived strong pin.

Current examples include:

- `Creature::m_tile`
- `Creature::m_attackedCreature`
- `Creature::m_followCreature`
- `Creature::m_master`
- `Item::m_parent`
- `Monster::targetList`
- `Monster::friendList`
- `Game::checkCreatureLists`

Weak observers are safe but can be expensive in hot loops. Do not replace them
with stored raw pointers. Replace hot weak lists with stable handles only after
the target semantics are specified.

### Borrowed raw view

A `T*` or `const T*` that is not an owner. It is valid only while an enclosing
owner or synchronous game-state scope guarantees the object cannot be destroyed.

Borrowed raw views may be used for hotpath reads when all of these are true:

- The pointer is produced and consumed in the same synchronous stack or
  dispatcher event.
- It is anchored by an existing strong owner, stable container snapshot, or
  world-state invariant that is documented near the accessor.
- It is not stored in any member, container, static cache, lambda, scheduled
  task, coroutine, Lua userdata, or network callback.
- The code does not call into a path that can remove or transform the object
  before the borrow is finished, unless the object is pinned separately.

`Map::moveCreature` already uses this pattern for `Player*` spectator fanout:
the raw pointers are created from a `Spectators` list that holds
`shared_ptr<Creature>` entries, used immediately, and not stored.

### Stable identity

An ID, generation-aware handle, `Position`, GUID, or other value that can be
carried across delayed work and resolved again at use time.

Current stable-identity examples include:

- Creature runtime IDs through `Game::getCreatureByID`.
- Player IDs through `Game::getPlayerByID`.
- Player GUIDs for persistent player identity.
- Positions for map lookup, when tile replacement and map reload semantics are
  acceptable.

For monster target/friend hot lists, the preferred future direction is a
creature handle such as `{id, generation}` or another explicitly invalidating
identity, not raw `Creature*`.

### Async boundary

Any boundary where the current stack no longer controls lifetime:

- `Dispatcher::addEvent`
- `Dispatcher::addWalkEvent`
- `Dispatcher::scheduleEvent`
- `Dispatcher::cycleEvent`
- `Dispatcher::asyncEvent`
- `Dispatcher::asyncScheduleEvent`
- `Dispatcher::asyncCycleEvent`
- `Dispatcher::safeCall`
- Lua `addEvent` and callbacks
- Database callbacks
- Network protocol callbacks
- Save/decay/spawn scheduled tasks

Borrowed raw pointers must not cross these boundaries.

## Hard rules

- Do not globally migrate `Thing`, `Creature`, `Player`, `Monster`, `Npc`,
  `Item`, `Container`, `Tile`, `Cylinder`, or `House` ownership away from
  `shared_ptr` in an early performance pass.
- Do not store raw pointers to core gameplay objects in members, caches,
  long-lived containers, Lua userdata, scheduled tasks, async tasks, protocol
  callbacks, database callbacks, or save/decay/spawn jobs.
- Do not replace `weak_ptr` hot lists with raw pointer lists. Use an audited
  handle or keep `weak_ptr`.
- Do not bypass `Game::removeCreature`, `Tile::removeThing`,
  `Cylinder::postRemoveNotification`, parent reset, zone callbacks, movement
  callbacks, or decay notifications to reduce overhead.
- Do not change core Lua userdata ownership without following
  `docs/systems/lua-shared-userdata.md`.
- Do not expose borrowed raw pointers in public APIs unless the function name,
  documentation, and call sites make the borrowed lifetime obvious.
- Do not introduce raw accessors that can be called from delayed or async code
  unless the accessor is only a local helper and all callers are audited.

## Benchmark-only monster stress mode

`config.lua.dist` exposes two disabled-by-default flags for local monster AI
profiling:

- `monsterPerfTestForceActive`: keeps monsters out of idle state even when no
  player or target is nearby.
- `monsterPerfTestFriendlyFire`: lets non-summon monsters classify other
  non-summon monsters as valid opponents and use random target selection in the
  stress path.

These flags are not gameplay features. They are intended for controlled CPU and
dispatcher profiling when player load is not available. Keep them disabled in
production-like environments unless the benchmark explicitly requires them.

The implementation must keep these contracts:

- Do not make summons attack their masters or use the friendly-fire override.
- Do not bypass protection zone, attackability, visibility, or z-level checks.
- Do not store raw creature pointers or capture borrowed pointers in delayed
  work.
- Treat runtime config toggles as best-effort for benchmarks; restarting or
  respawning monsters gives the most deterministic target-list population.

## Monster stress profile interpretation

A Visual Studio CPU sample with both benchmark flags enabled showed the
dispatcher path as the first-order cost. The strongest symbols were allocator
and task lifecycle work:

- `operator new`, `_malloc_base`, `_free_base`
- `Task` construction/destruction
- `Dispatcher::__mergeEvents`
- `std::vector<Task>::clear`
- `std::basic_string` construction for task context names

Movement and monster work were the gameplay drivers behind that churn:

- `Map::moveCreature`
- `Creature::sendAsyncTasks`
- `Monster::onCreatureMove`
- `Spectators::find` and `Spectators::getSpectators`
- `Monster::updateTargetList`

Pathfinding still appeared, but it was not the dominant cost in this artificial
stress profile. `shared_ptr` and `weak_ptr` costs were visible, but below the
task/allocation pressure. This profile should not be interpreted as evidence
for a broad raw-pointer ownership rewrite.

The first safe dispatcher-side experiment is to remove per-task allocation for
task context strings. `Task` contexts are now interned: the task stores a
stable `std::string_view`, while a process-local string table owns one copy of
each distinct context name. This keeps current logging and metrics semantics
without allocating a new context string for every short-lived task.

Creature async execution has since moved from one generic dispatcher task per
creature to a bounded bucketed queue. `Creature::sendAsyncTasks` still keeps the
per-creature `AsyncTaskRunning` guard, but the dispatcher sees at most a small
fixed set of `WalkParallel` bucket tasks per wave. The queue stores
`weak_ptr<Creature>` entries and resolves them only when the batch executes.
This keeps the async lifetime boundary explicit while reducing task allocation
and merge churn.

The bucket queue must stay sliced into bounded batches. Monster stress can put
thousands of creatures into `WalkParallel`; draining an entire bucket in one
task can delay the later `Serial` group long enough for network tasks such as
`ProtocolGame::sendLoginChallenge` and `Connection::close` to expire. When a
bucket has remaining entries, schedule a follow-up `WalkParallel` task instead
of continuing in the same dispatcher pass. This preserves the async lifetime
contract while preventing login/network starvation during artificial monster
stress.

The batching contract is:

- Queue a stable creature identity or `weak_ptr`, not a raw `Creature*`.
- Preserve the existing "one pending async execution per creature" behavior.
- If new async work is added while a creature is being processed, run it in a
  later batch rather than racing the current task vector.
- `Creature::executeAsyncTasks` processes a swapped local vector snapshot. Work
  queued during that snapshot remains on the creature and is scheduled as a
  follow-up batch.
- Keep script, movement, and removal callbacks on the same ownership boundaries
  used today.

Additional safe cuts applied after the dispatcher profile became cleaner:

- `Map` path searches capture the creature's current tile once per A* search and
  reuse it for `canWalkTo`-equivalent neighbor checks. This avoids repeated
  `Creature::getTile()` weak-locks inside the node loop without storing borrowed
  tile pointers.
- Pathfinding tile resolution now reuses a caller-owned `MapCacheFloorCursor`
  inside a single synchronous A* or directional walk-check scope. The cursor
  caches only resolved floors, still returns `shared_ptr<Tile>`, and still
  materializes cached map tiles through `MapCache::getOrCreateTileFromCache`.
  `Floor::getTileAndCache` reads the realized tile and pending `BasicTile`
  cache under one shared lock, then releases the lock before materialization.
- `Creature::goToFollowCreature` skips A* when the current position already
  satisfies the exact pathing condition, including line-of-sight checks. Flexible
  ranges such as flee or keep-distance still use A* because they may need a
  better position, not merely any valid one.
- Monster target classification reuses the benchmark friendly-fire config value
  within each target-list/search pass instead of reading config repeatedly for
  every candidate.
- `Monster::targetList` stores the target runtime ID beside the `weak_ptr`.
  Membership checks compare the ID first and only lock the weak reference for
  the matched candidate or when the target object is actually used. The ID is an
  index hint, not a lifetime guarantee.
- `Monster::searchTarget` reserves its temporary candidate vector from
  `targetList.size()`, and `friendList` removals use the existing ID key instead
  of scanning and locking the whole map.
- `Creature` keeps a small count of active condition types. `hasCondition` and
  related type lookups can reject missing types without scanning the condition
  list; sub-ID and timeout checks still use the existing condition objects.
- `Creature::addAsyncTask` constructs the stored `std::function` directly from
  the callable. This avoids an extra temporary `std::function` move/reset in hot
  movement callbacks.
- `Creature::addAsyncTask` and `Creature::setAsyncTaskFlag` now skip redundant
  scheduler entry attempts while `AsyncTaskRunning` is already set. New work
  added to an already queued or executing creature remains on the existing
  async batch contract instead of re-entering `sendAsyncTasks` only to hit the
  guard.
- `Monster::onCreatureMove` no longer keeps a strong reference to the moved
  creature across the async monster task. It captures a `weak_ptr` and resolves
  it when the batch runs; if the moved creature disappeared, the task only
  refreshes idle state and exits.
- `Spectators::insertAll` reserves capacity before copied snapshot merges and
  deduplicates merged snapshots with transient creature identity keys while the
  stored snapshot remains a `shared_ptr` vector. Cached filter paths reserve
  from the source cache size instead of the destination size.

Do not enable the global `Spectators` cache inside monster async target-list
updates without adding synchronization or a per-tick immutable cache. That cache
is a shared static map, while `Monster::updateTargetList` runs in
`TaskGroup::WalkParallel`; using it directly from the parallel path can trade
CPU for a data race.

The next large hotspot after the low-risk async closure cuts is spectator and
movement fanout. `Spectators::getSpectators` still builds strong snapshots by
walking map sectors. Reducing that safely likely needs a per-tick immutable
relevancy cache or another synchronization-aware design, not ad hoc raw
spectator pointers.

### Follow-up priority from the latest monster-stress sample

After the async batching and low-risk closure work, the profile shifted toward
real map lookup and spectator fanout. The table below uses the latest observed
sample as a prioritization guide. Totals overlap because call-tree percentages
include callees; do not add them together.

| Priority | Profile signal | Interpretation | Next work class |
| --- | --- | --- | --- |
| 1 | `Map::getTile`: about 14.1% total, 6.6% own | Tile lookup is now the clearest self-cost. Pathfinding, sight checks, and movement repeatedly resolve sectors, floors, and `shared_ptr<Tile>` pins. | Phase 4 v1 uses a local floor cursor while keeping `shared_ptr<Tile>`. Any later borrowed tile view must be separately audited against `MapCache`, `Floor::setTile`, dynamic tiles, map reload, and `queryAdd` side effects. |
| 2 | `Spectators::getSpectators`: about 8.7% total, 6.2% own; `Spectators::find` appears inside `Map::moveCreature` | Sector walking and strong snapshot creation are still expensive under movement stress. The current snapshot model is safe but allocates and copies ownership in hot loops. | Larger Phase 2 work: per-tick immutable relevancy cache or synchronized spectator snapshot reuse. Do not enable the current global cache from `WalkParallel` without a synchronization design. |
| 3 | `Creature::enqueueAsyncTask` closure path: about 45.2% total, 4.3% own | This is mostly a batch envelope now, not pure closure cost. Own cost remains worth trimming, but the large total means movement and monster work are executing inside the queued batch. | Medium-to-large scheduler work: typed pending movement/AI events or a per-creature ring instead of generic `std::function` batches. Requires ordering, removal, script, and requeue semantics. |
| 4 | Movement fanout: `Creature::onCreatureWalk` about 21.5%, `Map::moveCreature` about 17.2%, `Monster::onCreatureMove` about 8.6% | Movement still fans out into client sends, old-stack checks, monster target refresh, idle updates, and async follow-up. | Larger Phase 2 work: fixed update phases, coalesced monster movement notifications, and deduplicated per-tick target refresh. Must preserve movement callback order and script-visible behavior. |
| 5 | `Game::checkCreatures` dispatcher lambda: about 13.5% total in the sample | The check-creature loop is visible, but it overlaps with movement and AI work. It should not be optimized blindly before the higher self-cost map/spectator paths. | Later scheduler cleanup: typed check queue and fewer generic task allocations, after movement/spectator changes are measured. |
| 6 | `__CheckForDebuggerJustMyCode`: about 5.4% own | This is profiler/build instrumentation noise, not a Canary gameplay cost. | Measurement cleanup: use a Release profile with PDBs and Just My Code disabled before making fine-grained decisions. |

Low-risk cuts already applied in response to this profile are intentionally
small: avoid redundant async scheduling calls, reduce spectator merge churn, and
document the remaining contracts. The next high-impact work is no longer a
mechanical `shared_ptr` cleanup; it is a data-structure and update-phase
problem around map tiles, spectator relevance, and movement fanout.

General game-server architecture favors fixed update phases, persistent
relevancy/state structures, and batched per-tick work over per-entity
one-shot allocation in the hot loop. Canary can move in that direction, but the
safe path is incremental: intern cheap metadata first, batch creature async
work, then revisit spectator and pathfinding data with explicit synchronization
and measurement.

## Current contract map

| Area | Current contract | Risk if changed blindly | Safe near-term direction |
| --- | --- | --- | --- |
| `SharedObject` | Core objects use `enable_shared_from_this` and `static_self_cast`. | Removing this breaks many public APIs and Lua/event call paths. | Keep as the ownership boundary. Reduce local copies instead. |
| `Thing` and `Cylinder` | Public virtual APIs use `shared_ptr` for parents, things, items, creatures, and notifications. | Raw ownership rewrite touches movement, containers, trade, decay, Lua, combat, and notifications. | Do not rewrite globally. Add narrow borrowed helpers only where every caller is synchronous. |
| `Tile` | Stores `shared_ptr<Item>` and `CreatureVector`; exposes `shared_ptr` helpers and notifications. | Raw tile contents can dangle during remove, transform, teleport, map reload, decay, and cleanup. | Keep storage strong. Consider read-only borrowed iteration views after notification contracts are audited. |
| `Floor` and `MapSector` | `Floor::getTile` returns `shared_ptr<Tile>` under `shared_lock`; sectors store creature lists as `shared_ptr`. | Borrowing a `Tile*` without a lock or pin can race tile replacement/reload/cache changes. | Introduce tile borrow APIs only with clear lock or dispatcher-only lifetime rules. |
| `Map::moveCreature` | Receives strong creature/tile pins, builds spectator snapshots, then may defer notifications. | Any raw pointer captured by the deferred `events` lambda can outlive the current stack. | Keep deferred captures strong or use IDs/positions and re-resolve. Raw `Player*` is acceptable only for immediate fanout. |
| `Spectators` | Snapshots are `CreatureVector` of `shared_ptr<Creature>` and may be cached. | Raw spectator caches would dangle after logout/removal. | Reduce copies and allocations first. Add borrowed views only for immediate non-cached fanout. |
| `Monster::targetList` and `friendList` | `targetList` stores `{creatureId, weak_ptr<Creature>}` and `friendList` is keyed by creature ID with weak values. The weak reference remains the lifetime gate. | Raw target lists are classic use-after-free risk after death, logout, teleport, despawn, or delayed AI. ID-only storage without generation can misidentify reused IDs if reuse semantics change. | Keep ID sidecars as lookup hints only. Replace with ID/generation handles only after removal/despawn/reuse semantics are specified. |
| `Creature` follow/attack/master/tile | Stored as `weak_ptr`; accessors lock and return `shared_ptr`. | Raw member pointers can become stale when creatures are removed or moved. | Consider handle-backed access for hot AI paths, but keep public safety semantics. |
| `Item::m_parent` | Stored as `weak_ptr<Cylinder>`; parent chain is resolved dynamically. | Raw parent can dangle after move, transform, trade, container removal, or depot/house transfer. | Keep weak parent. Optimize only local parent walks with a temporary pin or documented borrow. |
| Pathfinding | `Map::getTile`, `Map::getTileWithFloorCursor`, `Map::canWalkTo`, and `AStarNodes::getTileWalkCost` still return or consume `shared_ptr<Tile>`. The floor cursor is a synchronous lookup hint, not tile ownership. | Raw tile reads can become invalid if tile lifetime is not tied to the search scope. Reusing a cursor outside one search can observe stale floor assumptions. | Keep cursor scope local to A* and directional checks. Consider borrowed `Tile*` only after map/floor stability is documented and measured. |
| Dispatcher and scheduler | Delayed work is stored as `std::function`, `Task`, and scheduled events. Task context names are interned and held as stable `std::string_view` values. | Captured raw pointers can outlive their object by one cycle or by seconds. Per-creature task fanout can amplify allocator churn. | Capture IDs, weak pointers, or strong pins. Re-resolve at execution. Consider batched creature async execution after measurement. |
| Lua userdata | Core userdata stores `shared_ptr` and has special finalizer rules. | Raw or borrowed userdata can outlive the C++ object; wrong finalizer leaks or corrupts lifetime. | Follow `docs/systems/lua-shared-userdata.md`; never move core polymorphic userdata mechanically. |
| Protocol and network | Protocol events capture protocol self or player IDs before dispatching game actions. | Raw player/session pointers can outlive disconnects or connection release. | Keep protocol self pins and player ID re-resolution. Do not pass raw gameplay objects across network callbacks. |
| Database/save/decay/spawn tasks | Work can complete later on dispatcher or scheduled events. | Raw item/creature pointers can outlive transforms, removals, or shutdown. | Store IDs, GUIDs, positions, value snapshots, weak refs, or strong pins depending on semantics. |

## Phase 0: measurement and guardrails

Goal: make each change accountable to the dispatcher hotpath profile.

Tasks:

- Keep separate profiles for the dispatcher thread and total process CPU.
- Capture movement-heavy and monster-heavy scenarios before each phase.
- Record allocations and refcount symbols separately from game logic symbols.
- For fine-grained Visual Studio samples, prefer a Release build with PDBs and
  Just My Code disabled. Debug-only helpers such as
  `__CheckForDebuggerJustMyCode` can otherwise pollute small hotpath decisions.
- Add lightweight counters or trace points only when they can be removed or
  compiled out.
- Identify whether each candidate hotpath is copy-heavy, weak-lock-heavy,
  allocation-heavy, or algorithm-heavy.

Exit criteria:

- The next phase has a measured target function and a before profile.
- The change has an explicit lifetime contract and a test plan.

## Phase 1: local borrow cleanup

Goal: remove avoidable `shared_ptr` copies and weak locks without changing
ownership.

Allowed work:

- Prefer `const std::shared_ptr<T>&` parameters where ownership does not need
  to be copied.
- Reuse existing strong pins inside a function instead of repeatedly calling
  accessors that lock weak pointers.
- Use existing raw type accessors such as `getPlayerRaw`, `getMonsterRaw`, and
  `getNpcRaw` for immediate type checks and dispatch decisions.
- Add new raw accessors only when they are private or narrowly scoped and have
  an explicit "borrowed, do not store" comment.
- Pre-reserve vectors and avoid duplicate spectator snapshot materialization.

Forbidden work:

- Storing raw pointers beyond the current stack.
- Returning raw core objects from broad public APIs.
- Changing object storage ownership.
- Capturing borrowed pointers in lambdas.

Good first audit targets:

- `src/map/map.cpp`
- `src/map/spectators.cpp`
- `src/creatures/monsters/monster.cpp`
- `src/creatures/creature.cpp`

Current implementation note:

- Raw type accessors such as `getPlayerRaw`, `getMonsterRaw`, and `getNpcRaw`
  are documented as borrowed same-stack views. They can remove refcount churn
  from immediate type checks, but they are not async handles.
- `Game::checkCreatures` may re-resolve the delayed monster post-think follow-up
  by monster runtime ID because monster IDs are assigned by a monotonic runtime
  counter. This rule must not be generalized to players because player runtime
  IDs are derived from GUIDs and can identify a later session for the same
  character.
- `Game::addCreatureCheck` keeps the generic check-list path as `weak_ptr`,
  including the scheduled insertion. It deliberately does not use raw pointers
  or ID-only storage for generic creatures.
- `Creature::addAsyncTask`, `Creature::safeCall`, `Tile::safeCall`, and
  `SaveManager::schedulePlayer` are documented async boundaries. Player save
  scheduling keeps weak/strong ownership because GUID or player runtime ID
  re-resolution can target a later session for the same character.
- `Spectators::insert` and `Spectators::insertAll` return references and move
  freshly built spectator snapshots into the result when no cache needs the same
  vector first. Cached snapshots remain strongly owned and are not replaced with
  raw pointers.
- `Creature::conditionTypeCounts` is a derived cache of the `conditions` list.
  All current direct list mutations in `Creature` and `Player` update the count.
  Do not add new direct `conditions.erase` or `conditions.emplace` sites without
  updating the cache in the same change.

## Phase 2: movement and spectator fanout

Goal: reduce work around `Map::moveCreature` and `Spectators::getSpectators`.

Candidate work:

- Split spectator collection from immediate player notification fanout so player
  sends can use borrowed `Player*` views under the existing spectator snapshot.
- Avoid repeated player visibility checks where the old stack position and move
  send use the same condition.
- Avoid duplicate `Spectators` vectors when old and new viewports overlap.
- Keep cached spectator data as strong references or re-resolvable identities,
  not raw pointers.

Contracts:

- Raw player borrows are valid only while the owning `Spectators` snapshot is
  alive and no delayed boundary is crossed.
- Deferred movement notifications must capture strong pins or stable IDs.
- Any callback that can run scripts or remove objects ends the safe raw borrow
  scope unless the object was pinned separately.

Required tests:

- Normal step, teleport, floor change, and forced teleport.
- Login/logout while nearby movement events are pending.
- Monster entering/leaving viewport while target lists update.
- Scripted movement events that remove, teleport, or transform involved
  objects.

## Phase 3: monster target and friend handles

Goal: remove hot `weak_ptr::lock()` loops from monster AI without storing raw
creature pointers.

Candidate model:

```cpp
struct CreatureHandle {
	uint32_t id = 0;
	uint32_t generation = 0;
};
```

The exact generation source still needs design. The important contract is that a
handle must fail closed if the creature was removed and an ID was reused.

Candidate work:

- Replace `Monster::targetList` and `Monster::friendList` storage with
  generation-aware handles after defining removed/dead/logout/despawn semantics.
- Re-resolve handles through `Game` immediately before use.
- Preserve current erase-on-expired behavior as erase-on-invalid-handle.
- Keep Lua APIs returning `shared_ptr` snapshots, not raw pointers.

Near-term work already done:

- `targetList` has an ID sidecar to avoid `weak_ptr::lock()` in membership
  checks such as `Monster::getTargetIterator`.
- This is intentionally not the final handle model. The `weak_ptr` still decides
  whether the target is alive before use.

Open design questions:

- Are monster and NPC runtime IDs ever reused in a way that needs generation
  protection?
- Should offline/disconnected players be resolvable for AI, or should handles
  fail when the player leaves active game state?
- Should target ordering survive a creature disappearing and reappearing with a
  new runtime ID?

Required tests:

- Target dies during monster think.
- Player logs out while targeted.
- Summon/master disappears.
- Monster despawns while another monster still has it in target/friend data.
- Target list exposed to Lua remains safe and deterministic.

## Phase 4: pathfinding tile cursor and future borrows

Goal: reduce `shared_ptr<Tile>` churn in A* tile checks.

Completed v1 work:

- `Floor::getTileAndCache` reads the realized tile pointer and pending
  `BasicTile` cache pointer under one shared lock.
- `Map::getTileWithFloorCursor` reuses a caller-owned `MapCacheFloorCursor` for
  repeated tile resolution inside one synchronous pathfinding or walk-check
  scope.
- `Map::getPathMatching`, `Map::getPathMatchingCond`, `Map::canWalkTo`,
  `Monster` directional checks, and `ConditionFeared` directional checks use
  local cursors while keeping `shared_ptr<Tile>` as the tile lifetime boundary.

Candidate follow-up work:

- Add a dispatcher-only or lock-backed borrowed tile lookup for pathfinding,
  such as `Map::getTileBorrowed` or a scoped floor/tile read view.
- Add borrowed overloads for pathfinding-only helpers after call sites are
  isolated:
  `Map::canWalkTo`, `AStarNodes::getTileWalkCost`, and tile property checks.
- Prefer read-only `BasicTile`/cache data where the full `Tile` object is not
  needed.

Contracts:

- A `MapCacheFloorCursor` must be caller-owned, stack-local, and used only for
  one synchronous search or directional walk-check batch.
- The cursor caches only floor hits. Do not cache misses in v1, because a
  later same-stack path may create or materialize map state.
- The cursor does not own a tile. Callers must keep using the returned
  `shared_ptr<Tile>` for `queryAdd`, tile property checks, and path cost
  calculation.
- A borrowed `Tile*` must not leave the pathfinding call stack.
- No pathfinding borrow may call into code that can replace the tile, unload the
  map section, run Lua, or schedule delayed work.
- If `queryAdd` or tile property checks can execute gameplay callbacks, keep a
  strong tile pin instead.
- `Floor::setTile` and `MapCache` interactions must be audited before removing
  any strong tile pin.

Required tests:

- Monster pathing near dynamic tiles, fields, doors, teleports, and creatures.
- Map reload/load-map calls while pathing is active.
- Pathfinding during movement and during async monster tasks.
- Sanitizer or debug assertions for borrowed tile lifetime where supported.

## Phase 5: item and container parent walks

Goal: reduce repeated parent `weak_ptr` locks without changing item ownership.

Candidate work:

- Cache a temporary strong parent pin inside a single function.
- Add local helper functions for parent-chain walks that clearly return either a
  strong result or a borrowed result tied to the caller's pin.
- Avoid repeated `getParent()` calls in tight loops when the parent cannot
  change inside the loop.

Contracts:

- `Item::m_parent` remains weak until a broader ownership model exists.
- Raw parent borrows cannot survive `removeThing`, `transform`,
  `postRemoveNotification`, trade, depot/house transfer, or decay scheduling.
- Lua item userdata remains shared-owned at the boundary.

Required tests:

- Item move, transform, stack merge/split, decay, container removal, trade, depot
  transfer, house transfer, and Lua item callbacks.

## Phase 6: optional deeper ownership infrastructure

Goal: only if the previous phases leave a measured lifetime overhead that still
matters.

Possible infrastructure:

- Generation-aware object registries for creatures and maybe tiles.
- Deferred retire/quiescent-state deletion for dispatcher-owned objects.
- Small-vector or arena-backed hotpath snapshots.
- Intrusive reference counting for a narrow type family, only if it can be
  proven safer than the current model.

Do not start here. This phase has high blast radius and must come after the
contracts above are enforced by tests and debug checks.

## Review checklist

Use this checklist for every performance patch that touches core object
lifetime:

- Does any raw pointer escape the current stack?
- Does any lambda capture a raw pointer or reference to a gameplay object?
- Does the code cross dispatcher, async, Lua, database, protocol, save, decay,
  or spawn boundaries?
- Is there a strong owner, weak observer, or stable identity for that boundary?
- Can the object be removed, transformed, teleported, despawned, reloaded, or
  logged out while the work is pending?
- Does the change preserve `isRemoved`, null, expired, logout, and dead-creature
  behavior?
- Does the change preserve movement, zone, Lua, decay, and notification order?
- Is the optimization tied to a before/after profile from the dispatcher
  thread?
- Are debug assertions or tests covering the new borrow contract?
- Is the change local enough to revert without redesigning ownership again?

## Decision record

The recommended direction is not a full return to manual `new`/`delete`.

The recommended direction is:

1. Keep `shared_ptr` ownership at system boundaries.
2. Reduce `shared_ptr` copies and `weak_ptr` locks inside measured hotpaths.
3. Use raw pointers only as short-lived borrowed views under an explicit owner.
4. Use IDs or generation-aware handles for delayed or hot observer lists.
5. Move deeper ownership redesign behind measured need, tests, and a separate
   design document.
