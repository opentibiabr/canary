-- Reward = Brass Helmet
local bearChest2 = Action()

function bearChest2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewardId = 3354
	if not player:canGetReward(rewardId, "bearChest2") then
		return true
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a brass helmet.")
	player:addItem(rewardId, 1)
	player:questKV("bearChest2"):set("completed", true)
	return true
end

bearChest2:uid(14045)
bearChest2:register()
