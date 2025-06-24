local combatLarge = Combat()
combatLarge:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combatLarge:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ORANGE_ENERGY_SPARK)

local combatSmall = Combat()
combatSmall:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combatSmall:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WHITE_ENERGY_SPARK)

local ENERGIT_PATTERN = {
	{ 0, 1, 0, 1, 0 },
	{ 1, 0, 0, 0, 1 },
	{ 1, 0, 0, 0, 1 },
	{ 0, 1, 3, 1, 0 },
}

local ENERGIT_PATTERN2 = {
	{ 1, 0, 0, 0, 0, 0, 1 },
	{ 0, 1, 0, 0, 0, 1, 0 },
	{ 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 1, 0, 1, 0, 0 },
	{ 0, 0, 0, 3, 0, 0, 0 },
}

combatLarge:setArea(createCombatArea(ENERGIT_PATTERN))
combatSmall:setArea(createCombatArea(ENERGIT_PATTERN2))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	-- Executa os dois padrões simultaneamente
	combatSmall:execute(creature, var)
	combatLarge:execute(creature, var)
	return true
end

spell:name("arbazilothspells")
spell:words("###630")
spell:blockWalls(true)
spell:needDirection(true)
spell:needLearn(true)
spell:register()