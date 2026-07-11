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

The compact validation trail for the profiling sessions behind this roadmap is
kept in [`evidence.md`](evidence.md).
Keep raw profiler dumps out of this roadmap; summarize only workload, signal,
and the decision validated.

The follow-up roadmap for bounded barrier-parallel execution, dispatcher
fairness, and eventual pure background worker jobs is kept in
[`parallel-monster-ai-roadmap.md`](parallel-monster-ai-roadmap.md).

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
- `Dispatcher::addProtocolEvent`
- `Dispatcher::addWalkEvent`
- `Dispatcher::addCreatureWalkEvent`
- `Dispatcher::addDeferredGameplayEvent`
- `Dispatcher::addBarrierEvent`
- `Dispatcher::scheduleEvent`
- `Dispatcher::cycleEvent`
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
- Do not hash a `weak_ptr` associative key from `lock().get()` or compare it by
  the live pointee. Expiration would change the key while it is stored and break
  unordered-container invariants. Zone caches use owner-stable
  `std::owner_less` ordering and synchronize insert, erase, cleanup, and clear
  with one cache mutex.
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

- `monsterPerfTestForceActive`: prevents the logical idle transition even when
  no player or target is nearby.
- `monsterPerfTestFriendlyFire`: lets hostile non-summon monsters classify other
  hostile non-summon monsters as valid opponents and use random target selection
  in the stress path.

These flags are not gameplay features. They are intended for controlled CPU and
dispatcher profiling when player load is not available. Keep them disabled in
production-like environments unless the benchmark explicitly requires them.

`monsterPerfTestForceActive` is not a full-cadence guarantee. It does not bypass
bounded queues, coalescing, adaptive background budgets, or the no-catch-up
rule. Under artificial saturation, distant monsters may therefore look idle or
advance intermittently, but the dispatcher clears their logical idle state
before background AI service. A player entering sight promotes pending movement
and post-think work to visible lanes before the asynchronous target-list
refresh; visible priority is retained for three seconds after the last player
leaves.

The implementation must keep these contracts:

- Do not make summons attack their masters or use the friendly-fire override.
- Do not make passive non-hostile monsters participate in friendly fire.
- Do not bypass protection zone, attackability, visibility, or z-level checks.
- Do not store raw creature pointers or capture borrowed pointers in delayed
  work.
- Treat runtime config toggles as best-effort for benchmarks; restarting or
  respawning monsters gives the most deterministic target-list population.

## Production-oriented optimization guardrail

The benchmark monster flags are a pressure tool, not a production requirement.
An all-map scenario with tens of thousands of monsters forced active and allowed
to fight each other is intentionally harsher than a real server workload. It is
useful because it exposes contention, queue latency, and algorithmic cliffs, but
it must not become the only reason for high-risk architecture changes.

Before accepting a risky optimization, answer these questions:

- Does the same code path run in a plausible player-heavy workload?
- Does the change improve player-visible latency, such as walk/autowalk,
  item-use retry, spell response, login, or viewport updates?
- Does the change preserve gameplay semantics when monsters are active because
  players are hunting, not because benchmark flags forced the whole map awake?
- Is the expected gain still meaningful when only a realistic subset of
  monsters is active around players?
- Can the server degrade monster AI first while keeping player input responsive?

Use stress profiles to find candidates, then validate candidates against
production-like scenarios. A useful mental model is a high-concurrency server
where thousands of players may be online, a smaller subset is actively hunting,
and only the creatures around those players are awake. The priority order is:

1. Keep player-visible work responsive.
2. Reduce shared movement, spectator, pathfinding, and protocol costs that
   occur in real hunts.
3. Improve monster-only benchmark behavior when the same change also helps real
   workloads or improves graceful degradation.

Do not optimize blindly for the benchmark if the change adds significant
lifetime, ordering, or gameplay risk and the benefit exists only when every
monster on the map is forced out of idle.

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
fixed set of `MonsterAI` lane tasks in `BarrierParallel` mode per wave. The
queue stores `weak_ptr<Creature>` entries and resolves them only when the batch
executes. This keeps the async lifetime boundary explicit while reducing task
allocation and merge churn.

