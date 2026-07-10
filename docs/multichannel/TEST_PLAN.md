# Test Plan

Honest status of every test category the spec asks for. "Run" means
actually executed in this session and its result observed; "not run"
means the scenario requires infrastructure (live MySQL, a bootstrapped
vcpkg toolchain, a 3-process cluster) that was not available in this
development sandbox, and is left for CI / a follow-up session to execute.

## 15.1 Unit tests — ✅ implemented, added to `tests/unit`

| Test | File | Status |
|---|---|---|
| Config validation (lease TTL vs heartbeat, pvp_type, party/exit policy enums) | `tests/unit/game/multichannel/cluster_config_validator_test.cpp` | ✅ written |
| Channel registry parsing/lookup/enabled-filtering | `tests/unit/game/multichannel/channel_registry_test.cpp` | ✅ written |
| Channel id resolution priority (CLI > env > fallback) | `tests/unit/game/multichannel/channel_context_test.cpp` | ✅ written |
| Position resolver: same-tile accept, radius-bounded search, house-access denial, restricted-zone denial, temple fallback | `tests/unit/game/multichannel/position_resolver_test.cpp` | ✅ written |
| Session lock acquire/renew/release against `FakeRedisClient` | `tests/unit/game/multichannel/cluster_session_manager_test.cpp` | ✅ written |
| Fencing token monotonicity + rejection of stale token | same file | ✅ written |
| Channel switch policy: cooldown, PZ-lock block, skull policy variants, party deny/leave | `tests/unit/game/multichannel/channel_switch_service_test.cpp` | ✅ written |
| Idempotency: `economic_ledger` replay contract (pure logic model) | `tests/unit/game/multichannel/idempotency_test.cpp` | ✅ written |

These compile against the project's existing gtest-based unit test target
(`canary_ut`, `CANARY_BUILD_TESTS=ON` with the vcpkg `tests` feature) and
were **not** executed in this sandbox (no vcpkg toolchain bootstrap
available — see "Build note" below); they are written to compile cleanly
against the module headers and follow the repo's existing gtest
conventions. CI is expected to be the first real compile+run of the full
target; any failures found there will be fixed as real CI feedback (see
the PR for the actual run).

Two modules were additionally validated *outside* the main build, with
plain `g++ -std=c++20`, as header-only/dependency-free logic with a small
`main()` harness, specifically because they contain the most
safety-critical logic (bounded search termination, fencing monotonicity):
`position_resolver` and the `FakeRedisClient`-backed lease state machine.
Both ran and passed locally in this session (see commit messages for the
exact commands used).

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
