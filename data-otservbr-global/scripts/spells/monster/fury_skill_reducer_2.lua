local combat = {}

for i = 45, 60 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SOUND_YELLOW)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 5000)
	condition:setParameter(CONDITION_PARAM_SKILL_MELEEPERCENT, i)
	condition:setParameter(CONDITION_PARAM_SKILL_DISTANCEPERCENT, i)
	condition:setParameter(CONDITION_PARAM_SKILL_FISTPERCENT, i)

	local area = createCombatArea(AREA_CIRCLE3X3)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(45, 60)]:execute(creature, var)
end

spell:name("fury skill reducer 2")
spell:words("###169")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()