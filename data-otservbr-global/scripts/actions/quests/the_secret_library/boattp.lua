local boatTp = Action()

function boatTp.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.TheSecretLibrary.HighDry) == 4 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"The raft was not that solid in the end, its parts are floating in the ocean now. But at least you reached dry land.")
		player:removeItem(32407, 1)
		player:teleportTo(Position(32187, 32474, 7))
		player:setStorageValue(Storage.TheSecretLibrary.HighDry, 5)
		player:setStorageValue(Storage.TheSecretLibrary.PinkTel, 3)
		player:setStorageValue(Storage.TheSecretLibrary.Mota, 13)
		return true
	end
	return false
end

boatTp:uid(1104)
boatTp:register()
