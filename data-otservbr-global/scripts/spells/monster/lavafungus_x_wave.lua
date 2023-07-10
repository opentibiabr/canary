local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONHIT)
arr = {
{1, 0, 1},
{0, 2, 0},
{1, 0, 1},
}


local area = createCombatArea(arr)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("lavafungus x wave")
spell:words("###6003")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()