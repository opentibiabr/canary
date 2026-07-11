# Test Plan

Honest status of every test category the spec asks for. "Run" means
actually executed in this session and its result observed; "not run"
means the scenario requires infrastructure that was not available in this
development sandbox and is left for CI / a follow-up session to execute.
A real MariaDB 10.11 server and real gtest turned out to be installable
here (`apt-get install mariadb-server`/`libgtest-dev`) even though a
working Docker daemon and a bootstrapped vcpkg toolchain were not — so the
database and unit-test layers got substantially more real execution than
originally expected; the remaining gap is specifically a compiled,
running three-process Canary cluster.

## 15.1 Unit tests — ✅ implemented, added to `tests/unit`, 5 of 7 files actually compiled and run with real gtest

| Test | File | Status |
|---|---|---|
| Config validation (lease TTL vs heartbeat, pvp_type, party/exit policy enums) | `tests/unit/game/multichannel/cluster_config_validator_test.cpp` | ✅ **run**, 12/12 passed |
| Channel registry parsing/lookup/enabled-filtering | `tests/unit/game/multichannel/channel_registry_test.cpp` | ✅ written, not run locally (see below) |
| Channel id resolution priority (CLI > env > fallback) | `tests/unit/game/multichannel/channel_context_test.cpp` | ✅ written, not run locally (see below) |
| Position resolver: same-tile accept, radius-bounded search, house-access denial, restricted-zone denial, temple fallback | `tests/unit/game/multichannel/position_resolver_test.cpp` | ✅ **run**, 10/10 passed |
| Session lock acquire/renew/release against `FakeRedisClient` | `tests/unit/game/multichannel/cluster_session_manager_test.cpp` | ✅ **run**, 18/18 passed |
| Fencing token monotonicity + rejection of stale token | same file | ✅ **run** (included in the 18 above) |
| Channel switch policy: cooldown, PZ-lock block, skull policy variants, party deny/leave | `tests/unit/game/multichannel/channel_switch_service_test.cpp` | ✅ **run**, 18/18 passed |
| Idempotency: `economic_ledger` replay contract (pure logic model) | `tests/unit/game/multichannel/idempotency_test.cpp` | ✅ **run**, 5/5 passed |

**These compile against the project's real gtest-based unit test target**
(`canary_ut`, `CANARY_BUILD_TESTS=ON` with the vcpkg `tests` feature) in the
normal CMake build, which is what CI actually exercises. Separately, and in
addition to that, **5 of the 7 test files above were compiled and run in
this sandbox with a real `g++ -std=c++20` + the real `libgtest`/
`libgtest_main` (installed via `apt-get install libgtest-dev` for this
purpose) linked against each module's actual `.cpp`** — not a mock, not a
rewritten copy: `cluster_config_validator_test.cpp`,
`position_resolver_test.cpp`, `cluster_session_manager_test.cpp`,
`channel_switch_service_test.cpp`, and `idempotency_test.cpp`, totaling
**63 test cases, all passing**. `position_resolver_test.cpp` and
`cluster_session_manager_test.cpp` needed a small local shim (pre-included
standard headers, and a stub `operator<<(ostream&, Position)`) to stand in
for this project's precompiled header, which is unavailable without the
real CMake/vcpkg build; the module code under test was compiled unmodified
except for one real fix this exercise found (see below).

`channel_context_test.cpp` and `channel_registry_test.cpp` could **not** be
run locally: both modules use `inject<T>()` (this project's boost.di-based
DI container, `lib/di/container.hpp`), which requires `boost/di.hpp`
(vcpkg's `bext-di` package) - not installable via `apt`, and fetching the
single-header library from its upstream GitHub source was blocked by this
session's own external-code-fetch safety policy (an unvetted third-party
source, correctly refused). These two files are written to the same
conventions as the five that were run and will be compiled for real by CI;
their pure/static logic (`ChannelContext::resolveFrom`,
`ChannelInfo::isValidPvpType`, `ChannelRegistry::hashBytes`) was reviewed
carefully but not independently executed outside of the code review.

