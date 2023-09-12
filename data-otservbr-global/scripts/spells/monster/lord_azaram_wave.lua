local combatSmall = Combat()
combatSmall:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combatSmall:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITBYPOISON)

local combatLarge = Combat()
combatLarge:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combatLarge:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITBYPOISON)

local areaSmall = {
	{ 0, 0, 0, 0, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 3, 0, 0 },
}

local areaLarge = {
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 0, 3, 0, 0, 0 },
}

combatSmall:setArea(createCombatArea(areaSmall))
combatLarge:setArea(createCombatArea(areaLarge))

local spell = Spell("instant")

local combats = { combatSmall, combatLarge }

function spell.onCastSpell(creature, var)
	local randomCombat = combats[math.random(#combats)]
	return randomCombat:execute(creature, var)
end

spell:name("lord azaram wave")
spell:words("###6031")
spell:needLearn(true)
spell:cooldown("2000")
spell:needDirection(true)
spell:isSelfTarget(true)
spell:register()
