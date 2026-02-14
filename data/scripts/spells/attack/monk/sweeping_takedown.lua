local SPELL_BASE_POWER_CENTER = 48
local sweepingTakedownCache = {}

local combatInner = Combat()
combatInner:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combatInner:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BLOW_WHITE)
combatInner:setArea(createCombatArea(AREA_SWEEPING_CENTER))

local combatOuter = Combat()
combatOuter:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combatOuter:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BLOW_WHITE)
combatOuter:setArea(createCombatArea(AREA_SWEEPING_OUTER))

local function calculateSweepingDamage(player, skill, attack, basePower)
	local levelBasedDmg = player:calculateFlatDamageHealing()

	local skillBonus = 0
	local delta = skill - 110
	local deltaSq = delta * delta

	if skill > 250 then
		skillBonus = deltaSq * 0.043
	elseif skill > 230 then
		skillBonus = deltaSq * 0.039
	elseif skill > 210 then
		skillBonus = deltaSq * 0.037
	elseif skill > 190 then
		skillBonus = deltaSq * 0.035
	elseif skill > 160 then
		skillBonus = deltaSq * 0.033
	elseif skill > 140 then
		skillBonus = deltaSq * 0.029
	elseif skill > 130 then
		skillBonus = deltaSq * 0.026
	elseif skill > 120 then
		skillBonus = deltaSq * 0.024
	elseif skill > 110 then
		skillBonus = deltaSq * 0.022
	end

	local baseDamage = skill * attack * basePower / 1000 + levelBasedDmg + skillBonus

	return player:getHarmonyDamage(baseDamage * 1.3, baseDamage * 1.7)
end

-- Callbacks
function onGetFormulaValuesInner(player, skill, attack, factor)
	local min, max = calculateSweepingDamage(player, skill, attack, SPELL_BASE_POWER_CENTER)
	sweepingTakedownCache[player:getId()] = { min = min, max = max }
	return min, max
end

function onGetFormulaValuesOuter(player, skill, attack, factor)
	local cached = sweepingTakedownCache[player:getId()]
	if not cached then
		logger.debug(string.format("[Sweeping Takedown - Outer] Cache miss for player %s, returning 0 damage", player:getName()))
		return 0, 0 -- safe fallback
	end

	local min = cached.min * 0.75
	local max = cached.max * 0.75

	logger.trace(string.format("[Sweeping Takedown - Outer] Player: %s | Outer scaled to 75%% of Center | Final: %.2f ~ %.2f", player:getName(), min, max))

	return min, max
end

combatInner:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesInner")
combatOuter:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesOuter")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local playerId = creature:getId()
	combatInner:execute(creature, var)
	combatOuter:execute(creature, var)
	-- Clean up cache to prevent memory leak
	sweepingTakedownCache[playerId] = nil
	return true
end

spell:group("attack")
spell:id(294)
spell:name("Sweeping Takedown")
spell:words("exori mas nia")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_BRUTAL_STRIKE)
spell:level(60)
spell:mana(210)
spell:isPremium(true)
spell:range(1)
spell:needTarget(false)
spell:blockWalls(true)
spell:needDirection(true)
spell:cooldown(8 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:monkSpellType(MonkSpell_Spender)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
