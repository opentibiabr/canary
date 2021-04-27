local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)

local area = createCombatArea(AREA_WAVE12)
combat:setArea(area)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
