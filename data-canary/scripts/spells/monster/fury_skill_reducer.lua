local combat = {}

for i = 65, 80 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SOUND_YELLOW)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 5000)
	condition:setParameter(CONDITION_PARAM_SKILL_DEFENSEPERCENT, i)

	local area = createCombatArea(AREA_CIRCLE3X3)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(65, 80)]:execute(creature, var)
end

spell:name("fury skill reducer")
spell:words("###2")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
