local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WATERSPLASH)
arr = {
	{ 0, 0, 1, 0 },
	{ 1, 0, 2, 0 },
	{ 0, 0, 0, 1 },
	{ 0, 1, 0, 0 },
}

local area = createCombatArea(arr)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("quarawatersplash")
spell:words("###quara_water_splash")
spell:needLearn(true)
spell:isSelfTarget(false)
spell:register()
