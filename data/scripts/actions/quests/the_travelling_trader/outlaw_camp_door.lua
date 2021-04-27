local outlawCamp = Action()
function outlawCamp.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TravellingTrader.Mission02) == 3 then
		if item.itemid == 1223 then
			player:teleportTo(toPosition, true)
			item:transform(item.itemid + 1)
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
	end
	return true
end

outlawCamp:aid(1108)
outlawCamp:register()