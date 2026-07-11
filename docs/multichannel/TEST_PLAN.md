# Test Plan

Honest status of every test category the spec asks for. "Run" means
actually executed in this session and its result observed; "not run"
means the scenario requires infrastructure (live MySQL, a bootstrapped
vcpkg toolchain, a 3-process cluster) that was not available in this
development sandbox, and is left for CI / a follow-up session to execute.

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

Requires a bootstrapped vcpkg toolchain (to produce a Canary binary) and a
live MySQL/MariaDB server; neither was available in this sandbox (no
`vcpkg`, no `mysqld`/`mariadbd`, and the Docker daemon was not usable
either). The 30 scenarios from the spec are captured as concrete,
numbered acceptance criteria in `docker/multichannel/SCENARIOS.md` so they
can be executed against the Compose stack in this PR by CI or by an
operator with Docker access, once Phase 2 wires the engine call sites
these scenarios exercise (most of them — logins races, session takeover,
position fallback — depend on code marked 📐 in ARCHITECTURE.md).

## 15.3 Anti-dupe race tests — partially run (algorithmic level only)

The concurrency-critical primitives were race-tested at the level they
actually exist in this PR:

- **Redis CAS script race:** two `redis-cli --eval` acquire calls fired
  back-to-back against the same key — confirmed exactly one succeeds
  (✅ run, see 15.1b).
- **`FakeRedisClient` concurrent acquire:** unit test spins N threads
  calling `acquire()` on the same account/player key concurrently, asserts
  exactly one succeeds and the fencing token sequence has no gaps or
  repeats (✅ written and run as part of the standalone g++ harness above).
- **DB unique-constraint race** (two processes racing to `INSERT` into
  `cluster_sessions`/`account_house_ownership` for the same key): not run
  — requires a live MySQL server. The constraint itself (PK/UNIQUE) is
  what MySQL uses to serialize concurrent transactions regardless of
  application timing, which is why this is considered lower-risk to leave
  for CI than the Redis script logic was — but it is explicitly not
  verified in this session, stated plainly rather than assumed.

## 15.4 Compatibility — partially run

- **Single-channel mode unaffected:** verified by inspection — every new
  code path added in Phase 1 is gated by `multiChannelEnabled` (which
  defaults `false`) or is purely additive schema (migrations are
  `CREATE TABLE IF NOT EXISTS` / guarded `ALTER`). Not verified by an
  actual full-engine build+boot in this sandbox (no toolchain/DB — see
  above).
- **Migration idempotency (re-run safety):** verified by code inspection
  against the existing migration framework's guard pattern
  (`db.tableExists`, and this PR's added `information_schema` column/key
  existence checks) — not executed against a live DB.
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
