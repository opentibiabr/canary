local combat = {}

for i = 15, 30 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 15000)
	condition:setParameter(CONDITION_PARAM_SKILL_DISTANCEPERCENT, i)

	local area = createCombatArea(AREA_CIRCLE3X3)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(15, 30)]:execute(creature, var)
end

spell:name("morgaroth skill reducer 1")
spell:words("###191")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()