local minohellQuest3 = Action()

function minohellQuest3.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewardId = 3283
	if not player:canGetReward(rewardId, "minohell3") then
		return true
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a carlin sword.")
	player:addItem(rewardId, 1)
	player:questKV("minohell3"):set("completed", true)
	return true
end

minohellQuest3:uid(14053)
minohellQuest3:register()
