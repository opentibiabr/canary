local peelerfun = Action()

function peelerfun.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Tefrit) == 2 then
		if table.contains({ 31376 }, target.itemid) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are peeling a piece of tark off the again tree.")
			player:addItem(31329, 1)
		end
	else
		player:sendTextMessage(MESSAGE_FAILURE, "Sorry, not possible.")
	end

	return true
end

peelerfun:id(31328)
peelerfun:register()
