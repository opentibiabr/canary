local doubletQuest = Action()

function doubletQuest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewardId = 3379
	if not player:canGetReward(rewardId, "doublet") then
		return true
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a doublet.")
	player:addItem(rewardId, 1)
	player:questKV("doublet"):set("completed", true)
	return true
end

doubletQuest:uid(25029)
doubletQuest:register()
