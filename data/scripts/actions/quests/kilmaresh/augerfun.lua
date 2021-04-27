local augerfun = Action()

function augerfun.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if player:getStorageValue(Storage.Kilmaresh.Eighth.Narsai) == 2 then
		if table.contains({36212}, target.itemid) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are gathering some catus milk.")
			player:addItem(36170, 1)
		end
	else
		player:sendTextMessage(MESSAGE_FAILURE, "Sorry, not possible.")
	end
	
    return true
end

augerfun:id(36169)
augerfun:register()