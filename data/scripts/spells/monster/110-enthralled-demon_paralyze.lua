	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLCLOUDS)
	combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SUDDENDEATH)

	local condition = Condition(CONDITION_PARALYZE)
	condition:setParameter(CONDITION_PARAM_TICKS, 25000)
	condition:setFormula(-0.3, 0, -0.45, 0)
	combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("enthralled demon paralyze")
spell:words("###110")
spell:needTarget(true)
spell:needLearn(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:needDirection(true)
spell:register()
