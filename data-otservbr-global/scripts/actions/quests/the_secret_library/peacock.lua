local peacock = Action()

function peacock.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TheSecretLibrary.Peacock) == -1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You have found the Peacock Ballad.")
		player:addItem(32410, 1)
		player:setStorageValue(Storage.TheSecretLibrary.Peacock, 1)
		return true
	end
	return false
end

peacock:uid(1099)
peacock:register()
