# Operations Runbook

## Redis outage

**Policy: fail closed.**

1. Detection: `ClusterSessionManager` heartbeat/renew calls start failing.
2. Immediately: block new logins and channel switches cluster-wide (every
   process independently fails closed — no coordination needed to *stop*
   doing things), disable global/guild chat and PM delivery with a clear
   in-game message, refuse new session acquisition.
3. Players already `ONLINE` get a grace period of `redisFailureGracePeriod`
   during which the process keeps trying to renew its lease. Local
   gameplay (say, movement, combat on that channel) may continue during
   the grace period since it does not depend on cross-channel
   coordination — but nothing that touches another channel's data
   (switch, cluster chat, market) is allowed.
4. If renewal keeps failing as the lease TTL approaches expiry: enter
   emergency freeze — stop mutating actions, attempt a best-effort DB
   save, and disconnect affected players **before** another process could
   legally acquire their lease. A process must never keep a player's
   session "logically online" past the point another process is entitled
   to take over.
5. Recovery: once Redis is reachable again, re-establish heartbeat, verify
   this process's sessions are still the ones Redis has on record (they
   may have been reassigned during the outage — if so, this process must
   not resume for that player), rebuild presence, then re-enable
   logins/switches last.

## Database outage

**Policy: fail closed, more restrictive than Redis.**

1. Block logins, channel switches, and *all* economic mutations
   immediately (market, mail, bank, house, depot, trade-completion).
2. Enter emergency freeze/maintenance for mutating actions — reads of
   already-loaded in-memory state may continue locally, but nothing may be
   persisted.
3. Reconnect with bounded exponential backoff (mirrors the pattern used
   for Redis reconnect; do not busy-loop).
4. If the DB returns within grace period (`databaseFailureGracePeriod`):
   verify pending transactions, reconcile, then resume — only after full
   validation, not immediately on TCP reconnect.
5. If the DB does not return: controlled disconnect/shutdown, mark
   in-flight sessions `DIRTY`, require recovery validation at next login
   (§5.3 of ARCHITECTURE.md).

## Single channel crash

The other channels are unaffected by construction (independent processes,
independent game state). Requirements for the login gateway and any
cluster-aware tooling:

- Stop offering the dead channel once its heartbeat is stale
  (`> sessionLeaseTtl` since `last_heartbeat`).
- Do **not** touch `players_online`/session rows belonging to *other*
  channels.
- Do **not** reset any global table (guilds, market, VIP, etc.) — a single
  channel's crash is a local event only.
- A dirty session left behind by the crashed channel's players requires
  recovery (§5.3), not automatic reassignment.

## Leader election / cluster-singleton jobs

Inventory of periodic/global jobs that must not run N times in an
N-channel cluster (📐 scope classification, leader election itself not
implemented in this PR):

| Job | Scope | Notes |
|---|---|---|
| House rent charging | `cluster-singleton` | touches global bank balance |
| House auction settlement | `cluster-singleton` | touches `account_house_ownership` |
| Market offer expiration | `cluster-singleton` | market is global |
| Daily reward reset | `cluster-singleton` | player-global state |
| Global boosted creature/boss selection | `cluster-singleton` | one boosted target for the whole cluster |
| Global event scheduling | `cluster-singleton` unless the event is explicitly declared `per-channel` |
| Table cleanup jobs (e.g. expired bans, stale storages) | `cluster-singleton` |
| Highscores cache rebuild | `cluster-singleton` |
| Database optimization | `cluster-singleton` |
| Global server record | `cluster-singleton` |
| Local map/server save | `per-channel` | this is the one job type that *should* run once per process |
| Monster/NPC spawn cycles | `per-channel` |
| Local instance/boss-room timers | `per-channel` unless the boss is declared `cluster-singleton` |

Design for Phase 2: a Redis-based leader election (lock key
`cluster:leader:<job-name>`, same fencing-token pattern as session leases)
elects exactly one process to run each `cluster-singleton` job; the job
implementation itself carries the fencing token and must no-op if it
observes a newer token mid-run (same anti-zombie pattern as T2 in
THREAT_MODEL.md).

## GM / admin commands (📐 contract, not implemented)

- Cluster-wide online list (aggregates all channels' presence).
- Kick a player who is on a different channel.
- Locate a player's current channel.
- Broadcast: cluster-wide vs. this-channel-only variants.
- Force-save a specific channel.
- Drain a channel (stop accepting new logins/switches, let existing
  players finish naturally).
- Set a channel to maintenance with a message.
- Inspect and, with explicit confirmation + audit log entry, clear an
  orphaned `DIRTY` session.
- Inspect a session's current lock owner and fencing token.
- Inspect the last N channel-switch audit rows for a player.

All cross-node commands must be authorized (existing GM permission checks)
and written to an audit trail — no new unauthenticated control surface.

## Metrics (📐 contract, not implemented)

Tag every metric with `channel_id`, `instance_id`, `node_id`. Minimum set:
active sessions, login lock failures, lease renewal failures, dirty
sessions, channel switch success/failure/latency, version conflicts,
idempotency duplicates (economic_ledger replay hits), DB transaction
failures, Redis disconnects, chat publish failures, channel heartbeat age,
economic operation latency. The existing `metrics/` (OpenTelemetry/
Prometheus) integration is the intended sink — no new metrics backend.

## Logs

Every cluster-related log line should carry `channel_id` and `instance_id`
(via the existing `spdlog` structured logging conventions) so operators can
`grep` a single channel's activity out of aggregated log storage.

## Running three channels locally

See `docker/multichannel/` for a Compose example: MariaDB, Redis, and
three Canary processes (`CANARY_CHANNEL_ID=1/2/3`) sharing the DB/Redis
and a common map volume, with Channel 1 acting as the login gateway
(`login_gateway = true` in its seeded `channels` row).
