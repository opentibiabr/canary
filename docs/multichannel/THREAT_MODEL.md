# Threat Model

Scope: anti-dupe, split-brain, and race conditions introduced by running the
same character/economy across N processes. This is not a general server
security review — see `docs/systems` and the existing security review
tooling for that.

## T1 — Same character online on two channels simultaneously

**Attack/failure:** player (or two devices under the same account) logs in
on Channel 1 and Channel 2 within the same instant, or a crashed process on
Channel 1 is still holding game state when the character logs in on
Channel 2.

**Why naive fixes fail:**
- An in-memory map on one process cannot see another process's state.
- `SELECT ... WHERE account_id = ?` followed by `INSERT` in application
  code has a race window between the two statements.
- A Redis `SET key value NX` lock without a fencing token stops a *second*
  acquire, but does not stop the *first* holder from continuing to act
  after its lease has silently expired (e.g. GC pause, network partition)
  and been reassigned — the old process doesn't know it lost the lock and
  keeps writing.

**Mitigation (this PR):**
1. Redis: atomic Lua script combines "does an unexpired lease exist" +
   "issue new lease" + "issue new fencing token" in one `EVAL`, so two
   concurrent acquire attempts are serialized by Redis itself, not by
   client-side timing.
2. DB: `cluster_sessions.PRIMARY KEY(account_id)` and
   `UNIQUE(player_id)` — even if Redis is wrong, wiped, or bypassed, a
   second row for the same account or player fails at `INSERT` time with a
   constraint violation, not an application `if`.
3. Fencing token: every persistent write in Phase 2 must be tagged with
   the fencing token the writer held when it started the operation, and
   rejected if a newer token has since been issued for that
   account/player. This is what stops a "zombie" process (T2) rather than
   just stopping a second *login*.

**Status:** (1) and (2) are implemented and unit-tested in this PR. (3)'s
*contract* is documented; enforcing it inside the actual save pipeline is
Phase 2 (see ARCHITECTURE.md §5).

## T2 — Zombie process writes after losing its lease (split-brain)

**Attack/failure:** Channel 1's process stalls (GC pause, VM freeze,
network partition to Redis) long enough for its lease to expire. Channel 2
correctly acquires the session and the player continues playing there.
Channel 1's process wakes up and, not knowing it lost ownership, tries to
save the character's old, stale state — overwriting Channel 2's progress,
or worse, re-crediting a purchase that Channel 2 already completed.

**Mitigation:** fencing token comparison at write time (T1.3) — a save
tagged with an old token is rejected outright, not merged, not
"last-write-wins". Per spec §5.4, a version conflict is logged as
critical, the save is aborted, and the session is **not** released as
clean — it is left in a `DIRTY` state requiring operator/recovery
inspection (§5.3), specifically so the zombie process cannot simply retry
and succeed.

**Status:** state machine supports `DIRTY` and rejects illegal transitions
(unit tested). The actual save-path token check is Phase 2 (needs a real
save pipeline integration this session cannot compile/verify).

## T3 — Market double-spend / double-delivery across channels

**Attack/failure:** two buy requests for the same offer arrive on
different channels within the same millisecond; or a buy request times out
client-side and is retried, risking the buyer being charged twice or
receiving the item twice.

**Mitigation:**
- Market identity has no `channel_id` (§2.3), so there is exactly one row
  to lock regardless of which channel a request comes from — this itself
  removes an entire class of "which channel's copy is authoritative" bugs
  that a naive per-channel offers table would create.
- `economic_ledger.transaction_uuid` primary key: a retried request reuses
  the same UUID (idempotency key generated once per logical user action,
  not per HTTP/TCP attempt) and the second `INSERT` fails the PK
  constraint — the caller reads back the first row's `status` instead of
  re-executing the transfer.
- Row-level locking (`SELECT ... FOR UPDATE`) on the specific
  `market_offers` row during buy/cancel is required at the Phase 2 call
  site; documented, not yet implemented (see DECISION_MATRIX.md 2.3/8.1).

