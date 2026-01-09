local glasshoneyfun = Action()

function glasshoneyfun.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 2 then
		if table.contains({ 31376 }, target.itemid) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are gently squishing some of the honey palm blossoms and golden honey is depping into the jug.")
			player:removeItem(31331, 1)
			player:addItem(31332, 1)
		end
	else
		player:sendTextMessage(MESSAGE_FAILURE, "Sorry, not possible.")
	end

	return true
end

glasshoneyfun:id(31331)
glasshoneyfun:register()
