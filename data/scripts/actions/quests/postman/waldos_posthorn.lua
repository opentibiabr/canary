local postmanWaldos = Action()
function postmanWaldos.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Postman.Mission08) == 1 then
		player:setStorageValue(Storage.Postman.Mission08, 2)
		player:addItem(2332, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found Waldo's posthorn.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The dead human is empty.')
	end
	return true
end

postmanWaldos:uid(3118)
postmanWaldos:register()