local backTp = Action()

function backTp.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TheSecretLibrary.BlackTel) == -1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You have found a skull.")
		player:addItem(33272, 1)
		player:setStorageValue(Storage.TheSecretLibrary.BlackTel, 1)
		return true
	end
	return false
end

backTp:uid(1098)
backTp:register()
