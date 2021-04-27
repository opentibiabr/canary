local glasshoneyfun = Action()

function glasshoneyfun.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if player:getStorageValue(Storage.Kilmaresh.Eighth.Narsai) == 2 then
		if table.contains({36211}, target.itemid) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are gently squishing some of the honey palm blossoms and golden honey is depping into the jug.")
			player:removeItem(36166, 1)
			player:addItem(36167, 1)
		end
	else
		player:sendTextMessage(MESSAGE_FAILURE, "Sorry, not possible.")
	end

    return true
end

glasshoneyfun:id(36166)
glasshoneyfun:register()