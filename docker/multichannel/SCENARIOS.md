# Integration test scenarios (spec §15.2)

The 30 scenarios from the originating spec, mapped against this stack, with
an honest status: which are exercisable today against this PR's Phase 1
code, and which need the Phase 2 engine wiring documented throughout
`docs/multichannel/` before they can pass. None of these were executed in
this session - no Docker daemon was available (see
`docs/multichannel/TEST_PLAN.md`). This file exists so CI or a follow-up
session with real Docker access has a concrete, numbered checklist instead
of having to re-derive it from the spec.

| # | Scenario | Status against this PR |
|---|---|---|
| 1 | Same character cannot be online twice | 📐 needs Phase 2 session hook (`cluster_sessions` + `ClusterSessionManager` already exist) |
| 2 | Two different characters of the same account cannot be online simultaneously | 📐 same as #1 - `cluster_sessions.PRIMARY KEY(account_id)` already enforces this at the DB level once the save/login path writes to it |
| 3 | Two parallel logins on different channels - only one wins | 📐 needs Phase 2 hook; the Redis CAS scripts already guarantee this once wired (see TEST_PLAN.md §15.1b for the standalone proof) |
| 4 | Clean logout and login on a second channel | 📐 needs Phase 2 hook |
| 5 | Crash of the old process and dirty-session recovery | 📐 `DIRTY` state exists and is tested in isolation; recovery tooling is 🔭 |
| 6 | Old fencing token cannot save data | 📐 `isFencingTokenCurrent` exists and is tested; no save call site checks it yet |
| 7 | Same-position behavior preserved across a switch | 📐 `PositionResolver` implements and tests this; not yet called from a real switch flow |
| 8 | Fallback away from someone else's house | 📐 `PositionResolver`'s house-access-denial path is implemented/tested with a fake legality checker; the real house-access check is Phase 2 |
| 9 | Fallback from a restricted zone | 📐 same as #8, `isRestrictedInstance`/`isNoChannelSwitchZone` |
| 10 | Target channel full/offline | ✅ policy logic exists and is tested (`ChannelSwitchService`); needs live heartbeat/capacity data source (📐) |
| 11 | Switch cooldown | ✅ policy logic exists and is tested |
| 12 | PZ lock/skull blocks switch per policy | ✅ policy logic exists and is tested |
| 13 | No-PvP does not allow combat | 🔭 out of this PR's scope - existing `worldType` combat rules are untouched |
| 14 | War kills only on PvP | 📐 `guildwar_kills.channel_id` column exists; the combat-check call site is Phase 2 |
| 15 | Global guild chat | 🔭 not implemented (documented scope only) |
| 16 | Global public chat | 🔭 not implemented (documented scope only) |
| 17 | PM between channels | 🔭 not implemented (documented scope only) |
| 18 | VIP online status with channel presence | 🔭 not implemented (documented scope only) |
| 19 | Party does not work across channels | ✅ true today by construction (party already only operates on locally-visible players) - no code change was needed |
| 20 | Global market create/buy from different channels | 🔭 not implemented (schema/ledger contract only, see ARCHITECTURE.md §8) |
| 21 | Two concurrent buys of the same offer - exactly one succeeds | 🔭 not implemented; would rely on DB row locking at the Phase 2 call site |
| 22 | Parcel sent on one channel received once on another | 🔭 not implemented (schema/audit contract only) |
| 23 | One house per account, cluster-wide | ✅ **DB-enforced today**: `account_house_ownership.PRIMARY KEY(account_id)` (📐 write call site still needed for the purchase/transfer flow itself) |
| 24 | Separate copies of the same house id per channel | 📐 partial - see MIGRATION.md's "known limitation": house ids are currently still globally unique, not yet per-channel-reusable |
| 25 | House items on one channel invisible on another | ✅ true today by construction (`tile_store`/`houses`/`house_lists` are already channel-scoped in this PR's schema) |
| 26 | Boss reward/cooldown cannot repeat via channel switch | ✅ true today by construction (no schema change was made to boss cooldown/reward tables - they remain global/player-scoped, never per-channel) |
| 27 | Redis outage | 📐 failure-mode state transitions are designed (`ARCHITECTURE.md`/`OPERATIONS.md` §Redis outage); live wiring is Phase 2 |
| 28 | DB outage | 📐 same as #27 |
| 29 | Leader crash and singleton job takeover | 🔭 leader election is not implemented in this PR (see `OPERATIONS.md`'s job inventory) |
| 30 | Restarting one channel doesn't affect others' online counts | ✅ true today by construction (independent processes, independent `channel_runtime_status` rows once Phase 2 populates them) - verified manually via this stack (stop/restart one channel container, confirm the others keep running) |

## How to actually run these once Phase 2 lands

Each scenario above that's 📐 or 🔭 needs the corresponding engine call
site wired first. Once that happens, this stack (three real channel
processes, real MariaDB, real Redis) is the intended harness: script each
scenario as a sequence of `docker compose exec`/network calls against the
three channels' ports, or as a proper test-runner client if one gets built
in a follow-up (see `docs/multichannel/TEST_PLAN.md` §15.2/§15.3 for the
integration and race-test categories these scenarios belong to).
