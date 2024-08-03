local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PURPLESMOKE)
local arr = {
	{ 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 1, 1, 1, 0, 1, 1, 1 },
	{ 1, 1, 0, 3, 0, 1, 1 },
	{ 1, 1, 1, 0, 1, 1, 1 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 0, 0 },
}

combat:setArea(createCombatArea(arr))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("mercurial menace ring")
spell:words("###6021")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
