# Performance lifetime roadmap evidence

This document summarizes the profiling samples used to guide the performance
lifetime roadmap.

It intentionally does not store full Visual Studio exports, screenshots, or
machine-local attachment paths. The goal is to keep portable evidence for the
engineering decisions while avoiding noisy, non-reproducible raw profiler dumps.

## Reading Notes

- Percentages are sample-dependent. Compare direction and hotspot movement
  inside the same workload, not across unrelated stress profiles.
- Visual Studio "CPU total" and "CPU own" numbers are useful for prioritization,
  but not a complete latency measurement by themselves.
- The benchmark flags `monsterPerfTestForceActive` and
  `monsterPerfTestFriendlyFire` are pressure tests. They intentionally create
  an unrealistic all-monsters-active workload and should not define production
  acceptance by themselves.
- Startup queue-latency samples before the server reaches normal game state are
  diagnostic noise. Runtime queue latency after the server-online log, while the
  game state is `GAME_STATE_NORMAL`, is the relevant signal.
- CPU total is inclusive. Do not sum rows from the same call tree as if they were
  independent costs.

## Hotspot Percentage Movement

Most rows below compare the first stress sample where the hotspot justified a
change against a later monster-stress sample after the related change set. The
majority of these samples came from the same "many active monsters" tuning
scenario. The percentages are CPU-share movement inside Visual Studio samples,
not absolute throughput or a formal benchmark.

Read each row as: hotspot -> before -> after. Values are `CPU total / CPU own`.

| Hotspot | Before | After | Delta | Note |
| --- | --- | --- | --- | --- |
| Async task fanout | 47.93% / 5.21% | 18.02% / 0.23% | -62.4% / -95.6% | Compare as a family: direct enqueue lambda became bucketed processing. |
| `Creature::goToFollowCreature` | 21.72% / 0.42% | 6.77% / 0.09% | -68.8% / -78.6% | Follow pressure fell with path/tile lookup changes. |
| `Creature::getPathTo` | 17.02% / 0.01% | 4.39% / ~0% | -74.2% / n/a | Own CPU was already tiny; total is the useful signal. |
| `Map::getPathMatchingCond` | 16.99% / 4.56% | 4.38% / 0.91% | -74.2% / -80.0% | Main floor-cursor validation point. |
| `Map::getTile` | 10.52% / 5.91% | 5.74% / 0.09% | -45.4% / -98.5% | Some cost moved into `MapCache` and cursor helpers. |
| `Monster::updateTargetList` | 10.41% / 1.93% | 5.20% / 1.07% | -50.0% / -44.6% | Lower weak-lock/refcount churn. |
| `Monster::getTargetIterator` | 2.99% / 2.93% | 1.70% / 1.67% | -43.1% / -43.0% | Target id avoids locking every weak entry. |
| `Spectators::getSpectators` | 15.29% / 11.37% | 7.69% / 5.29% | -49.7% / -53.5% | Still a real next-stage hotspot. |
| `Monster::onCreatureMove` | 9.51% / 4.25% | 6.75% / 4.33% | -29.0% / +1.9% | Total improved; own CPU stayed flat. |
| `std::_Ref_count_base::_Decref` | 6.19% / 4.78% | 5.10% / 4.05% | -17.6% / -15.3% | Improved, but not eliminated. |
| `Creature::hasCondition` | 1.93% / 1.86% | <=0.07% / <=0.05% | at least -96.4% / -97.3% | Dropped out of the top-level hotspot list. |
| `Map::moveCreature` | 14.24% / 0.10% | 13.08% / 0.12% | -8.1% / +20.0% | Mostly orchestration; child fanout remains the cost. |

## Evidence Log

