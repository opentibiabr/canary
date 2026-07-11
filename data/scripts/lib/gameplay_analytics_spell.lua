-- Shared helper that lets spell and rune scripts report their own cast to
-- Gameplay Analytics (GameplayAnalytics.recordSpell) without double-counting
-- the session-wide damage, healing or mana totals that the generic combat
-- hooks in data-otservbr-global/scripts/systems/gameplay_analytics.lua
-- already collect.
--
-- This file lives under the shared "data" core because spells and runes are
-- shared across data packs, while the Gameplay Analytics library currently
-- only ships with data-otservbr-global. Callers must load that library
-- themselves through pcall(dofile, ...) and pass the result in (or nil when
-- it is unavailable, e.g. under a different data pack); this helper never
-- loads it directly so it stays a plain no-op wherever the library is
-- missing or Analytics is disabled.

local GameplayAnalyticsSpell = {}

-- analytics: the table returned by gameplay_analytics.lua, or nil.
-- caster: the creature casting the spell.
-- spellName: display name stored on analytics_session_spells.
-- manaCost: the spell's configured mana cost (the same value passed to
--   spell:mana(...)), not a value read back from the mana-change event.
-- targets: number of distinct creatures this cast can hit. Pass 1 for
--   single-target spells; do not guess a count for area spells.
-- execute: closure that performs the actual cast (usually
--   combat:execute(creature, variant)) and returns its boolean result.
function GameplayAnalyticsSpell.recordCast(analytics, caster, spellName, manaCost, targets, execute)
	if not analytics then
		return execute()
	end

	local damageBefore, healingBefore = analytics.combatTotals(caster)
	local success = execute()

	if success then
		local damageAfter, healingAfter = analytics.combatTotals(caster)
		analytics.recordSpell(caster, spellName, math.max(0, damageAfter - damageBefore), math.max(0, healingAfter - healingBefore), manaCost, targets, false)
	end

	return success
end

return GameplayAnalyticsSpell
