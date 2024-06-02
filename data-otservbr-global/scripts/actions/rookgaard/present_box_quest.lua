-- Reward = backpack -> Jug, Present Box, Cup and Plate
local presentBox = Action()

function presentBox.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local backpackId = 2854
	local rewardIds = {2882, 2856, 2881, 2905}

	for _, rewardId in ipairs(rewardIds) do
		if not player:canGetReward(rewardId, "presentBox") then
			return true
		end
	end
	local backpack = player:addItem(backpackId, 1)
	if backpack then
		for _, rewardId in ipairs(rewardIds) do
		  backpack:addItem(rewardId, 1)
    end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a backpack.")
		player:questKV("presentBox"):set("completed", true)
	end
	return true
end

presentBox:uid(14043)
presentBox:register()
