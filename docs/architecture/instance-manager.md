# InstanceManager foundation

## Scope of this PR

Types, lifecycle, and registry only - `src/game/instance/instance_id.hpp` and
`src/game/instance/instance_manager.{hpp,cpp}` - with no connection to
`Game`, the real map, or any scheduler. Per the workstream's own phasing
rule, full integration starts only after the first dependency-migration PR
(`docs/architecture/dependency-migration.md`) has merged; this PR is the
"design, data types, and tests of an independent component" step that's
allowed to happen in parallel with that.

No multiworld and no channel id anywhere in this module. Multichannel code
(`src/game/multichannel/`) is a separate, unrelated concept and this module
doesn't reference it.

## What's here

- **`InstanceId`** / **`InstanceSlotId`**: strong-typed ids (`enum class ... : uint32_t`),
  so an instance id, a slot index, and an arbitrary integer can't be
  accidentally interchanged at a call site.
- **`InstanceState`**: `Creating -> Active -> Closing -> Destroyed`. Nothing
  skips `Closing` - even a timeout-driven close runs the same cleanup path
  as an explicit one.
- **`InstanceDefinition`**: a name and an optional timeout (`0` = none).
- **`InstanceManager`**: owns a fixed-size pool of slots and every
  instance's lifecycle:
  - `createInstance` reserves a free slot or fails cleanly once the pool is
    exhausted - the slot pool size *is* the instance count limit, not a
    second number that could disagree with it.
  - `activate` is the only `Creating -> Active` transition.
  - `close` is idempotent: concurrent or repeated calls for the same
    instance run the cleanup callback exactly once and are otherwise a
    no-op. The callback runs outside the internal lock so it can safely take
    real time (or, once this is wired into the scheduler, call back into
    other systems) without risking a deadlock.
  - `closeExpiredInstances(now)` sweeps and closes anything past its
    timeout, through the same idempotent `close()` - "controlled timeout"
    here means "swept on demand," not a background thread; owning the sweep
    schedule is the scheduler-integration PR's job (see below).
  - Nothing is ever deleted out from under a slot mid-use: a slot is only
    released after cleanup has run and the instance is `Destroyed`.

`InstanceManager` is a plain, constructor-instantiated class, deliberately
**not** a new `g_x()` singleton - this workstream's whole point is reducing
that pattern, so introducing a fresh one here (only to migrate it away
later) would be working against the rest of the plan. How it ultimately
gets owned (a `Game` member, most likely, mirroring how `Map map;` is
already just a plain member of `Game` rather than its own singleton) is for
the `Game` integration PR to decide.

## What a "slot" is, deliberately not decided here

A slot is an opaque, reservable resource identified by an index. This PR
does not say what index 3 *means* - that's intentional. The target model
(see the parent task) is a pool of pre-carved, physically separate map
regions, each with its own offset, handed out one per instance; **not**
copying the whole map per instance. Making `InstanceSlotId` mean "map region
N" is exactly what the next PR in the list below does, once there's a real
map-region pool to back it with.

## Planned follow-up PRs, in order

1. **Map region pool**: a fixed set of pre-carved, physically separate map
   areas, each with an offset/region. `InstanceSlotId` starts meaning
   "region N" instead of an opaque index once this lands.
2. **Creature/spawn ownership**: creatures, spawns, and events created
   inside an instance carry its `InstanceId`, so cleanup can find and remove
   everything that belongs to a closing instance.
3. **Scheduler/event ownership**: scoping scheduled events to an instance,
   and moving the timeout sweep from "call `closeExpiredInstances` on
   demand" (this PR) to an actual periodic scheduler tick.
4. **Player enter/leave API**: the actual gameplay-facing API for moving a
   player into and out of an instance's reserved region.
5. **Lua API**: script-facing bindings once the above are real.
6. **Cleanup and recovery**: handling a server restart with instances that
   were mid-lifecycle when it stopped.
7. **Two parallel instances test**: an end-to-end test running two live
   instances side by side once map-region ownership (step 1) exists to make
   that meaningful.

Each of these is its own PR, same reasoning as everywhere else in this
workstream: small, focused, reviewable and revertable independently.

## Tests

`tests/unit/game/instance/instance_manager_test.cpp` covers: slot
reservation and pool exhaustion, the full state lifecycle, idempotent close
(including under concurrent calls from multiple threads, verifying the
cleanup callback runs exactly once), timeout sweeping (including that it's
safe to call repeatedly without double-closing), and concurrent
`createInstance` calls never oversubscribing the pool.
