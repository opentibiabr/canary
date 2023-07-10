local skeleton = Action()

function skeleton.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TheSecretLibrary.TheLament) == 2 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You have found an old letter.")
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You have discovered a skeleton. It seems to hold an old letter and its skull is missing.")
		player:addItem(33294, 1)
		player:setStorageValue(Storage.TheSecretLibrary.TheLament, 3)
		return true
	end
	return false
end

skeleton:uid(1092)
skeleton:register()
