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

The feature does not issue SQL writes for individual hits. Data is accumulated in memory and flushed as completed sessions.

## Configuration

| Setting | Default | Purpose |
|---|---:|---|
| `enabled` | `false` | Master switch. |
| `databaseEnabled` | `true` | Persist completed sessions. |
| `flushIntervalSeconds` | `300` | Queue flush interval; minimum runtime value is 30 seconds. |
| `minimumSessionSeconds` | `60` | Discard shorter sessions. |
| `combatTimeoutSeconds` | `120` | Split hunts after inactivity. |
| `includeStaff` | `false` | Include staff characters. |
| `trackPvP` | `false` | Include player-versus-player damage. |
| `trackSpells` | `true` | Store spell aggregates reported through the API. |
| `trackMonsters` | `true` | Store per-monster aggregates. |
| `trackDamageTypes` | `true` | Store elemental damage aggregates. |
| `trackSupplies` | `false` | Store supply use reported through the API. |
| `trackLoot` | `false` | Store loot reported through the API. |
| `anonymizePlayers` | `false` | Do not persist character names. Player IDs remain for relational integrity. |
| `queueLimit` | `10000` | Maximum completed sessions awaiting persistence. |
| `detailLevel` | `1` | Reserved detail tier from 0 to 2. |

## Automatically collected data

The runtime hooks collect:

- raw and final experience,
- outgoing damage after combat calculation,
- incoming damage after combat calculation,
- effective self-healing and healing of others,
- overhealing,
- mana loss,
- monster kills,
- deaths,
- vocation and level,
- party size and shared-experience state,
- damage grouped by combat type,
- combat and session duration.

Monsters receive the health-change event on spawn, allowing player and summon damage to be attributed to the owning player.

## Optional integration API

Scripts can report domain-specific data that cannot be inferred reliably from generic combat events:

```lua
GameplayAnalytics.recordSpell(player, spellName, damage, healing, mana, targets, critical)
GameplayAnalytics.recordSupply(player, itemId, amount, unitValue)
GameplayAnalytics.recordLoot(player, itemId, amount, npcValue, marketValue)
```

Supply and loot collection remain disabled until enabled in the configuration.

## Administrative commands

```text
/analytics status
/analytics flush
/analytics enable
/analytics disable
```

Runtime enable/disable does not edit the Lua configuration and resets after restart.

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
- Staff characters are excluded by default.
- PvP is excluded by default.
- Completed sessions are bounded by `queueLimit`.
- Failed inserts are requeued while capacity remains.
- Database failures do not stop the game server.
- Player names can be omitted from analytics records.
- Prometheus labels are intentionally not added per player, spell, or monster to avoid cardinality problems.
