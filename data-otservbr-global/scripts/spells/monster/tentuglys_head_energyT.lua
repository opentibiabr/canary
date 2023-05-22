local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)

local combatArea = {
	{1, 1, 1},
	{0, 1, 0},
	{0, 1, 0},
	{0, 1, 0},
	{0, 3, 0}
}

combat:setArea(createCombatArea(combatArea))

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("energy waveT")
spell:words("###500")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()
