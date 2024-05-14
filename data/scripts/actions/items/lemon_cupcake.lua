local distanceCondition = Condition(CONDITION_ATTRIBUTES)
distanceCondition:setParameter(CONDITION_PARAM_BUFF_SPELL, 1)
distanceCondition:setParameter(CONDITION_PARAM_TICKS, 60 * 60 * 1000)
distanceCondition:setParameter(CONDITION_PARAM_SKILL_DISTANCE, 10)
distanceCondition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local lemonCupcake = Action()

function lemonCupcake.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:hasExhaustion("lemon-cupcake-cooldown") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait before using it again.")
		return true
	end

	player:addCondition(distanceCondition)
	player:sendTextMessage(MESSAGE_FAILURE, "You feel more focused.")
	player:say("Mmmm.", TALKTYPE_MONSTER_SAY)
	player:setExhaustion("lemon-cupcake-cooldown", 10 * 60)
	item:remove(1)
	return true
end

lemonCupcake:id(28486)
lemonCupcake:register()
