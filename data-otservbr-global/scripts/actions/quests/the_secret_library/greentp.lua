local greenTp = Action()

function greenTp.onUse(player, item, frompos, item2, topos)
	if player:getStorageValue(Storage.TheSecretLibrary.GreenTel) == -1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You see silver chimes dangling on the dragon statue in this room.")
		player:addItem(33277, 1)
		player:setStorageValue(Storage.TheSecretLibrary.GreenTel, 1)
		return true
	end
	return false
end

greenTp:uid(1096)
greenTp:register()