The bucket queue must stay sliced into bounded batches. Monster stress can put
thousands of creatures into barrier-parallel `MonsterAI` work; draining an
entire bucket inside one task blocks all serial lanes until that barrier ends.
This can delay network tasks such as `ProtocolGame::sendLoginChallenge` and
`Connection::close` long enough to expire. When a bucket has remaining entries,
schedule a follow-up barrier task instead of continuing in the same dispatcher
pass. This preserves the async lifetime contract while preventing login/network
starvation during artificial monster stress.

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

Dispatcher fairness has a separate `DispatcherLane::Deferred` lane. This lane
is still serial dispatcher work, but only a small fixed number of tasks is
executed per dispatcher pass. It is intended for background gameplay follow-ups
that can be delayed fairly behind player/network-critical work, not for login,
protocol parsing, immediate player input, or same-tick movement contracts.
Background monster post-think uses `Deferred` in batches of 64; player-visible
post-think uses `WorldCommit` in batches of eight. Both queues store only monster
runtime IDs, re-resolve at execution, and are populated only after the
coalesced tick's target/follow decisions finish.

Player autowalk retries that are scheduled after server-side `getPathTo` checks
enter `DispatcherLane::PlayerWalk` through `Game::queuePlayerAutoWalk`. The
helper captures only the player runtime ID and the computed direction snapshot.
It must not be rewritten to capture `Player`, `Creature`, or borrowed pathing
objects across the dispatcher boundary.

Additional safe cuts applied after the dispatcher profile became cleaner:

- `Map` path searches capture the creature's current tile once per `A*` search and
  reuse it for `canWalkTo`-equivalent neighbor checks. This avoids repeated
  `Creature::getTile()` weak-locks inside the node loop without storing borrowed
  tile pointers.
- Pathfinding tile resolution now reuses a caller-owned `MapCacheFloorCursor`
  inside a single synchronous `A*` or directional walk-check scope. The cursor
  caches only resolved floors, still returns `shared_ptr<Tile>`, and still
  materializes cached map tiles through `MapCache::getOrCreateTileFromCache`.
  `Floor::getTileAndCache` reads the realized tile and pending `BasicTile`
  cache under one shared lock, then releases the lock before materialization.
- `Creature::goToFollowCreature` skips `A*` when the current position already
  satisfies the exact pathing condition, including line-of-sight checks. Flexible
  ranges such as flee or keep-distance still use `A*` because they may need a
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
the `VisibleMonsterAI` and `MonsterAI` lanes in `BarrierParallel` mode; using it
directly from those paths can trade CPU for a data race.

The next large hotspot after the low-risk async closure cuts is spectator and
movement fanout. `Spectators::getSpectators` still builds strong snapshots by
walking map sectors. Reducing that safely likely needs a per-tick immutable
relevancy cache or another synchronization-aware design, not ad hoc raw
spectator pointers.

### Post-fairness profile interpretation

After background monster post-think moved to `Deferred` and visible post-think
moved to `WorldCommit`, the original combat/check-creature spike stopped being
the dominant cause of player walk stutter. Earlier samples then showed the
remaining latency under monster stress mostly in movement and monster-follow
work:

- `Creature::processAsyncTaskBucket` and `Creature::executeAsyncTasks`: about
  42% total in the flat sample.
- `Monster::onExecuteAsyncTasks` and `Creature::goToFollowCreature`: about 17%
  each.
- `Creature::getPathTo` / `Map::getPathMatchingCond`: about 12%.
- `Map::moveCreature`: about 21%.
- `Monster::onCreatureMove`: about 11%.
- `Spectators::getSpectators`: about 10% total with high own cost.

These numbers are amplified by the artificial all-monsters-active benchmark.
The production-relevant conclusion is narrower: monster AI, pathfinding,
movement fanout, and spectator snapshots can still occupy dispatcher cycles long
enough for player movement to feel stepped. The next work should not try to make
the extreme benchmark perfectly smooth at any cost. It should make the server
degrade gracefully by preserving player-visible responsiveness while monster
work is sliced, coalesced, or delayed when load is high.

