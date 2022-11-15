local leverDoor = Action()

function leverDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TheSecretLibrary.Mota) == 3 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a reward.")
		player:setStorageValue(Storage.TheSecretLibrary.Mota, 4)
		player:setStorageValue(Storage.TheSecretLibrary.MotaDoor, 1)
		return true
	end
	return false
end

leverDoor:uid(1084)
leverDoor:register()
