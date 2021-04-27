local bigfootPiece = Action()
function bigfootPiece.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.BigfootBurden.Mouthpiece) ~= os.time() then
		player:addItem(22391, 1)
		player:setStorageValue(Storage.BigfootBurden.Mouthpiece, os.time() + 20 * 60 * 60)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
	end
	return true
end

bigfootPiece:uid(9307)
bigfootPiece:register()