The implemented scheduler applies the conservative part of that plan:

- Dispatcher lanes record throttled queue latency, scheduled lateness, task
  runtime, lane runtime, barrier runtime, and internal work after the
  server-online log while the game state is `GAME_STATE_NORMAL`.
- Creature async work keeps 32 visible and 32 background hashed buckets. Each
  barrier task processes at most `creatureAsyncTasksPerBucket` creatures, 16 by
  default, and yields at the applicable 2 ms slice deadline before requeueing.
- `VisibleMonster` and `VisibleMonsterAI` use configured movement and barrier
  budgets. `BackgroundMonster`, `MonsterAI`, `Deferred`, and `GenericParallel`
  use adaptive budgets when player-visible latency approaches the SLO.
- Visible post-think batches eight monster IDs on `WorldCommit`; background
  post-think batches 64 IDs on `Deferred`. Each queue is capped at 16,384 IDs,
  each monster owns one pending token, and missed ticks are never replayed. A
  promotion changes queue ownership, so a stale background entry cannot execute
  or cancel the current visible token.
- Monster compute requests and completions both use separate visible/background
  queues with a 3:1 service ratio. Background admission is capped at 75% of the
  configured capacity, reserving 25% for visible requests.
- Direct player spectator IDs and a three-second hysteresis drive scheduling
  priority only. Player appearance or sight entry eagerly promotes pending walk
  and post-think work; target legality remains in the existing AI checks.
- `Monster::onCreatureMove` coalesces internal movement-AI refresh work across
  the async boundary while keeping script-visible movement, map mutation, player
  sends, tile notifications, and zone changes immediate. Follow-up tests showed
  the long reaction delay came from the artificial all-monsters-active backlog,
  not from this coalescing alone.
- Spectator cache and pathfinding ownership remain unchanged in this step.

In the final local artificial-stress sample, the bounded background `Deferred`
queue reached 16,384 entries with roughly two to three seconds of oldest age,
while player-visible p99 stayed around 20-50 ms and oldest visible work stayed
around 0-21 ms. Player walk was reported as highly responsive and nearby monster
response improved substantially. This validates graceful degradation locally;
it is not a production-hunt or 72-hour canary acceptance result.

### Follow-up priority from the validated monster-stress sample

After fixing the benchmark idle/friendly-fire activation path, the profile
shifted from apparently smooth movement to a real dispatcher-latency problem.
The table below uses the validated force-active/friendly-fire sample as a
prioritization guide. Totals overlap because call-tree percentages include
callees; do not add them together.

