local childrenZalamon = Action()
function childrenZalamon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TheNewFrontier.Mission08) >= 2 and player:getStorageValue(Storage.WrathoftheEmperor.Mission11) < 2 then
		if item.itemid == 10791 then
			player:teleportTo(toPosition, true)
			item:transform(item.itemid + 1)
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
	end
	return true
end

childrenZalamon:uid(3170)
childrenZalamon:register()