local cagekey = Action()

function cagekey.onUse(player, item, frompos, item2, topos)
	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourteen.Remains) == 2 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a wooden cage key.")
		player:addItem(31379, 1) -- Wooden Cage Key
		player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourteen.Remains, 3)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Empty.")
	end

	return true
end

cagekey:uid(57530)
cagekey:register()
