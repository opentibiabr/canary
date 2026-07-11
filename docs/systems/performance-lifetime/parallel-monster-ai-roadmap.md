# Parallel monster AI and dispatcher fairness roadmap

This document extends the performance/lifetime roadmap with a conservative plan
for using more CPU cores without turning the game world into shared mutable
state. The goal is to reduce player-visible latency when monster AI, movement,
pathfinding, spectators, combat, and Lua callbacks create dispatcher backlog.

The target rule for background worker jobs is:

```text
Workers may compute candidates and intentions.
The dispatcher remains the single writer for gameplay state.
```

The implementation described below is code-complete, but that does not make it
production-approved. Existing barrier-parallel creature work still mutates some
creature and monster-local AI state. It remains bounded behind a barrier and
must not overlap dispatcher world commits until each remaining mutable call
graph is migrated to an immutable request/result contract.

## Implementation status

The roadmap was implemented as one review branch with independently revertible
commits. There is no feature flag or alternate scheduler fallback. Rollback must
revert the first failing behavioral commit and every later commit that depends
on it.

| Area | Implemented state |
| --- | --- |
| Measurement | `Task` uses a monotonic ready timestamp. Dispatcher telemetry separates queue wait, scheduled lateness, task runtime, lane runtime, barrier runtime, internal work, and worker completion age. The policy and clock-dependent logic are unit-testable. |
| Movement fairness | Player walk, visible/background creature walk, visible/background barrier monster AI, deferred gameplay, and world commits use distinct lanes. Player, bed, push, autowalk, protocol, and scheduled movement producers are classified explicitly. |
| Bounded compatibility work | Visible/background creature walk, barrier tasks, deferred work, worker completions, and work inside creature buckets have per-pass or per-slice limits. `BarrierParallel` still waits before dispatcher commits continue. |
| Cadence and coalescing | Monster movement refresh and post-think work keep at most one pending request per monster/work kind, preserve the oldest ready time, and never replay missed attack or movement ticks as a burst. Visible post-think runs in batches of eight on `WorldCommit`; background post-think runs in batches of 64 on `Deferred`. Queue ownership makes stale pre-promotion entries harmless. |
| Compute service | A dedicated `std::jthread` pool has bounded visible/background request and completion queues, a 3:1 visible/background policy at both stages, cancellation, token accounting, and dispatcher wakeup without workers calling gameplay APIs. One quarter of capacity is reserved from background admission for visible work. |
| Navigation reads | Lazy immutable 16x16 sector snapshots separate topology and occupancy revisions. Topology changes invalidate a result. Occupancy changes remain a hint because every committed step is checked again on the dispatcher. |
| Follow pathfinding | Monster follow paths with search radius up to 12 can run from immutable `NavCell` and `MonsterPathTraits` values. The dispatcher re-resolves IDs/generations and commits each step only through existing movement legality APIs. |
| AI intention | Workers rank copied target candidates only. Target mutation, final selection, relevance, and gameplay RNG remain on the dispatcher. Requests are latest-only and capped at 256 candidates. |
| Combat intention | Workers return geometrically eligible spell indices only. The dispatcher repeats target, floor, range, line-of-sight, zone, cooldown, reload-epoch, and generation checks before RNG, Lua, damage, effects, or conditions. Requests are latest-only and capped at 256 spells. |
| Relevance and control | Direct player spectator IDs plus a three-second hysteresis classify scheduling relevance without changing target legality. Player appearance and sight entry eagerly promote pending walk/post-think work. Adaptive reductions apply to background budgets; visible creature walk and visible barrier AI retain configured budgets. |
| Final scheduler | Fixed group draining and the legacy group abstraction were removed. Due scheduled tasks enter classified lanes. Weighted deficit round robin, aging, producer round robin, and bounded completion draining now choose ready work. |
| Admission | Every task-backed dispatcher lane has a 16,384-slot base capacity across immediate and scheduled work. `VisibleMonsterAI` and `MonsterAI` each add 32 dedicated slots for their 32 creature buckets, so ordinary lane work cannot strand a bucket continuation. Immediate enqueue reserves before moving its closure, queued work releases admission when execution starts, canceled timers release immediately, and a one-shot scheduled callback releases before queuing its successor. `WorkerCompletion` is backed instead by the compute service's 2,048 outstanding request/completion tokens; at the default capacity, background work can consume at most 1,536 and leaves 512 for visible requests. |
| Overload recovery | Protocol work fails closed by closing the connection. Rejected player walk cancels its dependent action; item pickup is committed only inside an admitted walk task. Rejected creature-bucket admission clears `AsyncTaskRunning` for every queued creature, rejected coalesced monster work releases its pending state, rejected tile materialization keeps the old tile, and serial movement/death commits retain an audited inline fallback. Worker exceptions return a dispatcher-side failure completion so monster request state cannot remain outstanding. |
| Zone cache lifetime | Zone weak caches use owner-stable `std::owner_less` ordering and one cache mutex. Expiration can no longer change a key's hash/equality while it is stored, and cleanup locks each weak owner only once. |

### Production gate status

Implementation completion is not an acceptance result. Before merge or
production rollout, all of the following remain mandatory:

- Repeat the supported release build and unit-test workflow in CI and on Linux;
  the local Windows Release build and unit suite have passed.
- Run movement, pathfinding, AI, combat, reload, shutdown, and saturation
  integration suites listed later in this document.
- Record production-like hunt p50, p95, and p99 separately from the artificial
  all-monsters-active stress workload.
- Keep added player-visible p99 at or below 50 ms in the accepted hunt workload
  and below 100 ms in the stress workload.
- Keep stale paths below 20%, compute saturation below 1%, and all queue/memory
  growth within the documented hard bounds.
- Promote behavioral commits in dependency order and hold each checkpoint for
  at least 72 hours in canary. Stop promotion and revert the failing checkpoint
  when any gate fails.
- Keep `monsterPerfTestForceActive` and `monsterPerfTestFriendlyFire` disabled
  outside controlled benchmarks.

Local validation completed after explicit authorization:

- The Visual Studio Release server target compiled successfully after the final
  scheduling and lifetime changes.
- The CMake `windows-release-enabled-tests` unit target passed 264 of 264 tests.
- Manual all-monsters-active stress kept player walk responsive while exposing
  bounded background degradation. This is diagnostic evidence, not a substitute
  for the integration, Linux, 72-hour canary, or production-hunt gates above.

## Implemented scheduler model

