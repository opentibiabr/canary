local lotusKey = Action()

function lotusKey.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TheSecretLibrary.TheLament) == 3 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You have found a lotus key.")
		player:addItem(33264, 1)
		player:setStorageValue(Storage.TheSecretLibrary.TheLament, 4)
		return true
	end
	return false
end

lotusKey:uid(1093)
lotusKey:register()