**Status:** 📐 schema + contract only — see ARCHITECTURE.md §8 for why the
actual buy/sell code was not blind-edited in this session.

## T4 — Mailbox double delivery

**Attack/failure:** a parcel send is retried after a timeout and gets
delivered twice, or is picked up "once per channel" instead of once
cluster-wide.

**Mitigation:** mailbox is not filtered to locally-online players (§2.12);
delivery is a single global operation identified by a `transaction_uuid`
in `mail_delivery_audit`, same idempotency pattern as T3.

**Status:** 📐.

## T5 — Two independent house purchases for the same account

**Attack/failure:** an account buys a house on Channel 2, then
simultaneously bids on a house auction settling on Channel 3.

**Mitigation:** `account_house_ownership.PRIMARY KEY(account_id)` — the
second `INSERT` fails at the database regardless of which channel process
issued it, regardless of timing. This is deliberately *not* an
application-level "check then insert", specifically to close the TOCTOU
window between concurrent processes.

**Status:** ✅ constraint shipped; 📐 write call site (must be inside the
same transaction as the `houses.owner` update — documented in
MIGRATION.md/DECISION_MATRIX.md).

## T6 — Channel switch used to escape combat/PvP consequences

**Attack/failure:** a player about to die or lose a PvP fight tries to
switch to a No-PvP channel to dodge the fight, or a war participant hides
from war combat by hopping to No-PvP.

**Mitigation:** `ChannelSwitchService` unconditionally rejects a switch
while PZ-locked or in combat, *before* evaluating any other policy — this
check is not skippable by config (§4.3 hard invariant). Skull-based denial
(`combat-or-skull` default) additionally blocks known-aggressive players
from hopping to a calmer channel even after combat has technically ended.

**Status:** ✅ policy logic + tests. 📐 the actual PZ/combat condition read
is a live engine call (Phase 2 hook point documented).

## T7 — Login-list spam used to force a channel switch bypassing cooldown

**Attack/failure:** a client fires many parallel login requests against
different channel worlds to find a request that lands before the cooldown
or session check is evaluated.

**Mitigation:** the session acquire itself is the serialization point
(T1) — every one of those parallel requests contends for the same Redis
key and the same DB unique constraint, so only one can ever win regardless
of how many are sent. Cooldown is enforced from the persisted
`last_channel_switch_at`, read inside the same critical section as the
session acquire, not as a separate unsynchronized check.

**Status:** ✅ by construction of the session-acquire design (T1); full
proof requires the Phase 2 engine hook plus the concurrent-login race test
listed as not-yet-run in TEST_PLAN.md.

## T8 — Redis or DB outage exploited to bypass session/economy checks

**Attack/failure:** an attacker (or just bad luck) causes Redis or MySQL
to become briefly unreachable, hoping the server "fails open" and allows
logins/economy ops without the coordination layer.

**Mitigation:** fail-closed by design (§10 of the spec, ARCHITECTURE.md
§10) — loss of Redis blocks new logins/switches/chat delivery; loss of DB
additionally freezes all economy mutations. No config flag can disable
this per §4.3.

**Status:** state machine designed for these transitions; actual
detection/enforcement wiring into the connection accept path is Phase 2.

## T9 — SQL injection / malformed migration input

Not a new attack surface introduced by this PR: all new migration SQL uses
the same `db.query([[ ... ]])` literal-SQL pattern as existing migrations
(no string-concatenated user input), and all documented Phase 2 call sites
are specified to use the existing prepared/escaped DB layer
(`src/database/database.hpp`), consistent with repo conventions.

## T10 — Deadlock between session lock, DB transaction and game-state lock

Documented lock ordering for Phase 2 implementers (ARCHITECTURE.md /
OPERATIONS.md): **session lease (Redis) → DB transaction → in-process game
state lock**, always acquired in that order, released in reverse. Never
hold a DB transaction open while waiting on a Redis round-trip, and never
call into Redis from the game dispatcher thread synchronously (§18 of the
spec) — the `ClusterSessionManager` API is designed to be called from a
background/IO context and hand results back to the dispatcher via the
existing task-posting mechanism, not to block it.
