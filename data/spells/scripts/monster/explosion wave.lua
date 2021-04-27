local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONHIT)
arr = {
{1, 1, 1},
{1, 1, 1},
{0, 1, 0},
{0, 3, 0}
}

	local area = createCombatArea(arr)
	combat:setArea(area)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