| Priority | Profile signal | Interpretation | Next work class |
| --- | --- | --- | --- |
| 1 | `Game::checkCreatures` deferred monster post-think: about 35% total; `Creature::onAttacking` about 31%; `Monster::doAttacking` about 29%; `CombatSpell::castSpell` about 22% | The stutter is mainly dispatcher queue latency. Monster attack/combat work is serial and can hold the same dispatcher queue that must parse player input and start walk/autowalk. | Implemented: route visible post-think through `WorldCommit`, background post-think through budgeted `Deferred`, and player autowalk retries through `PlayerWalk`. Background combat intention only filters geometric spell candidates; final legality, RNG, Lua, and commits remain serial. |
| 2 | Movement fanout: `Creature::onCreatureWalk` about 19%; `Game::internalMoveCreature` about 13%; `Map::moveCreature` about 13%; `Spectators::find` about 12% | Movement is still expensive and also serial. Even with attack batching, large monster walk bursts can delay player-visible movement. | Larger Phase 2 work: fixed update phases, coalesced monster movement notifications, and deduplicated per-tick target refresh. Must preserve movement callback order and script-visible behavior. |
| 3 | Combat/Lua/GC: `LuaScriptInterface::callFunction` about 11.5%; `lua_newuserdata` about 8.1%; `lj_gc_step` about 11.8%; `EventCallback::pushArgument`/`Lua::pushUserdata` visible inside combat | Friendly-fire stress causes many combat callbacks and userdata pushes. This is real cost, not just C++ pathfinding. | Larger combat-script work: reduce per-hit Lua userdata churn, cache immutable combat area data, and audit callback frequency. Do not bypass script-visible callbacks without compatibility gates. |
| 4 | `MapCache::getOrCreateTileFromCache` about 5.4%; `Map::getPathMatchingCond` about 4.4%; `Map::getTile` about 5.7% | Tile/pathfinding improved versus the earlier pathfinding-heavy samples, but still contributes under movement and sight checks. | Continue Phase 4 only after dispatcher fairness is remeasured. Avoid global tile/raw-pointer rewrites. |
| 5 | `Spectators::getSpectators`: about 7.7% total, 5.3% own | Sector walking and strong snapshot construction remain one of the largest direct movement-fanout self-costs. | Implemented for worker inputs: immutable spectator-derived relevance values and immutable 16x16 navigation sectors. The mutable global cache still must not be read from barrier-parallel monster AI without synchronization. |
| 6 | `__CheckForDebuggerJustMyCode`: about 4.3% own | This is profiler/build instrumentation noise, not a Canary gameplay cost. | Measurement cleanup: use a Release profile with PDBs and Just My Code disabled before making fine-grained decisions. |

Low-risk cuts already applied in response to these profiles are intentionally
small: avoid redundant async scheduling calls, reduce spectator merge churn,
batch delayed monster post-think, add a budgeted deferred lane, route
server-side autowalk retries through `PlayerWalk`, and document the remaining
contracts. Higher-impact work is no longer a mechanical `shared_ptr` cleanup;
it is an update-phase and dispatcher-fairness problem around combat, movement,
spectator relevance, and map tiles.

An earlier post-path-cursor monster-stress sample, taken before the
force-active/friendly-fire activation path was fixed, showed:

| Signal | Current sample | Notes |
| --- | --- | --- |
| `Spectators::getSpectators` | about 9.0% total, 6.3% own | Sector walking and strong snapshot construction remain the largest direct movement-fanout cost. |
| `Monster::onCreatureMove` | about 9.1% total, 5.8% own | A large part is repeated idle/target bookkeeping after every nearby move notification. |
| `MapCache::getOrCreateTileFromCache` | about 5.5% total, 4.3% own | Tile cache materialization still appears after the path cursor work, but the remaining work is narrower than the original `Map::getTile` hotspot. |
| `Map::getPathMatchingCond` | about 12.0% total, 4.1% own | Pathfinding is still relevant, but now overlaps more with combat and monster AI than with pure tile lookup. |
| `__CheckForDebuggerJustMyCode` | about 4.8% own | Measurement noise; do not optimize code around this symbol. |

Low-risk cuts from that sample:

- `Monster::onCreatureMove` should not force an idle recomputation when a move
  notification did not change the monster's friend or target lists.
- `setIdle(false)` can be idempotent for already-active monsters, but it must
  still revalidate creature-check registration because `isIdle == false` and
  `creatureCheck == true` are separate pieces of state.
- `Creature::onCreatureMove` can use the condition-type cache before calling
  the full `hasCondition(CONDITION_ROOTED)` path.
- `Map::moveCreature` deferred notifications should not copy zone sets; strong
  tile pins already keep the zone containers alive for the delayed callback.
- `Spectators::getSpectators` can reserve by the number of scanned sectors to
  reduce vector growth under dense monster stress.

Remaining higher-impact work:

- Design a movement-tick spectator/relevancy cache that is safe for
  barrier-parallel `MonsterAI`. The current static `Spectators` cache must not
  be reused from parallel monster target updates without synchronization.
- Coalesce monster movement notifications so each monster recomputes target and
  idle state once per movement batch instead of once per nearby creature move.
- Explore a typed per-creature pending-event queue instead of generic
  `std::function` closures for hot movement and AI notifications.
