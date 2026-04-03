local SPELL_BASE_POWER = 74

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_CHAIN_EFFECT, CONST_ME_WHITE_ENERGY_SPARK)

function onGetFormulaValues(player, skill, attack, factor)
	local damageHealing = player:calculateFlatDamageHealing()

	local damage = SPELL_BASE_POWER * (skill / 100) * (attack / 10) + damageHealing

	local min = damage - (damage / 10)
	local max = damage + (damage / 10)

	return min, max
end
combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function canChain(creature, target)
	if target:isNpc() or creature == target or target:getTile():hasFlag(TILESTATE_PROTECTIONZONE) then
		return false
	end
	return true
end

combat:setCallback(CALLBACK_PARAM_CHAINPICKER, "canChain")

function getChainValue(creature)
	local targets = 3
	local player = creature:getPlayer()
	if player then
		targets = targets + player:getWheelSpellAdditionalTarget("Chained Penance")
	end
	return targets, 3, false
end

combat:setCallback(CALLBACK_PARAM_CHAINVALUE, "getChainValue")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:group("attack")
spell:id(288)
spell:name("Chained Penance")
spell:words("exori med pug")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_CHIVALROUS_CHALLENGE)
spell:level(70)
spell:mana(180)
spell:isAggressive(true)
spell:isPremium(true)
spell:cooldown(4 * 1000)
spell:groupCooldown(2 * 1000)
spell:monkSpellType(MonkSpell_Builder)
spell:vocation("monk;true", "exalted monk;true")
spell:needLearn(false)
spell:register()
