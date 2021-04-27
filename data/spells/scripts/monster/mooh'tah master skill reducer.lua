	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_STUN)
	combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SUDDENDEATH)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 3000)
	condition:setParameter(CONDITION_PARAM_SKILL_SHIELDPERCENT, -100)
	combat:addCondition(condition)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
