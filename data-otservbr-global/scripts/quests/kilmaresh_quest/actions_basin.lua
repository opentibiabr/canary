local basin = Action()

function basin.onUse(player, item, frompos, item2, topos)
	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Tem.Bleeds) == 1 then
		player:addItem(31431, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You find a golden symbol at the bottom of the blood-filled basin.")
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Eleven.Basin, 1)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Sorry")
	end
	return true
end

basin:uid(57527)
basin:register()
