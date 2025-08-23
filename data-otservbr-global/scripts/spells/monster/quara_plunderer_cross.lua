local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_LIFEDRAIN)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
arr = {
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 1, 1, 1, 2, 1, 1, 1 },
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 0, 1, 0, 0, 0 },
}

local area = createCombatArea(arr)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("quaracrossdeath")
spell:words("###quara_cross_death")
spell:needLearn(true)
spell:isSelfTarget(true)
spell:register()
