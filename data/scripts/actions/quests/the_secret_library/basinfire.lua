local basinFire = Action()

function basinFire.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TheSecretLibrary.Mota) == 8 then
		if target.itemid == 1485 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a reward.")
			player:setStorageValue(Storage.TheSecretLibrary.Mota, 9)
			player:removeItem(32408, 1)
			player:addItem(32623, 1)
			player:setStorageValue(Storage.TheSecretLibrary.BasinDoor, 1)
		end
		return true
	end
	return false
end

basinFire:id(1089)
basinFire:register()
