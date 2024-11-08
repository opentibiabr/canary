local tortoise = Action()

function tortoise.onUse(player, item, frompos, item2, topos)
	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Presente) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Tortoise.")
		player:addItem(31445, 1)
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Presente, 2)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The tortoise nest empty.")
	end

	return true
end

tortoise:uid(57528)
tortoise:register()
