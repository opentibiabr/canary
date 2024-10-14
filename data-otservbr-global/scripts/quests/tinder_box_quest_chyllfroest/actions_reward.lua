local tinderReward = Action()

function tinderReward.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local currentDate = os.date("*t")
	local currentTime = os.time()

	if currentDate.month < 4 or currentDate.month > 5 or (currentDate.month == 5 and currentDate.day > 1) then
		return player:sendCancelMessage("This can only be used between 1st of April and 1st of May.")
	end

	if player:getStorageValue(Storage.Quest.U10_37.TinderBoxQuestChyllfroest.Reward) >= currentTime then
		return player:sendCancelMessage("The pile of bones is empty.")
	end

	player:addItem(20357, 1)
	player:setStorageValue(Storage.Quest.U10_37.TinderBoxQuestChyllfroest.Reward, currentTime + 72000)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a tinder box.")

	return true
end

tinderReward:uid(3263)
tinderReward:register()
