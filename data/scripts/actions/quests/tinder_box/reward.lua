local tinderReward = Action()
function tinderReward.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if player:getStorageValue(12450) >= os.time() then
		return player:sendCancelMessage("The pile of bones is empty.")
	end
	player:addItem(22728, 1)
	player:setStorageValue(12450, os.time() + 20 * 3600)
	return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a tinder box.")
end

tinderReward:uid(3263)
tinderReward:register()