`TaskMeta` carries `DispatcherLane`, `ExecutionMode`, producer token, monotonic
`readyAt`, generation, and estimated cost. Metadata is frozen after admission.
Estimated cost is clamped to 1 through 32.

| Lane | Mode | Base quantum | Default pass limit |
| --- | --- | ---: | ---: |
| `ProtocolInput` | `Serial` | 8 | 256 tasks |
| `PlayerWalk` | `Serial` | 8 | 256 tasks |
| `PlayerAction` | `Serial` | 6 | 256 tasks |
| `WorldCommit` | `Serial` | 6 | 256 tasks |
| `WorkerCompletion` | `BackgroundCompletion` | 4 | `workerCompletionsPerPass` |
| `VisibleMonster` | `Serial` | 4 | configured `creatureWalkTasksPerPass` |
| `BackgroundMonster` | `Serial` | 1 | adaptive `creatureWalkTasksPerPass` |
| `VisibleMonsterAI` | `BarrierParallel` | 4 | configured `walkParallelTasksPerPass` |
| `MonsterAI` | `BarrierParallel` | 2 | adaptive `walkParallelTasksPerPass` |
| `Deferred` | `Serial` | 2 | adaptive `deferredGameplayTasksPerPass` |
| `Maintenance` | `Serial` | 1 | 16 tasks |
| `GenericParallel` | `BarrierParallel` | 1 | adaptive `walkParallelTasksPerPass` |

The scheduler consumes a lane's deficit before advancing. When oldest ready age
reaches the SLO, the lane quantum doubles up to 32. `ProtocolInput`,
`PlayerWalk`, and `PlayerAction` rotate over active producer tokens while
preserving FIFO inside each producer. Non-player-visible serial lanes share a
cumulative `dispatcherSliceDurationMs` runtime limit for the pass. Visible
monster movement and barrier AI are exempt from adaptive reductions and use the
configured limits. Background movement, background monster AI, `Deferred`,
`GenericParallel`, and completion draining use the active adaptive limits.
Scheduled callbacks reserve the same lane capacity as immediate work and are
promoted only when due.

### Runtime defaults

| Setting | Default | Reload contract |
| --- | ---: | --- |
| `creatureWalkTasksPerPass` | 128 | Applies after config reload |
| `walkParallelTasksPerPass` | 8 | Applies after config reload |
| `creatureAsyncTasksPerBucket` | 16 | Applies after config reload |
| `deferredGameplayTasksPerPass` | 16 | Applies after config reload |
| `workerCompletionsPerPass` | 64 | Applies after config reload |
| `dispatcherSliceDurationMs` | 2 | Applies after config reload |
| `dispatcherSloMs` | 50 | Applies after config reload |
| `dispatcherEmergencyMs` | 100 | Applies after config reload |
| `monsterComputeThreads` | 0 | Requires restart |
| `monsterComputeQueueCapacity` | 2048 | Requires restart; hard maximum 2048 |

With `monsterComputeThreads = 0`, hosts with at most two hardware threads run
the same request/completion algorithm inline. Larger hosts use
`clamp((hardware_concurrency - 2) / 2, 1, 4)` dedicated workers. Worker count and
queue capacity are fixed when the service starts.

The compute token follows a request until its completion is consumed. Request
selection and completion draining both use a 3:1 visible/background ratio. At
the default capacity, background admission stops at 1,536 outstanding tokens so
that 512 remain available for work that becomes player-visible.

### Benchmark overload semantics

`monsterPerfTestForceActive` prevents the logical idle transition; it does not
disable queue bounds, coalescing, adaptive budgets, or the no-catch-up contract.
Consequently, a distant monster can look idle when the artificial benchmark
saturates background queues even though the dispatcher has already cleared its
logical idle state and its AI remains eligible for service. This is intentional
graceful degradation as long as visible work remains within its SLO.

When a player appears or crosses into a monster's sight, the monster records the
player in its direct spectator IDs before the asynchronous target-list update,
promotes pending walk and post-think work, and keeps visible priority for three
seconds after the last player leaves. A monster that remains unresponsive after
that promotion is a correctness failure, not expected overload behavior.
`monsterPerfTestFriendlyFire` applies only to hostile non-summon monsters;
passive monsters retain their normal follow and target behavior.

## Problem statement

Canary can show acceptable total CPU usage while one dispatcher/main gameplay
path becomes the visible bottleneck. Under monster-heavy load, player walk,
autowalk, input, and protocol-critical work can wait behind monster movement,
monster AI, pathfinding, spectator fanout, combat, conditions, and Lua
callbacks.

Existing performance-lifetime work already reduced several hot costs:

- Creature async work is split across 32 visible and 32 background buckets in
  `VisibleMonsterAI` and `MonsterAI`, both in `BarrierParallel` mode.
- Visible monster post-think uses `WorldCommit`; background post-think uses the
  budgeted `Deferred` lane. Both queues store IDs and enforce one pending tick
  per monster.
- Pathfinding and tile lookup reuse scoped local cursors.
- Monster target lists and condition checks avoid some repeated weak-lock and
  scan costs.
- Monster movement AI refresh is coalesced for internal bookkeeping.

The remaining architecture issue is not only CPU throughput. It is queue
fairness and player-visible latency. `BarrierParallel` runs work on multiple
threads, but the dispatcher still waits for the selected batch to finish before
continuing. Player walk uses `PlayerWalk`; monster movement uses
`VisibleMonster` or `BackgroundMonster` according to direct player visibility.

## Current execution model

Canary already uses multiple CPU cores. The shared `ThreadPool` defaults to
`std::thread::hardware_concurrency()`, the dispatcher runs as a long-lived task
in that pool, and `Dispatcher::asyncWait` partitions parallel slices across the
dispatcher thread and available workers.

`BarrierParallel` is therefore parallel for throughput, but it is still a
dispatcher barrier:

```text
dispatcher starts BarrierParallel batch
  -> dispatcher executes one partition
  -> worker threads execute the other partitions
  -> dispatcher waits for every partition
  -> dispatcher advances to serial world commits and later lanes
```

The barrier currently has two effects:

- It allows a wave of creature work to use multiple cores.
- It prevents the dispatcher from advancing into new world commits while the
  wave is still running.

The second effect is part of the current synchronization model. Existing
`Creature::executeAsyncTasks` and `Monster::onExecuteAsyncTasks` paths may
change target lists, idle state, follow state, path state, and other actor-local
AI fields. `safeCall` redirects selected world mutations to the dispatcher, but
it does not make the whole async call graph pure.

