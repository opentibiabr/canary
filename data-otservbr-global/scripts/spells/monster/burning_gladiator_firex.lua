local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREATTACK)
arr = {
{1, 0, 1},
{0, 2, 0},
{1, 0, 1}
}

local area = createCombatArea(arr)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("firex")
spell:words("###479")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()