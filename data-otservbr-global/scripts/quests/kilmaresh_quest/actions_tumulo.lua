local tumulo = Action()

function tumulo.onUse(player, item, frompos, item2, topos)
	if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Presente) == 1 then
		-- player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Treze.Presente, 2)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The grave is empty. Nothing than gaping void.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Empty.")
	end

	return true
end

tumulo:uid(57543)
tumulo:register()
