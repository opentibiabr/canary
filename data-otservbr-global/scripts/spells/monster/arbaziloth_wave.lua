local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)

local area = {
	{ 1, 1, 1 },
	{ 1, 1, 1 },
	{ 1, 1, 1 },
	{ 0, 1, 0 },
	{ 0, 3, 0 },
}

combat:setArea(createCombatArea(area))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("arbazilothwave")
spell:words("###629")
spell:blockWalls(true)
spell:needDirection(true)
spell:needLearn(true)
spell:register()