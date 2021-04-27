local combat = {}

for i = 30, 60 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SOUND_RED)
	combat[i]:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SUDDENDEATH)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 10000)
	condition:setParameter(CONDITION_PARAM_SKILL_SHIELDPERCENT, i)
	combat[i]:addCondition(condition)
end

function onCastSpell(creature, var)
	return combat[math.random(30, 60)]:execute(creature, var)
end
