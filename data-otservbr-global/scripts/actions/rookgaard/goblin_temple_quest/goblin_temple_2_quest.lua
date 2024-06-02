-- Reward = bag -> pan, 4 snowballs, vial of milk
local goblintemple2Quest = Action()

function goblintemple2Quest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local bagId = 2853
	local rewardIds = {
		{ 3466, 1 },
		{ 2992, 4 },
		{ 2874, 1 },
	}

	for _, reward in ipairs(rewardIds) do
		local rewardId, rewardCount = reward[1], reward[2]
		if not player:canGetReward(rewardId, "goblintemple2") then
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
		player:questKV("goblintemple2"):set("completed", true)
	end

	return true
end

goblintemple2Quest:uid(14050)
goblintemple2Quest:register()
