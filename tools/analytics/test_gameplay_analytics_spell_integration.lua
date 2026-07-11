local function assertEqual(actual, expected, message)
	if actual ~= expected then
		error(string.format("%s: expected %s, got %s", message or "assertion failed", tostring(expected), tostring(actual)), 2)
	end
end

local AnalyticsSpell = dofile("data/scripts/lib/gameplay_analytics_spell.lua")

local caster = { name = "Tester" }

-- 1. A nil analytics reference (data pack without the library, or a failed
--    pcall(dofile, ...)) must be a pure pass-through: the cast still runs and
--    its result is still returned, with no recordSpell call attempted.
do
	local executed = false
	local success = AnalyticsSpell.recordCast(nil, caster, "Test Spell", 25, 1, function()
		executed = true
		return true
	end)
	assertEqual(executed, true, "cast still executes without analytics")
	assertEqual(success, true, "cast result still returned without analytics")
end

-- 2. A successful cast records the damage/healing delta contributed by this
--    cast only, not the full session total, and passes mana/targets through
--    unchanged. Critical is always reported false: the engine does not
--    expose critical-hit detection to Lua.
do
	local session = { damageDealt = 500, healingSelf = 0, healingOthers = 0 }
	local recorded

	local analytics = {
		combatTotals = function(_)
			return session.damageDealt, session.healingSelf + session.healingOthers
		end,
		recordSpell = function(player, spellName, damage, healing, mana, targets, critical)
			recorded = { player = player, spellName = spellName, damage = damage, healing = healing, mana = mana, targets = targets, critical = critical }
		end,
	}

	local success = AnalyticsSpell.recordCast(analytics, caster, "Ethereal Spear", 25, 1, function()
		session.damageDealt = session.damageDealt + 120
		return true
	end)

	assertEqual(success, true, "successful cast returns true")
	assertEqual(recorded.player, caster, "recordSpell receives the caster")
	assertEqual(recorded.spellName, "Ethereal Spear", "recordSpell receives the spell name")
	assertEqual(recorded.damage, 120, "recordSpell receives only this cast's damage delta")
	assertEqual(recorded.healing, 0, "recordSpell receives zero healing for a pure damage cast")
	assertEqual(recorded.mana, 25, "recordSpell receives the configured mana cost")
	assertEqual(recorded.targets, 1, "recordSpell receives the configured target count")
	assertEqual(recorded.critical, false, "recordSpell always reports critical as false")
end

-- 3. A failed cast (no valid target reached, spell blocked, etc.) must not
--    call recordSpell at all.
do
	local calls = 0
	local analytics = {
		combatTotals = function(_)
			return 0, 0
		end,
		recordSpell = function(_, _, _, _, _, _, _)
			calls = calls + 1
		end,
	}

	local success = AnalyticsSpell.recordCast(analytics, caster, "Ethereal Spear", 25, 1, function()
		return false
	end)

	assertEqual(success, false, "failed cast result is preserved")
	assertEqual(calls, 0, "failed cast never calls recordSpell")
end

-- 4. The delta must exclude damage or healing this same player's session
--    already accumulated before the cast (e.g. from an earlier hit in the
--    same hunting session), proving spell integration cannot double-count
--    generic combat totals.
do
	local session = { damageDealt = 9001, healingSelf = 42, healingOthers = 8 }
	local recorded

	local analytics = {
		combatTotals = function(_)
			return session.damageDealt, session.healingSelf + session.healingOthers
		end,
		recordSpell = function(_, _, damage, healing, _, _, _)
			recorded = { damage = damage, healing = healing }
		end,
	}

	AnalyticsSpell.recordCast(analytics, caster, "Ultimate Healing", 160, 1, function()
		session.healingSelf = session.healingSelf + 300
		return true
	end)

	assertEqual(recorded.damage, 0, "pre-existing session damage is excluded from the cast delta")
	assertEqual(recorded.healing, 300, "only this cast's healing is attributed, not the whole session")
end

print("gameplay analytics spell integration test passed")
