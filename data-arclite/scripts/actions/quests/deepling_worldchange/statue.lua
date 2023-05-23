local statuegod = Action()
function statuegod.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.DeeplingsWorldChange.Crystal) == 6 then
		if table.contains({13827}, target.itemid) then
			player:removeItem(14018, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You carefully insert the blood red gem but it would take a hundred hearts to replace the original.")
			player:setStorageValue(Storage.DeeplingsWorldChange.Crystal, 6)
		end
	end
    return true
end
statuegod:id(14018)
statuegod:register()
