local honeyFlowerQuest = Action()

function honeyFlowerQuest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewardId = 2984
	if player:questKV("honeyFlower"):get("completed") then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Nothing.")
		return false
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a rapier.")
	player:addItem(rewardId, 1)
	player:questKV("honeyFlower"):set("completed", true)
	return true
end

honeyFlowerQuest:position(Position(32005, 32139, 3))
honeyFlowerQuest:register()
