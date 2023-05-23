local corpse = Action()

function corpse.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TheSecretLibrary.TheLament) == 5 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You have found a scribbled notes.")
		player:addItem(33292, 1)
		player:setStorageValue(Storage.TheSecretLibrary.TheLament, 6)
		return true
	end
	return false
end

corpse:uid(1095)
corpse:register()
