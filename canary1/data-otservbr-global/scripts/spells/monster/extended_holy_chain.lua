local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_CHAIN_EFFECT, CONST_ME_HOLYDAMAGE)

function getChainValue(creature)
	return 3, 3, false
end

combat:setCallback(CALLBACK_PARAM_CHAINVALUE, "getChainValue")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("extended holy chain")
spell:words("###6012")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