- Audit a borrowed tile read path for pathfinding only after map/floor/tile
  stability contracts are explicit enough to prevent stale tile access.

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
| `Monster::targetList` and `friendList` | `targetList` stores `{creatureId, weak_ptr<Creature>, countsAsPlayerOnScreen}` and `friendList` is keyed by creature ID with weak values. The weak reference remains the lifetime gate. | Raw target lists are classic use-after-free risk after death, logout, teleport, despawn, or delayed AI. ID-only storage without generation can misidentify reused IDs if reuse semantics change. Count sidecars can drift if removals bypass the target-list helpers. | Keep ID sidecars as lookup hints only, and update count sidecars through the same add/remove helpers. Replace with ID/generation handles only after removal/despawn/reuse semantics are specified. |
| `Creature` follow/attack/master/tile | Stored as `weak_ptr`; accessors lock and return `shared_ptr`. | Raw member pointers can become stale when creatures are removed or moved. | Consider handle-backed access for hot AI paths, but keep public safety semantics. |
| `Item::m_parent` | Stored as `weak_ptr<Cylinder>`; parent chain is resolved dynamically. | Raw parent can dangle after move, transform, trade, container removal, or depot/house transfer. | Keep weak parent. Optimize only local parent walks with a temporary pin or documented borrow. |
| Pathfinding | `Map::getTile`, `Map::getTileWithFloorCursor`, `Map::canWalkTo`, and `AStarNodes::getTileWalkCost` still return or consume `shared_ptr<Tile>`. The floor cursor is a synchronous lookup hint, not tile ownership. | Raw tile reads can become invalid if tile lifetime is not tied to the search scope. Reusing a cursor outside one search can observe stale floor assumptions. | Keep cursor scope local to `A*` and directional checks. Consider borrowed `Tile*` only after map/floor stability is documented and measured. |
| Dispatcher and scheduler | `TaskMeta` classifies delayed work by `DispatcherLane`, `ExecutionMode`, producer, monotonic readiness, generation, and bounded cost. Weighted deficit round robin applies per-lane budgets, aging, and producer rotation. Immediate and scheduled work share a hard 16,384-slot capacity per lane; admission is released on task start or timer cancellation. | Captured raw pointers can outlive their object by one cycle or by seconds. Per-creature fanout can amplify allocator churn. Wrong lane classification can change ordering; saturation can reject work explicitly. | Reserve before moving immediate closures, unwind producer state on rejection, and keep only audited serial inline fallbacks. Capture IDs, weak pointers, immutable values, or strong pins and re-resolve before commit. |
| Lua userdata | Core userdata stores `shared_ptr` and has special finalizer rules. | Raw or borrowed userdata can outlive the C++ object; wrong finalizer leaks or corrupts lifetime. | Follow `docs/systems/lua-shared-userdata.md`; never move core polymorphic userdata mechanically. |
| Protocol and network | Protocol events capture protocol self or player IDs before dispatching game actions. Protocol lane admission failure closes the connection. | Raw player/session pointers can outlive disconnects or connection release. Dropping a rejected callback can leave input paused or a session partially initialized. | Keep protocol self pins and player ID re-resolution, and preserve fail-closed admission. Do not pass raw gameplay objects across network callbacks. |
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
- Monster post-think re-resolves by runtime ID because monster IDs are assigned
  by a monotonic runtime counter. This rule must not be generalized to players
  because player runtime IDs are derived from GUIDs and can identify a later
  session for the same character.
- Visible and background post-think queues store only monster runtime IDs. They
  must not store `shared_ptr<Creature>`, `Monster*`, or raw tile/creature borrows
  across dispatcher turns. Combat and condition execution remain serial on the
  dispatcher; batching is a fairness mechanism, not parallel combat.
- A visible post-think batch enters `WorldCommit`; a background batch enters
  `Deferred`. Do not use either path for same-tick player input, protocol work,
  login/logout, or work that must precede the coalesced tick's target decision.
- `Game::queuePlayerAutoWalk` captures only a player runtime ID and a moved
  `std::vector<Direction>`. It is for server-side autowalk retries after
  `getPathTo`; do not capture `Player`/`Creature` ownership or borrowed map
  objects in those queued walk tasks.
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

