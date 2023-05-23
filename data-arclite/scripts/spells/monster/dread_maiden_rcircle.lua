local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_LIFEDRAIN)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_DRAWBLOOD)

local combatArea = {
	{0, 0, 1, 1, 1, 0, 0},
	{0, 1, 0, 0, 0, 1, 0},
	{1, 0, 0, 2, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 1},
	{0, 1, 0, 0, 0, 1, 0},
	{0, 0, 1, 1, 1, 0, 0}
}

combat:setArea(createCombatArea(combatArea))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("dread rcircle")
spell:words("###505")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()
