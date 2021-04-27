local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREEN_RINGS)

local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 20000)
condition:setFormula(-0.6, 0, -0.75, 0)
combat:addCondition(condition)

	local area = createCombatArea(AREA_CIRCLE2X2)
	combat:setArea(area)
	combat:addCondition(condition)


function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
