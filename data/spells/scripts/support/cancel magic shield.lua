
local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

function onCastSpell(creature, var)
	creature:removeCondition(CONDITION_MANASHIELD)
	return combat:execute(creature, var)
end
