local boxRamp = Action()

function boxRamp.onUse(player, item, frompos, item2, topos)
	if player:getStorageValue(Storage.DeeplingsWorldChange.Crystal) == 12 then
		player:removeItem(15568, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Clonk.")
		player:setStorageValue(Storage.DeeplingsWorldChange.Crystal, 13)
		return true
	end
	return false
end

boxRamp:uid(1106)
boxRamp:register()