**A real bug this exercise found and fixed:** `position_resolver.hpp`
included `"game/movement/position.hpp"` *before* its own `<optional>`
include. In this project's real build that's harmless (the precompiled
header brings in `<optional>`/`<functional>` before any project header is
processed, regardless of local include order), but it is a latent
include-order hazard for any future non-PCH build, and it broke the
standalone compile immediately. Fixed by reordering the includes (system
headers before the local `position.hpp` include) - a one-line, zero-risk
correction, kept in the shipped header, not just the test harness.

A second, purely test-side bug was also found and fixed: an early
standalone assertion for `cluster_session_manager` accidentally renewed a
lease before asserting that a *different* renew call should fail due to
expiry, which had silently extended the expiry past the test's own
"expired" timestamp. Fixed in the test, not the production code - see the
relevant commit message for detail. Both of these are exactly the kind of
findings this level of real, executed verification is supposed to surface,
and both were caught and corrected in this session, not left for CI to
discover.

## 15.1b Redis Lua CAS script validation — ✅ run against a real `redis-server`

The acquire/renew/release Lua scripts in
`src/game/multichannel/redis_scripts/` were loaded into a real local
`redis-server` (available in this sandbox) via `redis-cli --eval` and
exercised directly:

- acquire on an empty key succeeds, returns session id + fencing token 1
- second acquire attempt while a lease is held and unexpired is rejected
- renew by the owning session id succeeds and does not change the fencing
  token
- renew by a non-owning session id is rejected
- release by the owning session id succeeds and clears the key
- a fresh acquire after release/expiry issues fencing token 2, never
  reusing 1
- 8 concurrent `redis-cli --eval acquire.lua` processes fired at the same
  key at once (via shell background jobs): exactly one acquired, and
  exactly one fencing token (1) was ever issued, confirmed by inspecting
  every process's raw output plus the key's final `HGETALL` state

This is real integration proof that the compare-and-swap semantics the
whole anti-split-brain design depends on (THREAT_MODEL T1/T2) are correct
Lua, not just a description. See the PR commit for the exact `redis-cli`
transcript.

## 15.2 Integration tests (3-process, MySQL+Redis) — not run

