-- Reward = bag -> 10 arrows, 4 poison arrow
local minohellQuest2 = Action()

function minohellQuest2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local bagId = 2853
	local rewardIds = {
		{ 3447, 10 },
		{ 3448, 4 },
	}

	for _, reward in ipairs(rewardIds) do
		local rewardId, rewardCount = reward[1], reward[2]
		if not player:canGetReward(rewardId, "minohell2") then
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
		player:questKV("minohell2"):set("completed", true)
	end

	return true
end

minohellQuest2:uid(14052)
minohellQuest2:register()
