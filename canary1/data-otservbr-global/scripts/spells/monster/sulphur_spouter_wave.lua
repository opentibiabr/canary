local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)

AREA_WAVE = {
	{ 0, 0, 0, 0, 0 },
	{ 1, 1, 1, 1, 1 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 0, 3, 0, 0 },
}

combat:setArea(createCombatArea(AREA_WAVE))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("sulphur spouter wave")
spell:words("###6017")
spell:needLearn(true)
spell:cooldown("2000")
spell:needDirection(true)
spell:isSelfTarget(true)
spell:register()
