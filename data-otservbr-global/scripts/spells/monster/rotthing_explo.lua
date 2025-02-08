local spell = Spell("instant")

local arr = {
	{ 0, 0, 0, 0, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 1, 3, 1, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 0, 0, 0, 0 },
}

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)
combat:setArea(createCombatArea(arr))

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("rotthligexplo")
spell:words("###rotth_explo")
spell:needLearn(true)
spell:isSelfTarget(true)
spell:register()
