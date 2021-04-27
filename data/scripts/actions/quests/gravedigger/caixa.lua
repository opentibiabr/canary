local gravediggerCaixa = Action()
function gravediggerCaixa.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission67) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission68) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission68, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found an incantation fragment.')
		player:addItem(21250, 1)
	end
	return true
end

gravediggerCaixa:uid(4663)
gravediggerCaixa:register()