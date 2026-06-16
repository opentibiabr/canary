local SPELL_BASE_POWER = 42

local combatRecast = Combat()
combatRecast:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combatRecast:setParameter(COMBAT_PARAM_CHAIN_EFFECT, CONST_ME_BLOW_WHITE)

function onGetFormulaValuesRecast(player, skill, attack, factor)
	local defaultDecreasedDamage = 37.5
	local damageHealing = player:calculateFlatDamageHealing()

	local damage = SPELL_BASE_POWER * (skill / 100) * (attack / 10) + damageHealing

	local grade = player:revelationStageWOD("Spiritual Outburst")
	defaultDecreasedDamage = (defaultDecreasedDamage + (12.5 * (grade - 1))) / 100

	local min = (damage - (damage / 10)) * defaultDecreasedDamage
	local max = (damage + (damage / 10)) * defaultDecreasedDamage

	return player:getHarmonyDamage(min, max)
end
combatRecast:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesRecast")

function canChainRecast(creature, target)
	if target:isNpc() or creature == target or target:getTile():hasFlag(TILESTATE_PROTECTIONZONE) then
		return false
	end
	return true
end

combatRecast:setCallback(CALLBACK_PARAM_CHAINPICKER, "canChainRecast")

function getChainValueRecast(creature)
	local targets = 6
	return targets, 2, false
end

combatRecast:setCallback(CALLBACK_PARAM_CHAINVALUE, "getChainValueRecast")

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_CHAIN_EFFECT, CONST_ME_BLOW_WHITE)

function onGetFormulaValues(player, skill, attack, factor)
	local damageHealing = player:calculateFlatDamageHealing()

	local damage = SPELL_BASE_POWER * (skill / 100) * (attack / 10) + damageHealing

	local min = damage - (damage / 10)
	local max = damage + (damage / 10)

	return player:getHarmonyDamage(min, max)
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
	local targets = 6
	return targets, 2, false
end

combat:setCallback(CALLBACK_PARAM_CHAINVALUE, "getChainValue")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local player = creature and creature:getPlayer() or nil
	if not player then
		return false
	end

	local grade = player:revelationStageWOD("Spiritual Outburst")
	if grade == 0 then
		player:sendCancelMessage("You cannot cast this spell")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if player and player:getHarmony() == 5 then
		addEvent(function(playerGuid, spellVar)
			local recastPlayer = Player(playerGuid)
			if recastPlayer then
				combatRecast:execute(recastPlayer, spellVar)
			end
		end, 1000, player:getGuid(), var)
	end

	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(295)
spell:name("Spiritual Outburst")
spell:words("exori gran mas nia")
spell:level(0)
spell:mana(425)
spell:isPremium(true)
spell:blockWalls(true)
spell:cooldown(24 * 1000) -- Cooldown is calculated on the casting
spell:groupCooldown(2 * 1000)
spell:needLearn(true)
spell:monkSpellType(MonkSpell_Spender)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
