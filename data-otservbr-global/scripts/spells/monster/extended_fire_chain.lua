local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREATTACK)
combat:setParameter(COMBAT_PARAM_CHAIN_EFFECT, CONST_ME_FIREATTACK)

function getChainValue(creature)
	return 3, 3, false
end

combat:setCallback(CALLBACK_PARAM_CHAINVALUE, "getChainValue")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("extended fire chain")
spell:words("###6013")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
