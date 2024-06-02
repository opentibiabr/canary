-- Reward = Chain Armor
local bearChest3 = Action()

function bearChest3.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewardId = 3358
	if not player:canGetReward(rewardId, "bearChest3") then
		return true
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a chain armor.")
	player:addItem(rewardId, 1)
	player:questKV("bearChest3"):set("completed", true)
	return true
end

bearChest3:uid(14046)
bearChest3:register()