The current practical invariant is therefore narrower than single-writer
gameplay:

```text
Dispatcher code owns world commits.
Audited actor-local AI mutation may run in a barrier-parallel phase.
The dispatcher does not overlap that phase with later gameplay lanes.
```

This barrier reduces overlap; it is not proof that every existing async field
access is race-free. New work must not remove the wait or detach current
`BarrierParallel` tasks without first replacing mutable reads and writes with an
explicit ownership, snapshot, or synchronization contract.

## Design principles

- Player-visible work has a latency target.
- Monster work has guaranteed progress.
- Monster movement or combat near a player is also player-visible. Do not
  classify every monster task as background solely because its actor is a
  monster.
- Monster AI may lose cadence or precision under overload before player input
  loses responsiveness.
- Background workers must treat the dispatcher as the single writer for mutable
  gameplay state.
- Existing barrier-parallel mutation is a compatibility mode that must remain
  bounded and must not be generalized to detached background jobs.
- No lane receives unlimited strict priority. Player-visible lanes have latency
  protection, while monster lanes have minimum service and aging.
- Worker results are suggestions. The dispatcher re-resolves and revalidates
  before applying anything.
- Stale worker results must fail closed.
- No catch-up bursts: a monster that lost cadence must not apply several
  delayed attacks or moves in one burst just because worker jobs completed late.
- Every phase must be measurable and reversible.

## Non-goals

- Do not rewrite the whole dispatcher as the first step.
- Do not remove the `BarrierParallel` wait as a shortcut to concurrency.
- Do not move Lua execution to worker threads.
- Do not run `Map::moveCreature`, `Game::internalMoveCreature`, combat damage
  application, tile notifications, zone changes, or client sends from worker
  threads.
- Do not bypass `queryAdd`, protection zones, fields, magic wall, wild growth,
  house tiles, teleports, floor changes, line of sight, range, cooldown, or
  script-visible legality checks.
- Do not optimize the all-monsters-active benchmark until it is perfectly
  smooth at the expense of production-like behavior.

## Threading contract

### Execution mode A: barrier-parallel compatibility

This is the current `BarrierParallel` model. The dispatcher starts a bounded wave,
participates in it, waits for all partitions, and only then advances.

Rules:

- Existing mutable creature AI work may stay in this mode only while its full
  call graph is audited for cross-creature and shared-world access.
- The dispatcher must not overlap later world commits with the wave.
- Both the number of queued tasks and the work inside each task must be bounded.
- A task that processes a bucket must yield through a continuation between
  creatures or small work units; a task-count budget alone is insufficient.
- Moving a task from this mode to background execution requires a separate
  review and payload contract.

### Execution mode B: concurrent background jobs

This is the target model for new path, AI, and combat-intention jobs. The
dispatcher continues processing while workers compute from immutable or
explicitly synchronized inputs.

Rules:

- Background jobs may not use current mutable creature objects as their working
  state.
- Requests and results cross bounded queues as values, stable identities, or
  immutable snapshots.
- Results return through a dedicated completion path and are only suggestions.
- All gameplay commits, Lua calls, random gameplay decisions, cooldown changes,
  and network-visible effects remain on the dispatcher.

### Transition gate

Do not convert an existing barrier-parallel task into a concurrent background
job by changing only its queue or removing `retFuture.wait()`.

Before migration, document:

- Every mutable object read or written by the call graph.
- The owner of each input snapshot.
- The invalidation or version rule.
- The completion queue and its backpressure rule.
- Dispatcher-side revalidation and commit.
- Shutdown and cancellation behavior.

### Allowed worker work

Concurrent background jobs may do pure or effectively pure computation from an
immutable input snapshot:

- Path candidate calculation.
- Next-step or follow-position candidate calculation.
- Preliminary target ranking from copied IDs, positions, and static monster
  type data.
- Preliminary attack intention selection, such as "monster wants to use spell X
  on target Y".
- Costly filtering over explicitly copied or immutable data.

Random rolls that affect gameplay, cooldown advancement, target-list mutation,
and spell application are not preliminary computation. Keep them on the
dispatcher unless a later design defines deterministic, replayable semantics.

### Forbidden worker work

Concurrent background jobs must not:

- Mutate creatures, monsters, players, items, tiles, map sectors, containers,
  conditions, combat state, or spectator state.
- Call Lua or any callback that may enter Lua.
- Call `Game::internalMoveCreature`, `Map::moveCreature`, combat application,
  tile add/remove notifications, zone changes, or client send functions.
- Capture raw gameplay pointers or references across the worker boundary.
- Store `shared_ptr` pins indefinitely in worker queues.
- Read mutable global caches unless the cache is explicitly immutable for the
  whole read window or protected by synchronization.
- Call the current per-thread dispatcher enqueue path from an unregistered
  worker pool. New pools require an explicit multi-producer completion queue or
  a safe thread-registration contract.

### Result application

Every worker result must return to the dispatcher through a completion queue.
The dispatcher must re-resolve by stable identity or weak reference and validate
at least:

- The monster still exists, is alive, and was not removed.
- The target still exists, is alive, visible, and legal.
- The monster and target are still in compatible positions/floors.
- The result still matches the expected start position or state version.
- The result belongs to the current request generation and was not superseded.
- Movement still passes final `queryAdd` and tile legality.
- Combat still passes line of sight, range, zone, protection, cooldown, and
  spell legality.
- Any script-visible callback still runs on the dispatcher.

If validation fails, discard the result or schedule a fresh lower-priority
recompute. Do not partially apply stale state.

## Backpressure contract

Parallelism must not turn queue latency into memory pressure or delayed bursts.

- Keep at most one pending job per monster per job kind where possible.
- Coalesce repeated movement/target/follow invalidations into dirty flags.
- Coalesce overdue think requests according to an explicit cadence contract;
  do not queue one future attack for every missed interval.
- Preserve the oldest enqueue time for metrics and aging.
- Replace or mark older queued work stale when a newer snapshot supersedes it.
- Bound worker queues globally and per lane.
- Bound dispatcher completion processing per pass.
- Reject, replace, or defer new jobs when a queue is full. Never allow an
  unbounded queue to become the overload policy.
- Dispatcher immediate and scheduled work share a hard 16,384-slot base cap per
  lane. The two creature-AI lanes add 32 dedicated bucket slots each, retaining
  a hard bound while preventing ordinary work from consuming every continuation
  slot. Admission is reserved before an immediate closure is moved, so an
  ordinary rejection leaves the caller-owned closure available for an audited
  fallback.