Goal: reduce player-visible movement latency around `Map::moveCreature`,
`Monster::onCreatureMove`, monster async movement, and
`Spectators::getSpectators`.

This phase is production-oriented. The benchmark stress mode remains the
pressure test, but the target is not to make tens of thousands of forced-active
monsters perfectly smooth. The target is to keep player walk/autowalk and
nearby viewport updates responsive when many players are hunting and activating
large, but plausible, monster populations.

Implementation plan:

1. Add or collect latency signals before behavior changes:
   - Dispatcher ready-to-start age by lane, especially `PlayerWalk`,
     `VisibleMonster`, `BackgroundMonster`, `VisibleMonsterAI`, `MonsterAI`,
     `WorldCommit`, and `Deferred`.
   - Maximum queue depth and oldest pending task age per lane.
   - Long task samples for monster async buckets, `Map::moveCreature`,
     `Monster::onCreatureMove`, and `Spectators::getSpectators`.
   - Manual acceptance profiles for player walk/autowalk while benchmark flags
     are enabled and while a production-like hunt scenario is active.
2. Keep player-visible work ahead of monster-only work:
   - Ensure server-side autowalk retries and movement actions stay on the
     `PlayerWalk` lane.
   - Audit direct protocol movement/autowalk paths separately before moving
     them; do not add extra latency to packet parsing or login.
   - When overloaded, monster AI should lose precision or cadence before player
     input loses responsiveness.
3. Slice monster async movement more aggressively:
   - Review `Creature::processAsyncTaskBucket` and the number of monsters each
     bucket can process before yielding.
   - Consider a budget based on task count first; only consider time budgets if
     measurement shows count-based slicing is insufficient.
   - Requeue remaining monster work through existing async lifetime boundaries,
     storing `weak_ptr` or stable IDs, never raw creature pointers.
4. Coalesce redundant monster movement reactions:
   - Treat repeated nearby movement notifications as dirty signals for target,
     friend, and idle recomputation.
   - Recompute at most once per monster per movement batch or short tick window
     where semantics allow it.
   - Keep script-visible movement callbacks and immediate tile/zone updates in
     their current order. Only coalesce internal monster AI bookkeeping after
     auditing each call path.
5. Reduce spectator snapshot work without unsafe borrowing:
   - Prefer reusing already-built strong snapshots inside one movement flow.
   - Add per-tick immutable or dispatcher-owned spectator/relevancy caches only
     with explicit synchronization rules.
   - Do not reuse the current global `Spectators` cache from
      barrier-parallel `VisibleMonsterAI` or `MonsterAI` without making the
      cache thread-safe or dispatcher-local.
6. Revisit pathfinding only after fairness is measured:
   - Avoid broad tile/raw-pointer rewrites.
   - Prefer reducing unnecessary path recalculation, such as unchanged target
     position or already-satisfied follow distance.
   - Any path cache must fail closed and must not let monsters walk through
     forbidden tiles, fields, protection zones, teleports, or house rules.

Current Phase 2 implementation:

- `Dispatcher` records queue wait, scheduled lateness, task runtime, lane
  runtime, barrier runtime, and internal work with a monotonic clock. Tasks
  queued before the one-second post-online warm-up ends do not pollute runtime
  samples, and adaptive updates run only while the game state is normal.
- `Creature::processAsyncTaskBucket` keeps 32 visible and 32 background buckets
  and processes at most 16 creatures per barrier task by default. It checks the
  applicable 2 ms slice deadline between creatures, requeues without overlapping
  a world commit, and promotes a creature that became visible before execution.
- `VisibleMonster` and `VisibleMonsterAI` use the configured 128 movement/eight
  barrier-task limits. `BackgroundMonster`, `MonsterAI`, and `GenericParallel`
  use adaptive limits so overload reduces distant cadence first.
- Visible post-think processes eight IDs per `WorldCommit` task. Background
  post-think processes 64 IDs per `Deferred` task, whose lane drains 16 tasks per
  pass by default. Both queues are bounded and keep one coalesced tick per
  monster.
