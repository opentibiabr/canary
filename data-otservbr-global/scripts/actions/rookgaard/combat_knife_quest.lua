local combatknifeQuest = Action()

function combatknifeQuest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rewardId = 3292
	if not player:canGetReward(rewardId, "combatknife") then
		return true
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a combat knife.")
	player:addItem(rewardId, 1)
	player:questKV("combatknife"):set("completed", true)
	return true
end

combatknifeQuest:uid(14048)
combatknifeQuest:register()
