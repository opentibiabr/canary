local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)

local area = createCombatArea(AREA_SQUAREWAVE7)
combat:setArea(area)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
