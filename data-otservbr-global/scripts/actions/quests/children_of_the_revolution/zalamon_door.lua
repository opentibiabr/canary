local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier

local childrenZalamon = Action()

function childrenZalamon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(TheNewFrontier.Mission08) >= 2 and player:getStorageValue(Storage.WrathoftheEmperor.Mission11) < 2 then
		if item.itemid == 9874 then
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