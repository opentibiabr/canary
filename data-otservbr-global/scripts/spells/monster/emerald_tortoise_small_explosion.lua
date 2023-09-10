local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BLUE_ENERGY_SPARK)
arr_small = {
	{ 1, 1, 1 },
	{ 1, 3, 1 },
	{ 1, 1, 1 },
}

local area = createCombatArea(arr_small)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("emerald tortoise small explosion")
spell:words("###6025")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
