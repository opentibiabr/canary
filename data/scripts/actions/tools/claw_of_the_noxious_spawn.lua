local cursed = Condition(CONDITION_CURSED)
cursed:setParameter(CONDITION_PARAM_DELAYED, true)
cursed:setParameter(CONDITION_PARAM_MINVALUE, -800)
cursed:setParameter(CONDITION_PARAM_MAXVALUE, -1200)
cursed:setParameter(CONDITION_PARAM_STARTVALUE, -1)
cursed:setParameter(CONDITION_PARAM_TICKINTERVAL, 4000)
cursed:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local clawOfTheNoxiousSpawn = Action()

function clawOfTheNoxiousSpawn.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item == player:getSlotItem(CONST_SLOT_RING) then
		if math.random(100) <= 5 then
			player:addCondition(cursed)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are cursed by The Noxious Spawn!")
			item:transform(9395)
			item:decay()
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
			player:addAchievement("Cursed!")
		else
			player:removeCondition(CONDITION_POISON)
			item:transform(9394)
			item:decay()
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
		end
		return true
	end
	return false
end

clawOfTheNoxiousSpawn:id(9392)
clawOfTheNoxiousSpawn:register()
