local combat = {}

for i = 15, 45 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 10000)
	condition:setParameter(CONDITION_PARAM_SKILL_DISTANCEPERCENT, i)

	local area = createCombatArea(AREA_CIRCLE2X2)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(15, 45)]:execute(creature, var)
end

spell:name("gnomevil skill reducer 2")
spell:words("###148")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()