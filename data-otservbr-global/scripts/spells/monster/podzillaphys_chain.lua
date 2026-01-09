local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ORANGE_ENERGY_SPARK)
combat:setParameter(COMBAT_PARAM_CHAIN_EFFECT, CONST_ME_ORANGE_ENERGY_SPARK)

function getChainValue(creature)
	return 2, 3, false
end

function canChain(creature, target)
	if target:isPlayer() then
		if target:getPosition():isProtectionZoneTile() then
			return false
		end
		return true
	end
	return false
end

combat:setCallback(CALLBACK_PARAM_CHAINVALUE, "getChainValue")
combat:setCallback(CALLBACK_PARAM_CHAINPICKER, "canChain")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("podzillaphyschain")
spell:words("#876011")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
