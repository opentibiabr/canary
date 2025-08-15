local augerfun = Action()

function augerfun.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Narsai) == 2 then
		if table.contains({ 31377 }, target.itemid) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are gathering some catus milk.")
			player:addItem(31335, 1)
		end
	else
		player:sendTextMessage(MESSAGE_FAILURE, "Sorry, not possible.")
	end

	return true
end

augerfun:id(31334)
augerfun:register()
