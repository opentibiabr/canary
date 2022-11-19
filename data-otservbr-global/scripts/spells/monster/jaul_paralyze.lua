	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BUBBLES)
	combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ICE)

	local condition = Condition(CONDITION_PARALYZE)
	condition:setParameter(CONDITION_PARAM_TICKS, 10000)
	condition:setFormula(-0.55, 0, -0.85, 0)
	combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("jaul paralyze")
spell:words("###170")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()