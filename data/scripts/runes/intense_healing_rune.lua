local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setParameter(COMBAT_PARAM_TARGETCASTERORTOPMOST, 1)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 3.2) + 20
	local max = (level / 5) + (maglevel * 5.4) + 40
	return min, max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local AnalyticsSpell = dofile("data/scripts/lib/gameplay_analytics_spell.lua")
local AnalyticsPrices = dofile("data/scripts/lib/gameplay_analytics_prices.lua")

local rune = Spell("rune")

function rune.onCastSpell(creature, var, isHotkey)
	if Monster(var:getNumber(1073762188)) then
		creature:sendCancelMessage("Sorry, not possible.")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	else
		local analytics = GameplayAnalytics
		local success = AnalyticsSpell.recordCast(analytics, creature, "Intense Healing Rune", 0, 1, function()
			return combat:execute(creature, var)
		end)
		if success and analytics then
			analytics.recordSupply(creature, 3152, 1, AnalyticsPrices.buyPrice(3152))
		end
		return success
	end
end

rune:id(4)
rune:group("healing")
rune:name("intense healing rune")
rune:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
rune:impactSound(SOUND_EFFECT_TYPE_SPELL_INTENSE_HEALING_RUNE)
rune:runeId(3152)
rune:allowFarUse(true)
rune:charges(1)
rune:level(15)
rune:magicLevel(1)
rune:cooldown(1 * 1000)
rune:groupCooldown(1 * 1000)
rune:isAggressive(false)
rune:needTarget(true)
rune:isBlocking(true) -- True = Solid / False = Creature
rune:register()
