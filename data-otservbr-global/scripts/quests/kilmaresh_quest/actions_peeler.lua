local peeler = Action()

function peeler.onUse(player, item, frompos, item2, topos)
	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Set.Ritual) == 2 then
		player:addItem(31328, 1)
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Set.Ritual, 3)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a bark peeler.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Empty.")
	end

	return true
end

peeler:uid(57518)
peeler:register()
