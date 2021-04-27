local chest = Action()

function chest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if (player:getStorageValue(405492) == 1) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
		return true
	end

	player:addItem(13829, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found a wooden sword.")
	player:setStorageValue(405492, 1)
	return true
end

chest:aid(30492)
chest:register()
