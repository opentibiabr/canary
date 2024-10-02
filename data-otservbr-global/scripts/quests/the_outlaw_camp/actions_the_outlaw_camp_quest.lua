-- Bag -> bright sword and red gem
local outlawQuest = Action()

function outlawQuest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local bagId = 2853
	local rewardIds = {
		{ 3295, 1 }, -- bright sword
		{ 3039, 1 }, -- red gem
	}

	for _, reward in ipairs(rewardIds) do
		local rewardId, rewardCount = reward[1], reward[2]
		if not player:canGetReward(rewardId, "outlaw") then
			return true
		end
	end

	local bag = player:addItem(bagId, 1)
	if bag then
		for _, reward in ipairs(rewardIds) do
			local rewardId, rewardCount = reward[1], reward[2]
			bag:addItem(rewardId, rewardCount)
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a bag.")
		player:questKV("outlaw"):set("completed", true)
		player:setStorageValue(Storage.Quest.U6_4.OutlawCampQuest, 1)
	end

	return true
end

outlawQuest:uid(14091)
outlawQuest:register()
