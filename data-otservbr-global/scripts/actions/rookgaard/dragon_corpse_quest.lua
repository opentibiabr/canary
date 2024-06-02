-- Reward = bag -> Copper Shield and Legion Helmet
local dragoncorpseQuest = Action()

function dragoncorpseQuest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local backpackId = 2853
	local rewardIds = {3374, 3430}

	for _, rewardId in ipairs(rewardIds) do
		if not player:canGetReward(rewardId, "dragoncorpse") then
			return true
		end
	end
	local backpack = player:addItem(backpackId, 1)
	if backpack then
		for _, rewardId in ipairs(rewardIds) do
		  backpack:addItem(rewardId, 1)
    end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a bag.")
		player:questKV("dragoncorpse"):set("completed", true)
	end
	return true
end

dragoncorpseQuest:uid(20005)
dragoncorpseQuest:register()
