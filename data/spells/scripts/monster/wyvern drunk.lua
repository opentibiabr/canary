local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SOUND_RED)

local condition = Condition(CONDITION_DRUNK)
condition:setParameter(CONDITION_PARAM_TICKS, 25000)
combat:addCondition(condition)

	arr = {
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
	}

local area = createCombatArea(arr)
combat:setArea(area)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
