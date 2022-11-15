local greenTp = Action()

function greenTp.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TheSecretLibrary.BlueTel) == -1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You have found a piece of ebony.")
		player:addItem(33274, 1)
		player:setStorageValue(Storage.TheSecretLibrary.BlueTel, 1)
		return true
	end
	return false
end

greenTp:uid(1097)
greenTp:register()
