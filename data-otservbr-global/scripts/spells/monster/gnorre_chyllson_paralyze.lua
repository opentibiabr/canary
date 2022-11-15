	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
	combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SNOWBALL)

	local condition = Condition(CONDITION_PARALYZE)
	condition:setParameter(CONDITION_PARAM_TICKS, 20000)
	condition:setFormula(-0.1, 0, -0.2, 0)
	combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("gnorre chyllson paralyze")
spell:words("###58")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()