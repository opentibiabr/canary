local condition = Condition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
condition:setParameter(CONDITION_PARAM_SUBID, 88888)
condition:setParameter(CONDITION_PARAM_TICKS, 6 * 1000)
condition:setParameter(CONDITION_PARAM_HEALTHGAIN, 0.01)
condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 6 * 1000)

function onCastSpell(creature, var)
	if creature:getHealth() < creature:getMaxHealth() * 0.07 and not creature:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT, 88888) then
		creature:say("Lisa takes a final breath before she's healing up!", TALKTYPE_ORANGE_1)
		creature:addCondition(condition)
		addEvent(function(cid)
			creature:addHealth(math.random(18000, 23000))
			creature:say("Lisa healed up!", TALKTYPE_ORANGE_1)
			creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			return true
		end, 6 * 1000, creature:getId())
	end
	return true
end
