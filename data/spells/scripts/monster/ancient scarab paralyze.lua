	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_POISONAREA)
	combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_POISON)

	local condition = Condition(CONDITION_PARALYZE)
	combat:setParameter(CONDITION_PARAM_TICKS, 25000)
	combat:setFormula(-0.45, 0, -0.75, 0)
	combat:addCondition(condition)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