- Admission counts queued work, not callbacks that have started. A canceled
  timer releases immediately, and a one-shot scheduled callback releases before
  it queues a successor. This prevents cancellation churn or a full lane from
  blocking a bounded recurring chain from replacing itself.
- Protocol input, handshake, delayed protocol callbacks, and barrier-originated
  output fail closed by closing the connection instead of dropping work while
  leaving a paused buffer or partial session unresolved.
- Rejection must unwind producer state. Player autowalk does not install its
  dependent action or pick up its item before admission, creature buckets clear
  `AsyncTaskRunning` on rejected entries, monster post-think consumes its
  pending token, creature checks become retryable, and Lua timer registration
  releases registry references when scheduler admission fails.
- A worker exception is converted into a prebuilt failure completion. That
  completion runs on the dispatcher, applies generation-aware cleanup, and
  retains the compute token until the cleanup is consumed.
- The compute service accepts at most 2,048 outstanding request/completion
  tokens. A token is released only when its completion is consumed or shutdown
  cancels the request.
- Background compute admission is capped at 75% of capacity. The remaining 25%
  is reserved for visible requests, and visible/background completions are
  drained with the same 3:1 policy as requests.
- Target, path, and combat requests are latest-only per monster and kind. A full
  compute queue rejects the request and returns control to the dispatcher; it
  never creates an unbounded fallback queue.
- Leave CPU headroom for the dispatcher, network, database, and operating
  system. Do not assume all hardware threads should run monster AI.

## Roadmap

### Phase 0: measurement and guardrails

Status: implemented in code. Windows Release and unit validation passed;
production baselines and integration validation remain pending.

Priority: highest.

Goal: distinguish queue wait, scheduled-event lateness, barrier time, and task
runtime before changing scheduling behavior.

Work:

- Build a deterministic dispatcher test harness with an injectable clock or
  equivalent control over enqueue time, due time, and execution order.
- Track queue depth, enqueue-to-start age, oldest age, and oldest context per
  dispatcher lane.
- Track scheduled-event lateness as `actualStart - dueTime`. Player walk may be
  late before `Creature::onCreatureWalk` creates a `PlayerWalk` task, so
  `PlayerWalk` queue age alone is not sufficient.
- Track per-lane wall time, parallel-barrier wall time, longest task, and long
  task context.
- Track nested work units in addition to task count:
  - creatures processed by each async bucket task;
  - monsters processed by each post-think task;
  - continuations and requeues;
  - path requests and expanded nodes once worker jobs exist.
- Track player-visible latency:
  - network receive enqueue to protocol parse start;
  - input to walk commit;
  - scheduled walk due time to walk commit;
  - autowalk queue age;
  - cancel walk latency;
  - protocol-critical serial task age.
- Track monster lateness:
  - AI think lateness;
  - attack think lateness;
  - movement refresh lateness;
  - stale worker result count once workers exist.
- Track thread-pool pressure:
  - active and queued work;
  - barrier worker utilization;
  - completion queue depth;
  - dispatcher idle and busy time.
- Keep startup and immediate post-online warm-up backlog out of runtime
  telemetry.
- Use `std::chrono::steady_clock` or the existing latency metrics for sub-cycle
  runtime. Do not use cached `OTSYS_TIME()` to measure a lane or task inside one
  dispatcher cycle.
- Record separate p50, p95, and p99 baselines for a production-like hunt and
  the artificial all-monsters-active stress profile. Set numeric SLOs from the
  production-like baseline instead of inventing constants from the stress run.

Acceptance:

- A profile can show whether latency was spent waiting in `WorldCommit`, waiting
  for a scheduled walk event, executing `PlayerWalk`, waiting at a
  `BarrierParallel` barrier, or committing movement.
- A slow `BarrierParallel` wave identifies both the outer task count and the inner
  creature work that caused it.
- Deterministic tests cover FIFO within a lane and producer, expiration, continuation,
  requeue, scheduled due order, and no task loss after a budgeted slice.
- A production-like hunt profile and the artificial monster stress profile are
  recorded separately.
- Metrics do not change scheduling behavior yet.

Risks:

- Logging can add noise in hot paths.
- High-cardinality contexts or actor IDs can overload the metrics backend.
- Startup backlog can be misread as runtime starvation.
- A cached wall clock can report zero runtime for work performed inside one
  dispatcher cycle.

Mitigation:

- Throttle logs.
- Aggregate actor metrics and sample long contexts rather than exporting an
  unbounded label set.
- Enable queue latency after the server is online and in normal game state.
- Use a monotonic clock for latency and wall-time measurement.

### Phase 1: bounded fairness in the current barrier model

Status: implemented. The compatibility barrier remains intentionally intact.

Priority: highest.

Goal: protect player-visible walk and serial protocol work from unbounded
monster movement batches without removing the synchronization barrier.

Work:

- Separate task priority from movement-phase semantics. Use audited predicates
  such as `isMovementCommit()`, `isBarrierParallel()`, and `isPlayerVisible()`
  instead of relying on a concrete queue identifier.
- Update every behavior that currently depends on movement classification, including:
  - deferred tile post notifications and zone changes in `Map::moveCreature`;
  - coalesced movement AI refresh in `Monster::onCreatureMove`;
  - monster push-creature behavior;
  - async context and `safeCall` assumptions.
- Separate player-visible walk from generic creature walk.
- Keep player walk and server-side player autowalk retries on `PlayerWalk`.
- Route non-player creature walk through a distinct creature-walk lane or an
  equivalent budgeted path.
- Audit every direct `addWalkEvent` call instead of assuming all calls originate
  from `Creature::onCreatureWalk`. Bed movement, player push, autowalk retry,
  and monster push follow different gameplay contracts.
- Execute creature walk with a fixed per-pass budget.
- Execute `BarrierParallel` work in bounded slices instead of draining all pending
  tasks before the dispatcher can continue.
- Keep the wait for each selected `BarrierParallel` slice. This phase reduces the
  maximum barrier; it does not make current mutable async work concurrent with
  the dispatcher.
- Bound work inside each `Creature::processAsyncTaskBucket` task. A slice of
  eight bucket tasks is not small if each bucket still performs expensive work
  for many creatures.
- Check an elapsed-time or work-unit limit between creatures and requeue a
  continuation. Time checks do not preempt one creature call graph, so long
  individual tasks must still be split at explicit safe points.
