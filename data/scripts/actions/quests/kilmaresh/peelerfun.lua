local peelerfun = Action()

function peelerfun.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if player:getStorageValue(Storage.Kilmaresh.Eighth.Tefrit) == 2 then
		if table.contains({36211}, target.itemid) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are peeling a piece of tark off the again tree.")
			player:addItem(36164, 1)
		end
	else
		player:sendTextMessage(MESSAGE_FAILURE, "Sorry, not possible.")
	end
	
    return true
end

peelerfun:id(36163)
peelerfun:register()