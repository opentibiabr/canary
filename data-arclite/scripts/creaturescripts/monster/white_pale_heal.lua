local condition = Condition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
condition:setParameter(CONDITION_PARAM_SUBID, 88888)
condition:setParameter(CONDITION_PARAM_TICKS, 15 * 60 * 1000)
condition:setParameter(CONDITION_PARAM_HEALTHGAIN, 0.01)
condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 15 * 60 * 1000)

local whitePaleHeal = CreatureEvent("WhitePaleHeal")
function whitePaleHeal.onPrepareDeath(creature, lastHitKiller, mostDamageKiller)
	if creature:getName():lower() == "white pale" then
		if not creature:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT, 88888) then
			creature:addCondition(condition)
			creature:addHealth(400)
			return
		end
	else
		return
	end
	return true
end
whitePaleHeal:register()
