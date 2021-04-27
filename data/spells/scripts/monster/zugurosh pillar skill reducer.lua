local combat = {}

for i = 1, 20 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLCLOUDS)
	combat[i]:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SUDDENDEATH)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 7000)
	condition:setParameter(CONDITION_PARAM_SKILL_SHIELDPERCENT, i)
	combat[i]:addCondition(condition)
end

function onCastSpell(creature, var)
	return combat[math.random(1, 20)]:execute(creature, var)
end
