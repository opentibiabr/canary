local pickenchanted = Action()

function pickenchanted.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eighth.Yonan) == 2 then
		if table.contains({ 30438 }, target.itemid) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are quarrying some tagralt.")
			player:addItem(31333, 1)
		end
	else
		player:sendTextMessage(MESSAGE_FAILURE, "Sorry, not possible.")
	end

	return true
end

pickenchanted:id(31613)
pickenchanted:register()
