local minohellQuest1 = Action()

function minohellQuest1.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewardId = 3483
	if not player:canGetReward(rewardId, "minohell1") then
		return true
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a fishing rod.")
	player:addItem(rewardId, 1)
	player:questKV("minohell1"):set("completed", true)
	return true
end

minohellQuest1:uid(14051)
minohellQuest1:register()
