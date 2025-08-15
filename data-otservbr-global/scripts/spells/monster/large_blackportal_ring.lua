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
combatLargeRing:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combatLargeRing:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)
combatLargeRing:setArea(createCombatArea(aLarge))

local combats = { combatLargeRing }

function spell.onCastSpell(creature, var)
	local randomCombat = combats[math.random(#combats)]
	return randomCombat:execute(creature, var)
end

spell:name("largedeathring")
spell:words("###large_death_ring")
spell:needLearn(true)
spell:isSelfTarget(true)
spell:register()