| Sample | Workload | Main observations | Decision validated |
| --- | --- | --- | --- |
| Initial dispatcher profile | Normal server under monster/player movement load | CPU was concentrated in the main game/dispatcher path rather than broad process CPU. Movement, spectators, monster AI/pathfinding, `shared_ptr`/`weak_ptr`, and allocator churn were repeatedly visible. | Optimize hotpath ownership usage and dispatcher work first. Do not return globally to raw `new`/`delete`. |
| Early monster movement/pathfinding stress | Monster movement with many active creatures | `Map::moveCreature`, `Spectators::getSpectators`, `Monster::onCreatureMove`, `Monster::getNextStep`, `Creature::getPathTo`, `Map::getPathMatchingCond`, `Map::getTile`, and `Map::canWalkTo` all appeared in the hot path. Refcount/allocator cost remained visible but was no longer the whole profile. | Split work into movement/spectator, pathfinding/tile lookup, and async/refcount phases instead of changing ownership globally. |
| Async/refcount cleanup samples | Hotpaths before and after low-risk local borrowing and async task cleanup | `std::_Ref_count_base::_Decref`, `std::__shared_count`, weak locks, `std::function`, and vector/task churn were measurable in movement and async-task paths. | Keep `shared_ptr` as boundary ownership, but reduce copies/locks inside synchronous scopes and batch async work. |
| Pathfinding tile cursor sample | Monster pathfinding and walk checks | `Map::getTile` and `MapCache::getOrCreateTileFromCache` were repeatedly near the top while monsters were following/fleeing and checking walkability. | Add scoped floor/tile lookup reuse for A* and directional walk checks without exposing `Tile*` or bypassing tile materialization/query rules. |
| Movement fanout samples | Player and monster movement with stress flags | `Spectators::getSpectators`, `Monster::onCreatureMove`, `Map::moveCreature`, and async task execution remained recurring top entries even after pathfinding improvements. | Treat movement fanout as a separate phase. Keep player-visible movement and notification contracts intact while optimizing snapshots and internal monster bookkeeping. |
| Deferred monster post-think sample | `monsterPerfTestForceActive=true` and `monsterPerfTestFriendlyFire=true` | The legacy deferred-lane backlog grew steadily: queued samples increased from tens to over one thousand pending tasks, and oldest age reached seconds. Monster attacks/spells/reactions became visibly late. | Increase monster post-think work per deferred task and document that the all-monsters-active benchmark must degrade background combat before delaying player-visible movement. |
| Coalesced movement AI follow-up | Same all-monsters-active stress after `Monster::onCreatureMove` coalescing | The apparent follow/target delay was initially suspected to be coalescing, but later tests showed the root cause was excessive artificial monster backlog. With production flags disabled, monsters attacked normally. | Keep internal `Monster::onCreatureMove` coalescing, but do not use the extreme benchmark as the sole product acceptance target. |
| Production-like sanity check | `monsterPerfTestForceActive=false` and `monsterPerfTestFriendlyFire=false` | Monsters attacked and reacted normally. The severe delays reproduced under benchmark flags did not reproduce in the normal player scenario. | Current changes are acceptable for production-like player hunting; future high-impact work should prioritize realistic player-visible movement fairness. |
| Startup queue-latency sample | Server startup before "server online" | Queue-latency warnings showed legacy barrier and serial tasks while map/load/startup work was still running. Some stale startup tasks could also be reported immediately after `GAME_STATE_NORMAL`, before the main server-online log. | Enable queue-latency telemetry only after the server-online log, require `GAME_STATE_NORMAL`, and ignore tasks queued before telemetry was enabled, so runtime profiling is not polluted by expected startup backlog. |

## Decision Matrix

| Question | Evidence-based answer |
| --- | --- |
| Should `Thing`, `Creature`, and related classes return globally to manual `new`/`delete`? | No. Profiles show hotpath overhead, but previous crash history and async/Lua/network boundaries make global manual lifetime management too risky. |
| Should raw pointers be used anywhere? | Yes, only as borrowed local views under a strong owner or synchronous snapshot, and never across dispatcher, scheduler, Lua, async, or cached boundaries. |
| Should the all-monsters-active benchmark be optimized until it feels smooth? | No. It is useful as a degradation test, but not a production acceptance target. |
| What is the next large, high-impact direction? | Separate player-visible monster movement/reaction from heavier attack, spell, condition, yell, sound, and background monster work. |

## Evidence Hygiene

When adding future profile evidence:

- Add one row per meaningful profile, not full dumps.
- Include workload flags and whether the sample is production-like or artificial
  stress.
- Record the conclusion that changed or validated an implementation decision.
- Avoid local paths, machine names, screenshots, or raw profiler exports in this
  repo document.
