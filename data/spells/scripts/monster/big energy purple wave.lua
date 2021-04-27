local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PURPLEENERGY)

local area = createCombatArea(AREA_WAVE11)
combat:setArea(area)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
