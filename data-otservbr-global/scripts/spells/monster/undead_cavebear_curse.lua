local combat = {}

for i = 2, 2 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLCLOUDS)

	local condition = Condition(CONDITION_CURSED)
	condition:setParameter(CONDITION_PARAM_DELAYED, 1)

	local damage = i
	condition:addDamage(1, 4000, -damage)
	for j = 1, 18 do
		damage = damage * 1.2
		condition:addDamage(1, 4000, -damage)
	end

	local area = createCombatArea(AREA_SQUARE1X1)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(2, 2)]:execute(creature, var)
end

spell:name("undead cavebear curse")
spell:words("###61")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()