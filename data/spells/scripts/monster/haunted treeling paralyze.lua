local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLPLANTS)

local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 20000)
condition:setFormula(-0.55, 0, -0.75, 0)
combat:addCondition(condition)

	arr = {
		{1},
		{1},
		{1},
		{1},
		{1},
		{3}
			}

local area = createCombatArea(arr)
	combat:setArea(area)
	combat:addCondition(condition)


function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
