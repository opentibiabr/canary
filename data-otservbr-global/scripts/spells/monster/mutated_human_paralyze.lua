	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_POISON)

	local condition = Condition(CONDITION_PARALYZE)
	condition:setParameter(CONDITION_PARAM_TICKS, 5000)
	condition:setFormula(-0.05, 0, -0.15, 0)
	combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("mutated human paralyze")
spell:words("###280")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()