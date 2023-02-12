local gravediggerPalanca = Action()
function gravediggerPalanca.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission39) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission40) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission40, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<sizzle> <fizz>')
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	end
	return true
end

gravediggerPalanca:aid(4650)
gravediggerPalanca:register()