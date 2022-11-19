local condition = Condition(CONDITION_INVISIBLE)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)

local condition2 = Condition(CONDITION_OUTFIT)
condition2:setTicks(-1)
condition2:setOutfit({lookTypeEx = 1548})

local zavarashHide = CreatureEvent("ZavarashHide")
function zavarashHide.onThink(creature)
	local hp, cpos = (creature:getHealth()/creature:getMaxHealth())*100, creature:getPosition()

	if creature:getName():lower() == "zavarash" and (hp < 100) then
		creature:addCondition(condition)
		creature:addCondition(condition2)
		creature:setHiddenHealth(creature)
	end
	if creature:getCondition(CONDITION_POISON, CONDITIONID_COMBAT) or
	creature:getCondition(CONDITION_FIRE, CONDITIONID_COMBAT) or
	creature:getCondition(CONDITION_ENERGY, CONDITIONID_COMBAT) or
	creature:getCondition(CONDITION_BLEEDING, CONDITIONID_COMBAT) or
	creature:getCondition(CONDITION_DAZZLED, CONDITIONID_COMBAT) then
		creature:setOutfit({lookType=12,lookHead=0,lookAddons=0,lookLegs=57,lookBody=15,lookFeet=85}, -1)
		creature:removeCondition(CONDITION_INVISIBLE)
		creature:removeCondition(CONDITION_OUTFIT)
		creature:setHiddenHealth(false)
		return
	end
	return true
end
zavarashHide:register()
