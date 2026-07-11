# MyAAC Integration Contract

`blakinio/myaac` is not in this session's repository allowlist (this
session is scoped to `blakinio/canary` only — see `AGENTS.md`), so no code
changes were made there. This document is the complete, standalone
contract a MyAAC-side PR needs to implement the panel-side features from
spec §20, so that work is not blocked on Canary access and can proceed
independently once someone has write access to that repo.

## Data MyAAC needs and where to get it

### 1. Channel list

Read directly from Canary's `channels` table (MyAAC already reads other
Canary-owned tables directly, e.g. `players`, `guilds`):

```sql
SELECT id, name, pvp_type, external_host, game_port, status_port,
       max_players, enabled, sort_order, temple_town_id,
       maintenance, maintenance_message
FROM channels
WHERE enabled = 1
ORDER BY sort_order ASC;
```

Population per channel: join against `channel_runtime_status.players_online`
for the same `channel_id` (this table is a low-frequency-write diagnostic
mirror, safe for a webpage to poll every few seconds — do not point MyAAC
at Redis directly, it has no business talking to the cluster coordination
layer).

```sql
SELECT c.id, c.name, c.pvp_type, COALESCE(r.players_online, 0) AS online,
       c.max_players, r.status, r.last_heartbeat
FROM channels c
LEFT JOIN channel_runtime_status r ON r.channel_id = c.id
WHERE c.enabled = 1
ORDER BY c.sort_order ASC;
```

Treat a channel as offline for display purposes if
`last_heartbeat` is older than `sessionLeaseTtl` (read this value from
Canary's config, or hardcode a conservative display threshold like 60s if
MyAAC has no access to `config.lua`).

### 2. Character creation — global, not per-channel

**No change needed to character creation.** A character is not "created
on a channel" — it is created once, per the existing `players` schema, and
becomes selectable on every enabled channel automatically via the login
protocol's per-channel world list (see ARCHITECTURE.md §3.2). MyAAC's
"create character" page requires **zero** changes for multi-channel — do
not add a channel selector to character creation. This is worth stating
explicitly because it is the most likely place someone would incorrectly
add a channel concept.

### 3. Online list

MyAAC's online list should continue reading whatever it currently reads
for "is this player online" (`players_online` or equivalent) — that table
remains a cluster-wide concept once Phase 2 wires session state into it
(a player online on any channel is online, full stop). To *additionally*
show which channel a player is on, join through `cluster_sessions`
(README: this table does not exist until Phase 2 populates it live; until
then, `channel_id` will simply be absent/null and MyAAC should render "—"
rather than a wrong channel):

```sql
SELECT p.name, cs.channel_id
FROM players_online po
JOIN players p ON p.id = po.player_id
LEFT JOIN cluster_sessions cs ON cs.player_id = p.id;
```

### 4. Highscores

**No change needed.** Highscores are computed from `players`, which is
already cluster-global by construction (one row per character, not one
per channel) — MyAAC's existing highscores query needs no `channel_id`
filter added anywhere.

### 5. House pages with channel context

House pages need one addition: the composite identity. Once Phase 2 lifts
the "globally unique house id" limitation (see MIGRATION.md), a house is
identified by `(channel_id, house_id)`, not `house_id` alone. In Phase 1's
shipped schema, `house_id` is still globally unique across channels (see
MIGRATION.md "known limitation"), so **no MyAAC change is strictly
required yet** — but any new house page/query should be written against
`(channel_id, id)` from day one so it does not need a second migration
when Phase 2 lifts that limitation:

```sql
SELECT h.channel_id, h.id, h.name, h.owner, h.rent, h.town_id, c.name AS channel_name
FROM houses h
JOIN channels c ON c.id = h.channel_id
WHERE h.channel_id = ? AND h.id = ?;
```

Ownership display should use `account_house_ownership` (one row per
account, cluster-wide) as the "does this account own a house at all"
check, and the `houses` table join above for the specific house's detail
page.

## What MyAAC should explicitly *not* do

- Do not write to `cluster_sessions`, `channels.maintenance`, or any
  Redis key from MyAAC — those are Canary-owned coordination state.
  MyAAC is read-only with respect to cluster state; any admin action
  (e.g. "put channel 2 in maintenance") should go through Canary's own
  admin/GM tooling (see OPERATIONS.md), not a direct table write from the
  web panel, to keep a single source of truth for audit purposes.
- Do not add a `channel_id` column to MyAAC's own account/character
  tables — none of MyAAC's data model needs it; it only ever reads
  Canary's `channel_id` columns for display.
