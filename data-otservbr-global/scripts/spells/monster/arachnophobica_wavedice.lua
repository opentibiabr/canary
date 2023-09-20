local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DROWNDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_CRAPS)

local area = createCombatArea({
	{ 1, 1, 1 },
	{ 0, 1, 0 },
	{ 0, 3, 0 },
})

combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("arachnophobicawavedice")
spell:words("###467")
spell:needLearn(true)
spell:needDirection(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