- Visible/background compute request and completion queues use 3:1 service.
  Background work can occupy at most 75% of the 2,048 default token capacity.
- A player's appearance or entry into sight promotes pending monster walk and
  post-think immediately; a three-second hold avoids priority oscillation at the
  viewport edge.
- `Monster::onCreatureMove` coalesces only internal AI bookkeeping across the
  async boundary. Script-visible callbacks, map movement, player sends, tile
  notifications, and zone changes are not coalesced. The coalesced state stores
  only a `weak_ptr<Creature>` plus old/new positions; no raw creature, tile, or
  player pointer crosses the boundary.

Candidate work:

- Split spectator collection from immediate player notification fanout so player
  sends can use borrowed `Player*` views under the existing spectator snapshot.
- Avoid repeated player visibility checks where the old stack position and move
  send use the same condition.
- Avoid duplicate `Spectators` vectors when old and new viewports overlap.
- Add explicit safe points inside any remaining single-monster call graph that
  can exceed the visible SLO; outer task slicing cannot preempt one expensive
  creature execution.
- Tune monster async bucket quotas so one wave of monster follow/pathfinding
  cannot monopolize a dispatcher pass.
- Keep cached spectator data as strong references or re-resolvable identities,
  not raw pointers.

Contracts:

- Player input, walk, autowalk, login, and protocol-critical tasks must not be
  queued behind unbounded monster AI work.
- Monster AI may be delayed or sliced under overload; gameplay safety checks may
  not be skipped.
- `monsterPerfTestForceActive` prevents logical idle but does not grant distant
  work visible priority. The benchmark is healthy when background cadence
  degrades within bounds and monsters are promoted as soon as a player sees
  them.
- Raw player borrows are valid only while the owning `Spectators` snapshot is
  alive and no delayed boundary is crossed.
- Deferred movement notifications must capture strong pins or stable IDs.
- Any callback that can run scripts or remove objects ends the safe raw borrow
  scope unless the object was pinned separately.
- Coalescing is allowed only for internal monster AI bookkeeping. It must not
  reorder `Map::moveCreature`, tile add/remove, zone changes, player viewport
  sends, Lua movement events, or combat legality checks.
- Delayed monster target refresh must fail closed: if the moved creature
  disappeared, changed floor, became invisible, entered protection, or otherwise
  became invalid, the monster must not keep attacking because of stale state.
- Any spectator data used from barrier-parallel monster AI or a compute worker
  must be immutable for the whole read window or protected by synchronization.
  A mutable global cache is not acceptable in parallel monster AI.

Required tests:

- Normal step, teleport, floor change, and forced teleport.
- Login/logout while nearby movement events are pending.
- Monster entering/leaving viewport while target lists update.
- Scripted movement events that remove, teleport, or transform involved
  objects.
- Player walk/autowalk while many nearby monsters move and retarget.
- Item use, quick loot, push creature, push item, and spell cast while monsters
  are moving nearby.
- Monsters following, fleeing, changing target, losing line of sight, crossing
  fields, and interacting with magic wall, wild growth, protection zones,
  teleports, and house tiles.
- Benchmark flags enabled as a pressure test, plus a production-like hunt load
  where only monsters near active players are awake.

Acceptance criteria:

- Player walk/autowalk feels smoother or at least does not regress in the
  production-like hunt profile.
- Oldest pending `PlayerWalk` and visible-monster work stays within the accepted
  SLO even if bounded background lanes accumulate during stress.
- No login challenge, connection close, or player-visible action task expires
  because monster AI monopolized a dispatcher pass.
- `Monster::onCreatureMove`, `Spectators::getSpectators`, and
  `Creature::processAsyncTaskBucket` do not increase in own cost after the
  change.
- No monster walks through illegal tiles, keeps a stale invalid target, stops
  waking near players, or misses script-visible movement behavior.

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

Goal: reduce `shared_ptr<Tile>` churn in `A*` tile checks.

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