- Keep `Deferred` budgeted and tune only from measured latency.
- Measure due player-walk event lateness. If it exceeds the player SLO, add a
  classified scheduled-walk path that can become runnable before the next
  monster barrier without executing arbitrary scheduled callbacks early.
- Give creature and monster lanes a static minimum service guarantee. Do not
  use strict player priority that can starve the simulation.

Acceptance:

- Player walk no longer shares an unbounded queue with general creature walk.
- `BarrierParallel` cannot monopolize one dispatcher pass.
- Remaining barrier work is preserved and continues in later passes.
- The `VisibleMonster` and `BackgroundMonster` lanes preserve movement
  deferral, notification, coalescing, and `safeCall` behavior.
- Player scheduled-walk lateness and protocol input queue age stay within the
  recorded production SLO.
- Monster movement still progresses under normal hunt load.

Risks:

- Too low a creature-walk budget can make monsters move in visible waves.
- Changing lane order can alter same-tick behavior.
- Existing async context checks may depend on barrier execution semantics.
- Code that infers movement semantics from a concrete lane can silently take a
  different path after lane classification changes.
- A task-count budget can hide expensive nested work.

Mitigation:

- Start with conservative budgets.
- Factor semantic context checks before routing tasks to the new lane.
- Do not move async-only monster work into a serial context accidentally.
- Keep the barrier and tune both outer and inner slices.
- Keep changes narrow and measure queue age before tuning.

### Phase 2: static backpressure and cadence control

Status: implemented for movement refresh, post-think, latest-only worker kinds,
lane admission, and no-catch-up attack/movement semantics.

Priority: high.

Goal: prevent redundant monster work and delayed catch-up bursts before adding
new background threads.

Work:

- Extend the existing per-monster movement AI coalescing rather than replacing
  it with a second global system immediately.
- Preserve the first enqueue time when later invalidations merge into the same
  work item.
- Allow at most one pending work item per monster and work kind where semantics
  permit it.
- Add explicit dirty flags for internal target, friend, idle, and follow-path
  refresh.
- Define a separate cadence contract for monster post-think, attacks, and
  conditions:
  - an overdue monster must not replay several attacks in one dispatcher turn;
  - condition timing must preserve its documented elapsed-time semantics;
  - coalescing a think request must not silently skip required condition
    transitions.
- Coalesce or supersede stale path and AI requests before they reach a future
  worker queue.
- Bound deferred gameplay and per-monster pending state. A full queue must
  reject, replace, or postpone work according to an explicit policy.
- Add counters for coalesced work, superseded work, oldest pending age, and
  prevented catch-up actions.

Acceptance:

- Repeated movement notifications produce at most one pending internal refresh
  per monster for the coalescing window.
- Artificial backlog does not cause a burst of delayed attacks or moves when it
  clears.
- Near-player monsters continue to move, retarget, attack, and execute required
  conditions under a production-like hunt profile.
- Every bounded queue exposes saturation and rejection or replacement counts.

Risks:

- Over-broad coalescing can hide enter/leave events or condition transitions.
- A single dirty bit may lose the reason that a conservative full refresh is
  required.
- Delaying conditions and delaying attacks have different gameplay semantics.

Mitigation:

- Coalesce only internal bookkeeping, never script-visible movement callbacks,
  map mutation, tile notifications, zone changes, client sends, or final combat
  legality.
- Fall back to a full dispatcher-side refresh when merged detail is
  insufficient.
- Test attack cadence and condition cadence independently.

### Phase 3: worker substrate, payloads, and immutable read contracts

Status: implemented with a dedicated bounded compute service and immutable
navigation snapshots.

Priority: high after Phase 1 and Phase 2 are stable.

Goal: build the infrastructure required for true background jobs before moving
gameplay computation onto it.

Work:

- Decide explicitly between:
  - the shared pool with reserved capacity and admission control;
  - a dedicated monster-compute pool with an independent request/completion
    queue.
- Do not submit detached monster work to the shared pool without proving that
  the long-lived dispatcher, database, save, and other services retain progress.
- Do not call the current `Dispatcher::getThreadTask` path from arbitrary new
  worker threads. Its thread-indexed storage is sized around the existing pool
  assumptions.
- Add bounded multi-producer request and completion queues or an equivalent
  registered-thread design.
- Add a budgeted dispatcher completion lane. Completion processing itself must
  not become a new unbounded high-priority queue.
- Define shutdown ordering:
  - stop accepting requests;
  - mark the current world/job epoch closed;
  - cancel or drain workers according to job type;
  - discard late results;
  - destroy queues and pools only after producers stop.
- Add small request/result structs using runtime IDs, generation or request
  tokens, positions, timestamps, and state versions where appropriate.
- Use weak references only as ownership gates on dispatcher boundaries, not as
  mutable worker state.
- Define an immutable or explicitly synchronized spatial read model before
  background pathfinding:
  - static topology and base walkability;
  - dynamic blockers and occupancy;
  - sector or region revisions;
  - snapshot ownership and lifetime.
- Treat a `shared_ptr<Tile>` as a lifetime pin, not as proof that tile contents
  are immutable while the dispatcher continues.
- Add a synthetic no-op or pure-compute job to validate queue bounds,
  completion order, cancellation, and shutdown before a gameplay job uses the
  substrate.

Example payload shape:

```cpp
struct MonsterPathRequest {
	uint32_t monsterId = 0;
	uint32_t targetId = 0;
	Position startPosition;
	Position targetPosition;
	uint64_t requestGeneration = 0;
	uint64_t worldEpoch = 0;
};

struct MonsterPathResult {
	uint32_t monsterId = 0;
	uint32_t targetId = 0;
	Position startPosition;
	Position targetPosition;
	uint64_t requestGeneration = 0;
	uint64_t worldEpoch = 0;
	std::vector<Direction> candidatePath;
};
```

Acceptance:

- Worker and completion queues have hard capacities and observable saturation.
- A synthetic job can complete while the dispatcher continues servicing
  player-visible work.
- Late results from shutdown, reload, or an old world epoch are discarded.
- Unknown worker threads cannot index dispatcher per-thread storage out of
  bounds.
- No gameplay job starts before its immutable read and dispatcher commit
  contracts are documented.

Risks:

- A second pool can oversubscribe the machine.
- The shared pool can starve services that were previously assumed to make
  progress.
