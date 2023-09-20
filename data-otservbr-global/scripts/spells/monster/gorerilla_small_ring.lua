local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)
arr = {
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 0, 1, 1, 0, 0 },
	{ 0, 0, 1, 0, 3, 0, 1, 0, 0 },
	{ 0, 0, 1, 1, 0, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

local area = createCombatArea(arr)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("gorerilla small ring")
spell:words("###6027")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
