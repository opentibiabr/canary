# Gameplay Analytics

Gameplay Analytics collects aggregated hunt data for vocation balancing. The subsystem is disabled by default and is configured in:

```text
data-otservbr-global/scripts/config/gameplay_analytics.lua
```

## Installation

1. Apply `schema/gameplay_analytics.sql` to the Canary MariaDB database.
2. Set `enabled = true` in the Lua configuration.
3. Restart Canary.
4. Verify startup logs contain `[GameplayAnalytics] Enabled`.
5. Run `/analytics status` as a gamemaster.

The feature does not issue SQL writes for individual hits. Data is accumulated in memory and flushed as completed sessions. A retry writes the complete in-memory session snapshot and upserts every aggregate by its natural key.

## Configuration

| Setting | Default | Purpose |
|---|---:|---|
| `enabled` | `false` | Master switch. |
| `databaseEnabled` | `true` | Persist completed sessions. When disabled, completed sessions are discarded instead of retained in memory. |
| `flushIntervalSeconds` | `300` | Queue flush interval; minimum runtime value is 30 seconds. |
| `minimumSessionSeconds` | `60` | Discard shorter sessions. |
| `combatTimeoutSeconds` | `120` | Split hunts after inactivity. Idle timeout time is not added to `combat_seconds`. |
| `includeStaff` | `false` | Allow staff characters to be considered. Account types listed in `excludedAccountTypes` remain excluded. |
| `trackPvP` | `false` | Include player-versus-player and player-summon damage. |
| `trackSpells` | `true` | Store spell aggregates reported through the API. |
| `trackMonsters` | `true` | Store per-monster aggregates. |
| `trackDamageTypes` | `true` | Store primary and secondary combat damage under their own combat types. |
| `trackSupplies` | `false` | Store supply use reported through the API. |
| `trackLoot` | `false` | Store loot reported through the API. |
| `anonymizePlayers` | `false` | Do not persist character names. Player IDs remain for relational integrity. |
| `queueLimit` | `10000` | Maximum completed sessions awaiting persistence. |
| `detailLevel` | `1` | Reserved detail tier from 0 to 2. |
| `excludedPlayerNames` | `{}` | Character names excluded from collection. |
| `excludedAccountTypes` | GM/God | Account types excluded even when staff collection is allowed. |

## Automatically collected data

The runtime hooks collect:

- raw and final experience, including per-monster raw experience;
- outgoing damage after combat calculation;
- incoming damage after combat calculation;
- effective self-healing and healing of others;
- overhealing;
- negative mana changes;
- monster kills;
- deaths;
- vocation and level;
- party size and shared-experience state;
- damage grouped by primary and secondary combat type;
- combat and session duration.

Outgoing damage to monsters is collected through the engine-wide drain-health callback, including damage caused by player-owned summons. Damage involving another player or a player-owned summon is excluded unless `trackPvP = true`.

Sessions are created lazily on the first recorded metric. Merely logging in and remaining online does not create an empty database row. When a combat timeout closes a session, `combat_seconds` ends at the last recorded combat event rather than when the timeout worker runs.

The `mana_spent` aggregate represents all negative mana changes observed by the mana-change event. Depending on server mechanics, this can include mana shield damage in addition to spell and rune costs.

## Optional integration API

Scripts can report domain-specific data that cannot be inferred reliably from generic combat events:

```lua
GameplayAnalytics.recordSpell(player, spellName, damage, healing, mana, targets, critical)
GameplayAnalytics.recordSupply(player, itemId, amount, unitValue)
GameplayAnalytics.recordLoot(player, itemId, amount, npcValue, marketValue)
```

`recordSpell` stores the spell's own mana aggregate but does not add it again to the session-wide `mana_spent` value, because generic mana-change events already collect that value.

Supply and loot collection remain disabled until enabled in the configuration.

## Administrative commands

```text
/analytics status
/analytics flush
/analytics enable
/analytics disable
```

Runtime enable/disable does not edit the Lua configuration and resets after restart. Runtime enable registers the required creature events for players who are already online.

## Recommended rollout

Start with:

```lua
enabled = true
databaseEnabled = true
trackMonsters = true
trackDamageTypes = true
trackSpells = false
trackSupplies = false
trackLoot = false
detailLevel = 1
```

After validating CPU, memory, database queue size, and data quality, enable explicit spell, supply, and loot reporting.

## Example balance queries

### Vocation performance by level bracket

```sql
SELECT
    vocation_id,
    FLOOR(level_start / 100) * 100 AS level_bracket,
    COUNT(*) AS sessions,
    ROUND(SUM(experience_raw) / NULLIF(SUM(combat_seconds), 0) * 3600) AS raw_exp_hour,
    ROUND(SUM(damage_dealt) / NULLIF(SUM(combat_seconds), 0)) AS dps,
    ROUND(SUM(damage_received) / NULLIF(SUM(combat_seconds), 0)) AS damage_taken_second,
    ROUND((SUM(healing_self) + SUM(healing_others)) / NULLIF(SUM(combat_seconds), 0)) AS healing_second,
    ROUND(SUM(deaths) / COUNT(*) * 100, 2) AS deaths_per_100_sessions
FROM analytics_sessions
WHERE combat_seconds >= 300
GROUP BY vocation_id, level_bracket
HAVING COUNT(*) >= 20
ORDER BY level_bracket, vocation_id;
```

### Solo versus party

```sql
SELECT
    vocation_id,
    CASE WHEN party_size = 1 THEN 'solo' ELSE 'party' END AS mode,
    COUNT(*) AS sessions,
    ROUND(SUM(experience_raw) / NULLIF(SUM(combat_seconds), 0) * 3600) AS raw_exp_hour,
    ROUND((SUM(loot_value_npc) - SUM(supplies_value)) / NULLIF(SUM(combat_seconds), 0) * 3600) AS npc_profit_hour
FROM analytics_sessions
WHERE combat_seconds >= 300
GROUP BY vocation_id, mode;
```

### Spell efficiency

```sql
SELECT
    s.vocation_id,
    p.spell_name,
    SUM(p.casts) AS casts,
    ROUND(SUM(p.damage) / NULLIF(SUM(p.casts), 0)) AS damage_per_cast,
    ROUND(SUM(p.healing) / NULLIF(SUM(p.casts), 0)) AS healing_per_cast,
    ROUND((SUM(p.damage) + SUM(p.healing)) / NULLIF(SUM(p.mana_spent), 0), 2) AS output_per_mana
FROM analytics_session_spells p
JOIN analytics_sessions s ON s.id = p.session_id
GROUP BY s.vocation_id, p.spell_name
HAVING SUM(p.casts) >= 100;
```

## Operational safeguards

- Disabled mode returns before creating sessions.
- Sessions are created only after a metric is recorded.
- Staff characters are excluded by default.
- PvP and player-summon combat are excluded by default.
- Completed sessions are bounded by `queueLimit`.
- Database-disabled mode does not accumulate an undrainable queue.
- Session and detail writes use idempotent upserts, so a retry does not duplicate aggregates.
- Failed session or detail writes requeue the complete session while capacity remains.
- Database failures do not stop the game server.
- Player names can be omitted from analytics records.
- Prometheus labels are intentionally not added per player, spell, or monster to avoid cardinality problems.