- Completion fanout can move the backlog from workers back to the dispatcher.
- A global world version can invalidate too much work, while an incomplete
  regional version can accept stale work.

Mitigation:

- Reserve CPU capacity and expose worker count as configuration.
- Use hard request and completion limits.
- Prefer region or sector revisions plus final legality checks over trusting one
  version as the sole safety gate.
- Validate the substrate without gameplay mutation first.

### Phase 4: parallel path candidate jobs

Status: implemented for bounded monster follow paths with radius up to 12.

Priority: high after Phase 3.

Goal: move expensive path candidate computation off the dispatcher while
keeping every movement commit serial and legal.

Work:

- Allow at most one outstanding path request per monster and path purpose.
- Copy or reference only the immutable spatial snapshot required by the search.
- Compute a candidate path or next direction in the worker.
- Return the candidate to the budgeted dispatcher completion lane.
- Re-resolve monster and target and verify request generation, world epoch,
  current positions, and relevant region revisions.
- Treat the path as a hint. At each actual step, use the existing dispatcher
  movement path and rerun final `queryAdd`, tile, field, zone, floor, and dynamic
  occupancy checks.
- Discard or replace stale results. Do not apply an entire path merely because
  it was valid when the worker started.

Acceptance:

- Worker path jobs reduce dispatcher wall time spent in path search.
- A stale candidate never moves a monster through a forbidden or changed tile.
- Request, result, stale-drop, search-runtime, and expanded-node metrics are
  available.
- Worker saturation does not grow memory or dispatcher completions without
  bound.

Risks:

- Snapshot construction can cost more than the path search it replaces.
- Dynamic blockers can make many results stale.
- Repeated stale recomputation can become a feedback loop.

Mitigation:

- Measure snapshot cost separately.
- Use per-monster admission and recompute cooldowns.
- Revalidate each committed step and fail closed.

### Phase 5: parallel monster AI intention jobs

Status: implemented for copied target-candidate ranking. Final selection and all
mutation remain dispatcher-owned.

Priority: medium.

Goal: move heavier monster decision work off the dispatcher without applying
state off-thread.

Work:

- Compute preliminary target ranking, follow preference, and attack candidates
  from copied IDs, positions, immutable type data, and explicit snapshot data.
- Keep target-list mutation, final target selection, follow-state mutation, and
  random gameplay choices on the dispatcher.
- Migrate one audited call graph at a time. Existing mutable
  `BarrierParallel` AI remains behind the barrier until its inputs and outputs are
  converted.
- Coalesce multiple invalidations into one pending generation per monster.
- Use cheap existing relevance state where possible. Do not perform a new
  spectator search solely to decide queue priority.
- Give nearby or player-engaged monsters a latency target while preserving a
  minimum service guarantee for distant monsters.

Acceptance:

- Monsters continue reacting in production-like hunts.
- Under overload, distant background AI loses cadence before nearby
  player-visible monster behavior.
- No worker mutates target lists, follow state, random generator state, Lua
  state, or gameplay objects.
- Stale and superseded AI results are observable and bounded.

Risks:

- AI timing and random target selection can change combat feel.
- Snapshot data can miss visibility, floor, target, or faction changes.
- Relevance priority can starve distant monsters if it becomes strict priority.

Mitigation:

- Keep random choices and final target legality on the dispatcher.
- Treat relevance as a scheduling hint, never final legality.
- Apply minimum service and aging to every background lane.

### Phase 6: monster combat intention split

Status: implemented for pure spell geometry. Combat legality, RNG, Lua,
cooldowns, and effects remain dispatcher-owned.

Priority: medium-low.

Goal: separate expensive monster attack preparation from serial combat
application without changing damage, cooldown, Lua, or random-roll semantics.

Work:

- Split monster attack work into:
  - a degradable candidate or intention phase;
  - a serial dispatcher validation and commit phase.
- Let workers rank immutable spell candidates or evaluate pure geometric data.
- Keep chance rolls, cooldown advancement, attack tick mutation, Lua callbacks,
  spell execution, damage, conditions, visual effects, and sends on the
  dispatcher.
- Revalidate monster, target, range, line of sight, floor, zone, protection,
  cooldown, spell availability, and script-visible rules immediately before
  commit.
- Do not accumulate missed attacks. An overdue monster loses cadence instead of
  replaying several attacks in one burst.
- Keep condition progression under a separately documented elapsed-time
  contract; it must not be treated as interchangeable with an attack attempt.

Acceptance:

- Monster attack preparation can lose cadence under overload without blocking
  player walk.
- Every gameplay-visible combat effect still comes from the existing serial
  legality and Lua paths.
- Delayed or stale intentions cannot create duplicate attacks.
- Random and cooldown behavior remains deterministic under the existing
  dispatcher ordering contract unless an intentional compatibility change is
  separately approved.

Risks:

- Same-tick spell ordering and Lua behavior can change subtly.
- Friendly-fire stress can create extreme intention fanout.
- Moving a random roll to workers can make behavior scheduling-dependent.

Mitigation:

- Start with a small subset of pure monster-only preparation.
- Keep random rolls and all gameplay mutation on the dispatcher.
- Preserve existing combat application APIs and test Lua callbacks that remove,
  teleport, transform, or kill participants.

### Phase 7: spectator and relevancy snapshots

Status: implemented for immutable relevance snapshots and hysteresis. A general
cross-event spectator cache was deliberately not added because it is not needed
for the current worker contracts and still requires separate measurement.

Priority: medium-low.

Goal: reduce repeated spectator work and provide cheap relevance hints without
creating a mutable global cache race.

Work:

- Build immutable per-tick, per-movement, or versioned sector snapshots only
  where the measured reuse justifies construction cost.
- Use strong ownership in snapshots or re-resolvable identities.
- Allow borrowed `Player*` views only while the owning snapshot is alive and no
  delayed boundary is crossed.
- Keep current map-sector creature lists dispatcher-owned unless a separate
  immutable publication or synchronization design is introduced.
- Use relevance signals to classify monster work:
  - near active players;
  - visible to players;
  - in combat with players;
  - distant or background.
- Treat relevance as a scheduler hint, not final movement, visibility, send, or
  combat legality.

Acceptance:

- Reused snapshots reduce measured sector walking or spectator materialization.
- No mutable global spectator cache is read concurrently without an explicit
  synchronization contract.
- Relevance improves nearby player-visible latency while distant monsters retain
  guaranteed progress.

Risks:

- Snapshot construction can duplicate expensive work or retain objects too
  long.
