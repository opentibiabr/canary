# Gameplay Analytics hunt context

The context layer adds a coarse description of where and how a completed hunt was played. It does not store movement history or a coordinate trail.

## Collected session fields

The `analytics_sessions` row stores:

- `hunt_area` — the dominant named area or coarse fallback grid cell;
- `party_size_min` and `party_size_max`;
- `party_size_avg` — time-weighted average party size;
- `shared_experience_seconds`;
- `shared_experience_ratio` — value from `0.0000` to `1.0000`;
- `party_vocations` — dominant vocation composition such as `1:1,2:2`;
- `server_version` — optional build or balance-patch identifier.

The existing `party_size` column remains compatible with older queries and contains the maximum observed party size. The existing `shared_experience` flag is true when shared experience was observed during the sampled session.

No character names or party-member identifiers are stored in the party composition. Only vocation IDs and counts are retained.

## Named hunt areas

Define rectangles in `gameplay_analytics.lua`:

```lua
huntAreas = {
    {
        name = "rotten-blood-east",
        from = { x = 33000, y = 32000, z = 8 },
        to = { x = 33199, y = 32199, z = 12 },
    },
    {
        name = "cobra-basement",
        from = { x = 33200, y = 32300, z = 10 },
        to = { x = 33350, y = 32450, z = 15 },
    },
}
```

The first matching rectangle wins. Keep names stable because dashboards group historical sessions by this value. Names are truncated to 128 bytes before persistence.

## Fallback grid areas

When no named rectangle matches and `trackFallbackGridAreas = true`, Analytics generates a coarse identifier:

```text
grid:<x-cell>:<y-cell>:<floor>
```

With the default `huntAreaGridSize = 64`, position `(640, 704, 8)` becomes `grid:10:11:8`.

Fallback grids provide useful grouping without retaining exact coordinates. Set `trackFallbackGridAreas = false` to persist `NULL` for unconfigured areas.

## Sampling and cost

Context is sampled lazily when an already collected metric accesses the active session. It is not written to MariaDB for every movement or combat event.

- `contextSampleIntervalSeconds = 1` limits accepted samples to at most one per second per active session;
- `contextMaxGapSeconds = 10` caps how much time one delayed sample can contribute;
- context is finalized again at session finish and before enqueue;
- direct offline or shutdown enqueue paths receive safe default values.

This prevents a long event-loop pause from assigning minutes of stale party or location state to one sample.

## Party composition

The composition format is deterministic and sorted by vocation ID:

```text
1:1,2:2,4:1
```

This means one player with vocation `1`, two with vocation `2`, and one with vocation `4`. Members are deduplicated by character GUID. The party leader is included when the server binding exposes `Party:getLeader()`; the lookup is protected for compatibility with older bindings.

## Server build identifier

Set the environment variable before starting Canary:

```bash
export CANARY_SERVER_VERSION="balance-2026-07-11"
```

The default configuration reads it through:

```lua
serverVersion = os.getenv("CANARY_SERVER_VERSION") or ""
```

An empty value is persisted as `NULL`. Use a stable build or balance-patch name rather than a unique process identifier.

## Example query

```sql
SELECT
    server_version,
    hunt_area,
    vocation_id,
    FLOOR(level_start / 100) * 100 AS level_bracket,
    COUNT(*) AS sessions,
    ROUND(SUM(experience_raw) / NULLIF(SUM(combat_seconds), 0) * 3600) AS raw_exp_hour,
    ROUND(AVG(party_size_avg), 2) AS average_party_size,
    ROUND(AVG(shared_experience_ratio) * 100, 1) AS shared_exp_percent
FROM analytics_sessions
WHERE combat_seconds >= 300
GROUP BY server_version, hunt_area, vocation_id, level_bracket
HAVING COUNT(*) >= 20
ORDER BY server_version, hunt_area, level_bracket, vocation_id;
```

## Privacy and cardinality

No character names, GUID lists, exact coordinate trails or party membership histories are added by this feature. Hunt names and vocation compositions stay in MariaDB. They are not exported as per-area or per-composition Prometheus labels, avoiding high-cardinality monitoring data.
