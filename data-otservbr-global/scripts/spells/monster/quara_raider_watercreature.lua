local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WATERCREATURE)
arr = {
	{ 1, 0, 1 },
	{ 0, 0, 0 },
	{ 0, 1, 0 },
	{ 0, 2, 0 },
}

local area = createCombatArea(arr)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("quaraseamonster")
spell:words("###quara_sea_monster")
spell:needLearn(true)
spell:isSelfTarget(false)
spell:register()