- Stale visibility can cause missed sends or illegal attacks if used as final
  truth.
- Borrowed pointers can outlive their snapshot.

Mitigation:

- Scope snapshots tightly and measure build versus reuse cost.
- Keep raw borrows under strong snapshot ownership.
- Revalidate all gameplay legality on the dispatcher.

### Phase 8: adaptive budgets and aging

Status: implemented with static bounds, SLO/emergency thresholds, hysteresis,
lane minimums, sustained-emergency warning gating, and WDRR aging.

Priority: medium-low.

Goal: tune fairness dynamically after static limits and backpressure are proven.

Work:

- Maintain per-lane state for:
  - task count and nested work units;
  - elapsed wall-time budget checked at safe yield points;
  - oldest queue age;
  - target and emergency latency;
  - guaranteed minimum progress;
  - saturation and rejected or replaced work.
- Reduce monster background budgets when player walk, scheduled-walk lateness,
  or protocol input exceeds its target.
- Increase monster budgets when player-visible lanes are healthy and monster
  queues age.
- Add hysteresis and gradual changes so the controller does not oscillate.
- Apply emergency budgets immediately, but require four consecutive emergency
  windows before escalating the state transition from debug telemetry to a
  warning.
- Apply per-player or per-actor admission control where one producer can flood a
  high-priority lane.
- Keep hard minimum and maximum budgets. No lane may become unbounded because a
  controller requests more work.

Acceptance:

- Player-visible p95 and p99 stay within the recorded production SLO under the
  accepted hunt workload.
- Monster lanes retain measurable minimum progress under overload.
- Queue depth remains bounded, and every rejection or supersession policy is
  observable.
- Budget changes settle instead of oscillating continuously.

Risks:

- Feedback can oscillate or react to stale metrics.
- Strict emergency priority can starve monsters or be abused by input flood.
- Too many independent knobs can make behavior impossible to reason about.

Mitigation:

- Start with one or two threshold rules and hysteresis.
- Tune from production-like traces, not only the artificial benchmark.
- Preserve hard lane minimums, maximums, and admission control.

### Phase 9: dispatcher lane rework

Status: implemented. The legacy group abstraction and obsolete async wrappers
were removed only after lane classification was complete. Focused enqueue
wrappers remain as lane-classification APIs.

Priority: last.

Goal: replace fixed group draining with an explicit latency/fairness scheduler.

This is the point where a dispatcher rework becomes justified, because earlier
phases will have produced:

- Queue-age metrics.
- Clear lane definitions.
- Safe worker payloads.
- Validated completion queues.
- Scheduled-event lateness and classification.
- Known budgets and workload classes.

Implemented lane model:

- `ProtocolInput`
- `PlayerWalk`
- `PlayerAction`
- `WorldCommit`
- `WorkerCompletion`
- `VisibleMonster`
- `BackgroundMonster`
- `VisibleMonsterAI`
- `MonsterAI`
- `Deferred`
- `Maintenance`
- `GenericParallel`

Scheduling policy:

- Weighted deficit round robin by lane and estimated task cost.
- Aging based on oldest enqueue time.
- Producer-token round robin inside protocol and player-produced lanes.
- Explicit minimum progress for monster lanes.
- SLO and emergency protection for player-visible lanes with hysteresis.
- Budgeted worker completion processing.
- Classified due scheduled work instead of one unbounded scheduled phase.
- Hard lane admission and explicit saturation rejection.
- No unbounded parallel batch barrier before player-visible work.

Acceptance:

- The scheduler can express latency targets and progress guarantees directly.
- Player-visible work is protected without starving monsters.
- The legacy group abstraction and obsolete async wrappers have no remaining
  source callsites.
- Same-tick gameplay contracts are documented where they must remain stable.

Risks:

- High blast radius across protocol, movement, combat, Lua, scheduler, and
  shutdown behavior.
- Same-tick ordering changes can create subtle gameplay regressions.
- Pre-migration code may still infer behavior from old fixed-drain ordering.
- Moving scheduled callbacks earlier can violate same-tick assumptions.

Mitigation:

- Keep the implementation commits independently revertible.
- Do not remove the compatibility barrier from mutable actor-local work.
- Require integration tests and queue-latency acceptance before production
  rollout.

## Implementation commit sequence

Keep the implementation in one review branch and one pull request, with each
step as an independently reviewable and revertible commit.

1. Metrics and deterministic dispatcher tests, with no scheduling change.
2. Movement-context predicates and an audit of concrete movement-lane checks.
3. Player-walk and creature-walk lane split with behavior-preserving routing.
4. Bounded barrier outer slices and bounded inner creature-bucket work.
5. Static backpressure, post-think cadence, and no-catch-up rules.
6. Worker request/completion substrate and shutdown tests with a synthetic job.
7. Immutable spatial read model and parallel path candidates.
8. AI intention migration one audited call graph at a time.
9. Combat intention experiments behind targeted compatibility tests.
10. Adaptive budgets, then the dispatcher lane rework only if measurements
    still justify it.

## Worker pool sizing

Canary creates its shared pool from hardware concurrency by default, and the
dispatcher occupies one long-lived shared-pool task. Barrier-parallel waves use
the remaining shared-pool workers while the dispatcher executes one partition
and waits.

Pure monster compute uses a separate bounded pool. The automatic worker formula
leaves two hardware threads out of its calculation and caps the result at four,
but the shared pool still exists. Simultaneous shared-pool and monster-compute
load can therefore oversubscribe a host and must be measured in canary. Pool
topology is part of the production gate, not a tuning detail.

Requirements:

- Keep worker count configurable and observable.
- Reserve capacity for the dispatcher, network IO, database/save work, logging,
  compression, and the operating system.
- Start with a conservative cap or fraction of hardware concurrency. Do not
  hard-code all available logical CPUs as monster workers.
- Account for both the existing shared pool and any dedicated pool when
  avoiding oversubscription.
- Bound request and completion queues independently from thread count.
- Export worker active count, request depth, completion depth, queue wait,
  runtime, rejected work, and stale results.
- Do not let new worker threads call the current thread-indexed dispatcher
  enqueue path unless they are explicitly registered and storage sizing is
  proven safe.

The implemented direction is a dedicated monster-compute pool with bounded
multi-producer requests, bounded completions, and explicit shutdown before the
shared pool. Do not rely on the operating-system scheduler alone to provide
gameplay fairness.

A machine with many cores still needs headroom for:

