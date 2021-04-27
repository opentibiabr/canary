	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)

	local condition = Condition(CONDITION_FREEZING)
	condition:setParameter(CONDITION_PARAM_DELAYED, 1)
	condition:addDamage(25, 8000, -8)
	combat:addCondition(condition)

	local area = createCombatArea(AREA_CIRCLE3X3)
	combat:setArea(area)
	combat:addCondition(condition)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
