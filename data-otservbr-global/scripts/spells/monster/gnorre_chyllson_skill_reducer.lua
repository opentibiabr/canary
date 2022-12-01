local combat = {}

for i = 45, 55 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_POFF)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 3000)
	condition:setParameter(CONDITION_PARAM_SKILL_DISTANCEPERCENT, i)
	condition:setParameter(CONDITION_PARAM_SKILL_MELEEPERCENT, i)
	condition:setParameter(CONDITION_PARAM_SKILL_FISTPERCENT, i)
	condition:setParameter(CONDITION_PARAM_SKILL_SHIELDPERCENT, i)

	local area = createCombatArea(AREA_CIRCLE3X3)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(45, 55)]:execute(creature, var)
end

spell:name("gnorre chyllson skill reducer")
spell:words("###57")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()