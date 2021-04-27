local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PURPLEENERGY)

local area = createCombatArea(AREA_SQUAREWAVE6)
combat:setArea(area)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
