local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_LIFEDRAIN)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BLACKSMOKE)

	arr = {
		{0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
	}

local area = createCombatArea(arr)
	combat:setArea(area)


local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("rustheap golem wave")
spell:words("###142")
spell:needTarget(false)
spell:needLearn(true)
spell:isAggressive(true)
spell:needDirection(true)
spell:blockWalls(true)
spell:register()
