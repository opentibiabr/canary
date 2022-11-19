local strandHair = Action()

function strandHair.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TheSecretLibrary.TheLament) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You have found a strand of hair.")
		player:addItem(33273, 1)
		player:setStorageValue(Storage.TheSecretLibrary.TheLament, 2)
		return true
	end
	return false
end

strandHair:uid(1091)
strandHair:register()
