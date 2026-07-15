local SPELL_BASE_POWER = 97

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_CHAIN_EFFECT, CONST_ME_FORKED_THORNS)

function onGetFormulaValues(player, level, maglevel)
	local damage = player:calculateFlatDamageHealing() + (SPELL_BASE_POWER / 25 * maglevel) + (SPELL_BASE_POWER / 4)
	return -(damage * 0.9), -(damage * 1.1)
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function canForkedThorns(creature, target)
	return not target:isNpc() and creature ~= target and not target:getTile():hasFlag(TILESTATE_PROTECTIONZONE)
end

combat:setCallback(CALLBACK_PARAM_CHAINPICKER, "canForkedThorns")

function getForkedThornsValues(creature)
	local targets = 6
	local player = creature:getPlayer()
	if player then
		targets = targets + player:getWheelSpellAdditionalTarget("Forked Thorns")
	end
	return targets, 4, false, true, 7
end

combat:setCallback(CALLBACK_PARAM_CHAINVALUE, "getForkedThornsValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Forked Thorns")
spell:words("exevo fur tera")
spell:group("attack")
spell:vocation("druid;true", "elder druid;true")
spell:id(318)
spell:cooldown(6 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(80)
spell:mana(180)
spell:range(7)
spell:isAggressive(true)
spell:isPremium(true)

spell:register()
