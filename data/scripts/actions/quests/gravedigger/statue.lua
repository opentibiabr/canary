local gravediggerStatue = Action()
function gravediggerStatue.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 21429 then
		return false
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission20) >= 1
	and player:getStorageValue(Storage.GravediggerOfDrefia.Mission25) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission25,1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<BOOOOOOOONGGGGGG> A slow throbbing, like blood pulsing, runs through the floor.')
		player:getPosition():sendMagicEffect(CONST_ME_SOUND_GREEN)
	end
	return true
end

gravediggerStatue:aid(4636)
gravediggerStatue:register()