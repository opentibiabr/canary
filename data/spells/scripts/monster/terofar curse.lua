local combat = {}
local condition2 = Condition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
condition2:setParameter(CONDITION_PARAM_SUBID, 88888)
condition2:setParameter(CONDITION_PARAM_TICKS, 15 * 60 * 1000)
condition2:setParameter(CONDITION_PARAM_HEALTHGAIN, 0.01)
condition2:setParameter(CONDITION_PARAM_HEALTHTICKS, 15 * 60 * 1000)

for i = 0.935, 0.935 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLCLOUDS)
	combat[i]:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_DEATH)

	local condition = Condition(CONDITION_CURSED)
	condition:setParameter(CONDITION_PARAM_DELAYED, 1)

	local damage = i
	condition:addDamage(1, 4000, -damage)
	for j = 1, 38 do
		damage = damage * 1.2
		condition:addDamage(1, 4000, -damage)
	end

	combat[i]:addCondition(condition)
end

function onCastSpell(creature, var)
	if not creature:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT, 88888) then
		creature:addCondition(condition2)
		creature:say("Terofar cast a greater death curse on you!", TALKTYPE_ORANGE_1)
	else
		return false
	end
return combat[math.random(0.935, 0.935)]:execute(creature, var)
end
