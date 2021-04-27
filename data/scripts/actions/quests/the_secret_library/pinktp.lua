local blacktp = Action()

function blacktp.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TheSecretLibrary.PinkTel) == -1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You discovered an old writing desk that contains an ancient map.")
		player:addItem(27615, 1)
		player:setStorageValue(Storage.TheSecretLibrary.PinkTel, 1)
		return true
	end
	return false
end

blacktp:uid(1100)
blacktp:register()
