local gravediggerStatue = Action()

function gravediggerStatue.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local expectedPosition = Position(32998, 32416, 11)

	if toPosition ~= expectedPosition then
		return false
	end

	if player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission24) == 1 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission25) < 1 then
		player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission25, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "<BOOOOOOOONGGGGGG> A slow throbbing, like blood pulsing, runs through the floor.")
		player:getPosition():sendMagicEffect(CONST_ME_SOUND_GREEN)
	end

	return true
end

gravediggerStatue:aid(4636)
gravediggerStatue:register()
