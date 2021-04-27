local combat = {}

for i = 5, 10 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_POFF)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 15000)
	condition:setParameter(CONDITION_PARAM_SKILL_MELEEPERCENT, i)
	condition:setParameter(CONDITION_PARAM_SKILL_FISTPERCENT, i)

	local condition2 = Condition(CONDITION_PARALYZE)
	condition2:setParameter(CONDITION_PARAM_TICKS, 20000)
	condition2:setFormula(-0.7, 0, -0.9, 0)

	local area = createCombatArea(AREA_CIRCLE2X2)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
	combat[i]:addCondition(condition2)
end

function onCastSpell(creature, var)
	return combat[math.random(5, 10)]:execute(creature, var)
end
