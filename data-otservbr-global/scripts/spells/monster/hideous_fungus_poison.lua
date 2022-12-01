local combat = {}

for i = 25, 30 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_POISONDAMAGE)
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITBYPOISON)

	local condition = Condition(CONDITION_POISON)
	condition:setParameter(CONDITION_PARAM_DELAYED, 1)
	condition:addDamage(10, 4000, -i)
	condition:addDamage(10, 4000, -i + 1)
	condition:addDamage(10, 4000, -i + 2)
	condition:addDamage(10, 4000, -i + 3)
	condition:addDamage(10, 4000, -i + 4)


	local area = createCombatArea(AREA_SQUARE1X1)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(25, 30)]:execute(creature, var)
end

spell:name("hideous fungus poison")
spell:words("###71")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()