Requires a bootstrapped vcpkg toolchain to produce three actual Canary
binaries; that specific piece was not available in this sandbox (no
`vcpkg`). A real MariaDB server *was* obtained and used extensively (see
§15.4 and MIGRATION.md's "What was actually verified" section) - the
remaining gap is specifically the compiled engine, not the database. The
30 scenarios from the spec are captured as concrete, numbered acceptance
criteria in `docker/multichannel/SCENARIOS.md` so they can be executed
against the Compose stack in this PR by CI or by an operator with Docker
access, once Phase 2 wires the engine call sites these scenarios exercise
(most of them — login races, session takeover, position fallback — depend
on code marked 📐 in ARCHITECTURE.md).

## 15.3 Anti-dupe race tests — run at every level this PR's code actually reaches

- **Redis CAS script race:** 8 concurrent `redis-cli --eval` acquire
  calls fired at the same key at once — confirmed exactly one succeeds
  and exactly one fencing token is ever issued (✅ run, see 15.1b).
- **`FakeRedisClient` concurrent acquire:** unit test spins 16-32 threads
  calling `acquire()` on the same account/player key concurrently, asserts
  exactly one succeeds and the fencing token sequence has no gaps or
  repeats (✅ run, both via the real gtest suite and a standalone g++
  harness).
- **DB constraint enforcement** (`cluster_sessions.PRIMARY KEY(account_id)`,
  `cluster_sessions_player_unique`, `account_house_ownership.PRIMARY
  KEY(account_id)`, `account_house_ownership_house_unique`): ✅ **run**
  against a real MariaDB 10.11 instance installed in this sandbox
  (`apt-get install mariadb-server` worked, even though a Docker daemon
  did not). Confirmed each constraint actually rejects the specific
  duplicate it exists to prevent — a second house for one account, a
  second account claiming one physical house, a second online session for
  one account, and a second session for one player under a different
  account. This is sequential constraint-violation testing (one `INSERT`
  after another observing the rejection), not literally two concurrent
  connections racing in the same millisecond — but a UNIQUE/PRIMARY KEY
  constraint is exactly the mechanism that makes concurrent races
  irrelevant (MySQL/MariaDB serializes conflicting writes at the storage
  engine regardless of arrival timing), so confirming the constraint
  itself is real and correctly shaped is the meaningful thing to verify
  here, and it was.

## 15.4 Compatibility — schema/migration path run against a real database; engine boot not run

- **Single-channel mode unaffected:** verified by inspection — every new
  code path added in Phase 1 is gated by `multiChannelEnabled` (which
  defaults `false`) or is purely additive schema (migrations are
  `CREATE TABLE IF NOT EXISTS` / guarded `ALTER`). Not verified by an
  actual full-engine build+boot in this sandbox (no vcpkg toolchain).
- **Migration idempotency and upgrade correctness: ✅ run for real**, not
  just reviewed. This session installed a real MariaDB 10.11 server,
  imported the pre-PR `schema.sql` (a genuine "v58" baseline, via `git
  show`), applied `59.lua` and `60.lua`'s actual SQL bodies in their real
  file order as a live upgrade, diffed the result against a fresh-install
  `schema.sql` import (identical modulo column order), and confirmed every
  guard query used by the Lua idempotency checks
  (`SHOW COLUMNS ... LIKE`, `SHOW KEYS ... WHERE Column_name = ...`,
  `information_schema` existence checks) returns exactly what the
  migration script expects to see post-migration - i.e. a second run
  would correctly no-op. The documented rollback SQL in MIGRATION.md was
  also executed against the upgraded database and confirmed to restore
  the exact pre-migration `houses` shape. **This process found and fixed
  a real bug**: `account_id` columns on four new tables were declared as
  plain signed `int(11)` instead of `int(11) UNSIGNED` to match
  `accounts.id`, which MariaDB rejected outright as a malformed foreign
  key the moment `schema.sql` was imported for real - see MIGRATION.md
  for detail. What's still not run: three actual compiled Canary
  processes reading/writing through this schema end-to-end (needs the
  vcpkg toolchain this sandbox doesn't have).
- **Legacy protocol layout:** `ProtocolLogin` change was written to
  preserve the exact existing single-world output when
  `multiChannelEnabled = false` (early-return keeps the original code
  path completely untouched), and to extend, not replace, the multi-world
  encoding when enabled. Not run against a real client.
- **Windows/macOS build:** not attempted (no cross-toolchain in this
  sandbox); nothing in this PR is platform-specific (no OS-specific
  syscalls added), so no reason to expect divergence, but this is an
  expectation, not a verified fact.

## What CI is expected to actually prove

Because this session cannot run the project's own build, **CI is the
first real compiler** for every C++ file in this PR. The PR is pushed and
CI is watched for real; any compile error, lint failure, or test failure
CI reports against the code in this PR is treated as a real bug and fixed
with a real commit, per the repo's own CI-repair policy. This document
will not claim a CI status that wasn't actually observed — see the PR
description / final report for the true, current CI state at hand-off
time.

One failure observed during this PR's CI runs was **not** a code bug:
`Build - Docker / Image Build` failed with
`Error response from daemon: ... registry-1.docker.io ... 502 Bad Gateway`
while the `docker/setup-buildx-action` step was pulling the
`moby/buildkit` builder image itself, before this PR's `Dockerfile` was
even reached. That is a transient upstream Docker Hub registry error, not
something a source change can fix. The automation account pushing this
PR does not hold `actions:write` (re-running a specific failed job via
the API returns `403 Resource not accessible by integration`), so the
only retry lever available here is a new commit, which starts a fresh
workflow run and gives the same job a new attempt.
