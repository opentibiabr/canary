local gravediggerCape = Action()
function gravediggerCape.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission59) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission60) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission60, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You now look like a Necromancer.')
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:removeItem(21464, 1)
	end
	return true
end

gravediggerCape:id(21464)
gravediggerCape:register()