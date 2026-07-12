# Gameplay Analytics spell telemetry

`GameplayAnalytics.recordSpell(player, spellName, damage, healing, mana, targets, critical)`
stores per-spell aggregates (casts, targets, damage, healing, mana, critical
hits) in `analytics_session_spells`, separate from the session-wide totals in
`analytics_sessions`. This document explains how spell and rune scripts report
a cast and how to add the same wiring to more spells.

## Why this cannot double-count

The generic combat hooks in
`data-otservbr-global/scripts/systems/gameplay_analytics.lua` already record
every hit through the engine-wide health-change and drain-health callbacks,
regardless of whether it came from a spell, a weapon, or anything else. A
spell script must never call `Analytics.recordDamageDealt`,
`Analytics.recordHealing` or `Analytics.recordManaSpent` directly — those
generic hooks already added the amount to `analytics_sessions.damage_dealt`,
`healing_self`/`healing_others` and `mana_spent`. `recordSpell` only writes to
the separate per-spell table, so calling it does not touch those session
totals at all.

What still has to happen correctly is attributing the *right* damage/healing
number to *this* cast. `data/scripts/lib/gameplay_analytics_spell.lua`
handles that with a before/after snapshot instead of recomputing anything:

```lua
function GameplayAnalyticsSpell.recordCast(analytics, caster, spellName, manaCost, targets, execute)
	if not analytics then
		return execute()
	end

	local damageBefore, healingBefore = analytics.combatTotals(caster)
	local success = execute()

	if success then
		local damageAfter, healingAfter = analytics.combatTotals(caster)
		analytics.recordSpell(caster, spellName, damageAfter - damageBefore, healingAfter - healingBefore, manaCost, targets, false)
	end

	return success
end
```

`Analytics.combatTotals(player)` (added to
`data-otservbr-global/scripts/lib/gameplay_analytics.lua`) is a read-only
accessor over the same counters the generic hooks already maintain. Reading
the delta this way means the spell integration can never add to those
counters a second time — it only reads what already happened.

## Critical hits are not currently detectable

The engine does not expose a per-cast critical-hit flag to Lua. Rather than
guess, this integration always reports `critical = false`. Extending
`recordSpell` with real critical detection is a separate, engine-level change.

## Why this lives partly in the shared `data` core

Spell and rune scripts live under the shared `data/scripts/spells` and
`data/scripts/runes` folders, loaded together with whichever data pack
(`data-otservbr-global`, `data-canary`, ...) is configured. The Gameplay
Analytics runtime currently only ships with `data-otservbr-global`.

Integrated scripts must never `dofile` the Analytics core. Re-executing
`data-otservbr-global/scripts/lib/gameplay_analytics.lua` after the context,
batching and reliability layers were installed can replace their wrapped
functions while leaving the installation flags set, silently disabling those
layers. It also makes behaviour depend on script load order.

Instead, each cast passes the live `GameplayAnalytics` global to the helper at
the moment the cast happens:

```lua
local AnalyticsSpell = dofile("data/scripts/lib/gameplay_analytics_spell.lua")

function spell.onCastSpell(creature, variant)
	return AnalyticsSpell.recordCast(GameplayAnalytics, creature, "Spell Name", 100, 1, function()
		return combat:execute(creature, variant)
	end)
end
```

When the active data pack does not provide Analytics, `GameplayAnalytics` is
`nil`. `AnalyticsSpell.recordCast(nil, ...)` is a pure pass-through: it calls
and returns the original cast closure without reporting anything. Resolving
the global at cast time also remains safe when shared spell scripts are loaded
before the OTServBR-Global Analytics runtime.

## Integrated spells and runes

| File | Kind | Mana passed | Targets passed |
|---|---|---:|---:|
| `data/scripts/spells/attack/ethereal_spear.lua` | offensive spell | `25` (matches `spell:mana(25)`) | `1` (single target) |
| `data/scripts/spells/healing/ultimate_healing.lua` | healing spell | `160` (matches `spell:mana(160)`) | `1` (self-target only) |
| `data/scripts/runes/fireball.lua` | offensive rune | `0` (runes have no cast-time mana cost) | `1` (single target) |
| `data/scripts/runes/intense_healing_rune.lua` | healing rune | `0` (runes have no cast-time mana cost) | `1` (single target) |

These four are a small, verified starting set covering offensive, healing and
rune-based casts, not an exhaustive audit of every spell file.

## Adding another spell or rune

1. Confirm the spell has a fixed, known target count. Only pass a literal
   `targets` value you can justify from the spell's own configuration (for
   example `isSelfTarget(true)` or `needTarget(true)` with no `area()` call
   means `1`). Do not guess a count for area-of-effect spells; extending this
   pattern to those needs a per-target hit count, which is not wired up yet.
2. Load only `data/scripts/lib/gameplay_analytics_spell.lua`. Do not load or
   re-execute the Analytics core from the spell/rune script.
3. Wrap the existing `combat:execute(...)` call in
   `AnalyticsSpell.recordCast(GameplayAnalytics, creature, "<Spell Name>", <mana>, <targets>, function() ... end)`,
   keeping the original return value.
4. Pass the same mana value already configured via `spell:mana(...)` /
   `rune:mana(...)` (or `0` when the script has no such call, as with runes).
   Never invent a value.
5. Run `python tools/analytics/validate_gameplay_analytics_spell_integration.py`
   and add the new file to `INTEGRATED_FILES` in that script, or rely on the
   repository-wide scan in the same script to catch any accidental direct
   call to `Analytics.recordDamageDealt`, `Analytics.recordHealing` or
   `Analytics.recordManaSpent` in the file.

## Configuration

Spell aggregates are only persisted when both `enabled` and `trackSpells` are
`true` in `data-otservbr-global/scripts/config/gameplay_analytics.lua` (see
`docs/systems/gameplay-analytics.md`). With either disabled,
`AnalyticsSpell.recordCast` still calls the spell's own combat execution
normally; it only skips reporting.
