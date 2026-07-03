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

If allocator and task lifecycle symbols remain high after that change, the next
candidate is batching creature async execution by dispatcher tick rather than
creating one generic task per creature. That design must keep these contracts:

- Queue a stable creature identity or `weak_ptr`, not a raw `Creature*`.
- Preserve the existing "one pending async execution per creature" behavior.
- If new async work is added while a creature is being processed, run it in a
  later batch rather than racing the current task vector.
- Keep script, movement, and removal callbacks on the same ownership boundaries
  used today.
- Measure before replacing `Creature::sendAsyncTasks`; this is a scheduler
  design change, not a local borrow cleanup.

General game-server architecture favors fixed update phases, persistent
relevancy/state structures, and batched per-tick work over per-entity
one-shot allocation in the hot loop. Canary can move in that direction, but the
safe path is incremental: intern cheap metadata first, then design an audited
batched creature async queue, then revisit spectator and pathfinding data.

## Current contract map

| Area | Current contract | Risk if changed blindly | Safe near-term direction |
| --- | --- | --- | --- |
| `SharedObject` | Core objects use `enable_shared_from_this` and `static_self_cast`. | Removing this breaks many public APIs and Lua/event call paths. | Keep as the ownership boundary. Reduce local copies instead. |
| `Thing` and `Cylinder` | Public virtual APIs use `shared_ptr` for parents, things, items, creatures, and notifications. | Raw ownership rewrite touches movement, containers, trade, decay, Lua, combat, and notifications. | Do not rewrite globally. Add narrow borrowed helpers only where every caller is synchronous. |
| `Tile` | Stores `shared_ptr<Item>` and `CreatureVector`; exposes `shared_ptr` helpers and notifications. | Raw tile contents can dangle during remove, transform, teleport, map reload, decay, and cleanup. | Keep storage strong. Consider read-only borrowed iteration views after notification contracts are audited. |
| `Floor` and `MapSector` | `Floor::getTile` returns `shared_ptr<Tile>` under `shared_lock`; sectors store creature lists as `shared_ptr`. | Borrowing a `Tile*` without a lock or pin can race tile replacement/reload/cache changes. | Introduce tile borrow APIs only with clear lock or dispatcher-only lifetime rules. |
| `Map::moveCreature` | Receives strong creature/tile pins, builds spectator snapshots, then may defer notifications. | Any raw pointer captured by the deferred `events` lambda can outlive the current stack. | Keep deferred captures strong or use IDs/positions and re-resolve. Raw `Player*` is acceptable only for immediate fanout. |
| `Spectators` | Snapshots are `CreatureVector` of `shared_ptr<Creature>` and may be cached. | Raw spectator caches would dangle after logout/removal. | Reduce copies and allocations first. Add borrowed views only for immediate non-cached fanout. |
| `Monster::targetList` and `friendList` | Store `weak_ptr<Creature>`, lock during reads, erase expired entries. | Raw target lists are classic use-after-free risk after death, logout, teleport, despawn, or delayed AI. | Replace with ID/generation handles only after removal/despawn/reuse semantics are specified. |
| `Creature` follow/attack/master/tile | Stored as `weak_ptr`; accessors lock and return `shared_ptr`. | Raw member pointers can become stale when creatures are removed or moved. | Consider handle-backed access for hot AI paths, but keep public safety semantics. |
| `Item::m_parent` | Stored as `weak_ptr<Cylinder>`; parent chain is resolved dynamically. | Raw parent can dangle after move, transform, trade, container removal, or depot/house transfer. | Keep weak parent. Optimize only local parent walks with a temporary pin or documented borrow. |
| Pathfinding | `Map::getTile`, `Map::canWalkTo`, and `AStarNodes::getTileWalkCost` use `shared_ptr`. | Raw tile reads can become invalid if tile lifetime is not tied to the search scope. | Candidate for a borrowed `Tile*` path once map/floor stability is documented and measured. |
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

- Replace `Monster::targetList` and `Monster::friendList` storage with handles
  after defining removed/dead/logout/despawn semantics.
- Re-resolve handles through `Game` immediately before use.
- Preserve current erase-on-expired behavior as erase-on-invalid-handle.
- Keep Lua APIs returning `shared_ptr` snapshots, not raw pointers.

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

## Phase 4: pathfinding tile borrows

Goal: reduce `shared_ptr<Tile>` churn in A* tile checks.

Candidate work:

- Add a dispatcher-only or lock-backed borrowed tile lookup for pathfinding,
  such as `Map::getTileBorrowed` or a scoped floor/tile read view.
- Add borrowed overloads for pathfinding-only helpers after call sites are
  isolated:
  `Map::canWalkTo`, `AStarNodes::getTileWalkCost`, and tile property checks.
- Prefer read-only `BasicTile`/cache data where the full `Tile` object is not
  needed.

Contracts:

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
