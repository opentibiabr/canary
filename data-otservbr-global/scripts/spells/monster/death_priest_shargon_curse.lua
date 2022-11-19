local combat = {}

for i = 1.12, 1.12 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
	combat[i]:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SUDDENDEATH)

	local condition = Condition(CONDITION_CURSED)
	condition:setParameter(CONDITION_PARAM_DELAYED, 1)

	local damage = i
	condition:addDamage(1, 4000, -damage)
	for j = 1, 32 do
		damage = damage * 1.2
		condition:addDamage(1, 4000, -damage)
	end

	combat[i]:addCondition(condition)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(1.12, 1.12)]:execute(creature, var)
end

spell:name("death priest shargon curse")
spell:words("###376")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()