- The dispatcher.
- Network IO and message writing.
- Database and save tasks.
- Compression, logging, and operating system scheduling.

The initial configuration must be validated on low-core and high-core machines.
A value that works on an eight-core host may oversubscribe a four-core host or
underuse a large host. Increase worker count only while player-visible latency,
queue bounds, and service progress remain healthy.

## Required tests by category

Dispatcher and scheduler:

- FIFO ordering within a lane unless a documented replacement or coalescing
  rule applies.
- Fixed-budget slicing without task loss, duplication, or reordering inside the
  preserved compatibility contract.
- Scheduled due-time ordering and measured lateness.
- Expired task behavior before and after slicing.
- Minimum progress for creature and monster lanes.
- Per-actor admission so one player or monster cannot monopolize a protected
  lane.
- Completion queue saturation, rejection, and later recovery.
- Immediate closure preservation on rejection and lane-slot recovery after
  cancel, task start, and one-shot successor scheduling at capacity.
- Protocol fail-closed behavior and absence of dependent player actions after
  rejected walk admission.
- Worker-exception failure completions, generation-aware monster cleanup, and
  token release only after the failure completion is consumed.
- Background admission preserves the visible compute reserve, and both request
  and completion selection preserve the documented 3:1 service order.
- Lua timer rejection without registry-reference leaks, plus recurring global
  event and raid scheduling after capacity is recovered.
- Deterministic adaptive-budget tests with an injected clock and workload.

Movement:

- Normal step, autowalk, cancel walk, push creature, push item, teleport, floor
  change, and forced teleport.
- Movement through fields, magic wall, wild growth, doors, house tiles,
  protection zones, and dynamic tiles.

Monster AI:

- Target enter/leave viewport.
- Target death/logout/despawn while AI or path jobs are pending.
- Monster follow, flee, retarget, walk back to spawn, summon/master behavior,
  and no-target idle transitions.
- First player sight promotes already-pending walk and post-think work without
  bypassing target legality, and priority hysteresis expires after the hold.

Combat:

- Monster attack with target moving out of range.
- Target entering protection or invalid zone before commit.
- Cooldown and spell selection with delayed intention.
- Lua combat callbacks that remove, teleport, transform, or kill involved
  objects.

Concurrency and lifetime:

- Current barrier-parallel work does not overlap dispatcher commits when the
  compatibility mode requires the barrier.
- Concurrent background jobs use immutable or explicitly synchronized inputs.
- Shutdown while worker jobs are queued.
- Shutdown while completion results are pending.
- Map reload or dynamic tile changes while path jobs are pending.
- Login/logout near movement fanout.
- Old world epoch or request generation completion after reload or supersession.
- Unknown or dedicated worker threads cannot overrun dispatcher per-thread
  queue storage.
- Stale result discard counters.
- Expired Zone weak-cache owners can be cleaned while spawn/add/remove activity
  continues without changing associative-key ordering or racing cache mutation.
- Debug assertions for forbidden worker mutation where practical.

Performance:

- Production-like hunt load.
- Artificial all-monsters-active stress as a degradation test.
- Queue-age comparison for `PlayerWalk`, `WorldCommit`, `VisibleMonster`,
  `BackgroundMonster`, `VisibleMonsterAI`, `MonsterAI`, `Deferred`, and every
  other active lane.
- Scheduled-walk due lateness and input-to-walk-commit p50, p95, and p99.
- Barrier wall time, longest inner creature call, and work units
  per slice.
- Dispatcher CPU time versus worker CPU time.
- Snapshot construction cost versus reused computation.
- Worker and completion saturation with bounded memory.

## Phase exit criteria

Do not advance to the next architectural phase merely because code compiles or
an artificial stress profile improves.

Every phase must show:

- No regression beyond the recorded tolerance in production-like player walk,
  input, movement, combat, and Lua behavior.
- Queue and memory growth remain bounded under sustained overload.
- Monster work retains its documented minimum progress.
- No missed or duplicated world commit, movement notification, combat action,
  condition transition, or client-visible send.
- New stale, rejected, superseded, and coalesced paths are observable.
- The artificial all-monsters-active test degrades predictably without becoming
  the sole acceptance workload.
- Rollback can remove the phase without requiring the later dispatcher rework.

## Review checklist

Use this checklist for every patch that adds worker or dispatcher fairness work:

- Does the worker mutate gameplay state?
- Is this task barrier-parallel compatibility work or a truly concurrent
  background job?
- If it was moved out of the barrier, was the full mutable call graph migrated?
- Does the worker call Lua or any script-visible callback?
- Does the worker advance cooldowns, attack ticks, conditions, or gameplay RNG?
- Does any raw pointer or reference cross a delayed or worker boundary?
- Is every result re-resolved and revalidated on the dispatcher?
- Can stale results fail closed?
- Does a task-count budget hide a larger nested creature or monster batch?
- Is sub-cycle runtime measured with a monotonic clock rather than cached
  `OTSYS_TIME()`?
- Can a player walk event be late in the scheduled queue before it reaches its
  dispatcher lane?
- Does a new lane preserve every movement and barrier semantic check used by the
  previous route?
- Can an unregistered worker call thread-indexed dispatcher queue storage?
- Is there a per-monster or per-lane backpressure rule?
- Is there an explicit full-queue policy?
- Can delayed work produce a catch-up burst?
- Can player-visible work still run while monster work is backlogged?
- Can monster work still make progress while players are active?
- Is there a metric proving the change improved latency or reduced dispatcher
  time?
- Are production-like and artificial stress results interpreted separately?

## Decision record

The target architecture is not "put the game world on many threads".

The target architecture is:

1. Measure queue wait, scheduled lateness, barrier time, nested work, and
   player-visible end-to-end latency separately.
2. Keep current mutable async AI in a bounded barrier-parallel compatibility
   mode until each call graph is migrated.
3. Add static fairness, inner slicing, backpressure, and no-catch-up rules before
   introducing new background jobs.
4. Treat the dispatcher as the only writer for world commits and for every
   result produced by truly concurrent background workers.
5. Build bounded request/completion infrastructure and immutable spatial read
   contracts before background pathfinding.
6. Move pure path, AI, and combat-preparation computation incrementally, with
   stable identities, generations, revalidation, and serial commit.
7. Add adaptive budgets and lane aging only after static limits are measured
   and stable.
8. Rework the dispatcher only after lanes, scheduled-event classes, budgets,
   completion queues, and worker contracts are proven incrementally.
