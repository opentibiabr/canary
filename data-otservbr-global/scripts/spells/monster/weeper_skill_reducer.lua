local combat = {}

for i = 15, 55 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 7000)
	condition:setParameter(CONDITION_PARAM_SKILL_SHIELDPERCENT, i)

	local area = createCombatArea(AREA_CIRCLE1X1)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(15, 55)]:execute(creature, var)
end

spell:name("weeper skill reducer")
spell:words("###255")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()