local custodian_door = Action()

function custodian_door.onUse(player, item, isHotkey)
	if player:getStorageValue(Storage.Quest.U12_20.GraveDanger.GaffirKilled) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The power of Gaffir won't let you pass this door!")
		return true
	end

	local pos = player:getPosition()

	if pos.x == 33365 then
		player:teleportTo(Position(pos.x + 2, pos.y, pos.z))
	elseif pos.x == 33367 then
		player:teleportTo(Position(pos.x - 2, pos.y, pos.z))
	end

	return true
end

custodian_door:aid(36569)
custodian_door:register()
