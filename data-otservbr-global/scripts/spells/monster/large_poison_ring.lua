local spell = Spell("instant")

local aLarge = {
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0 },
	{ 1, 1, 1, 1, 0, 0, 3, 0, 0, 1, 1, 1, 1 },
	{ 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
}

local combatLargeRing = Combat()
combatLargeRing:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combatLargeRing:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREEN_RINGS)
combatLargeRing:setArea(createCombatArea(aLarge))

local combats = { combatLargeRing }

function spell.onCastSpell(creature, var)
	local randomCombat = combats[math.random(#combats)]
	return randomCombat:execute(creature, var)
end

spell:name("largepoisonring")
spell:words("###large_poison_ring")
spell:needLearn(true)
spell:isSelfTarget(true)
spell:register()
