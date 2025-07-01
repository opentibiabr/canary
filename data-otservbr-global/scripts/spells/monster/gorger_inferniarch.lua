local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WHITE_ENERGY_SPARK)

local area = {
	{ 1, 1, 1 },
	{ 1, 1, 1 },
	{ 1, 1, 1 },
	{ 0, 3, 0 },
}

combat:setArea(createCombatArea(area))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("gorgewave")
spell:words("###627")
spell:blockWalls(true)
spell:needDirection(true)
spell:needLearn(true)
spell:register()