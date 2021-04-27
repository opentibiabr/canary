local combat = {}

for i = 1, 1 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
	combat[i]:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SUDDENDEATH)
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLCLOUDS)

	local condition = Condition(CONDITION_CURSED)
	condition:setParameter(CONDITION_PARAM_DELAYED, 1)

	local damage = i
	condition:addDamage(1, 4000, -damage)
	for j = 1, 19 do
		damage = damage * 1.25
		condition:addDamage(1, 4000, -damage)
	end

	combat[i]:addCondition(condition)
end

function onCastSpell(creature, var)
	return combat[math.random(1, 1)]:execute(creature, var)
end
