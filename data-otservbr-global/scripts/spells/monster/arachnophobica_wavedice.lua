local combat = Combat()
Combat.setParameter(combat, COMBAT_PARAM_TYPE, COMBAT_DROWNDAMAGE)
Combat.setParameter(combat, COMBAT_PARAM_EFFECT, CONST_ME_CRAPS)

	arr = {
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
	}

local area = createCombatArea(arr)
Combat.setArea(combat, area)


local spell = Spell("instant")

function spell.onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end

spell:name("arachnophobicawavedice")
spell:words("###467")
spell:needLearn(true)
spell:needDirection(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()