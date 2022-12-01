local dormitoryTeleport = MoveEvent()

function dormitoryTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 4534
	and player:getStorageValue(Storage.GravediggerOfDrefia.Mission55) == 1
	and player:getStorageValue(Storage.GravediggerOfDrefia.Mission56) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission56,1)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission57,1)
		player:teleportTo(Position(33015, 32440, 10))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			"You should hurry, try not to dwell here any longer than a few minutes.")
	    Game.createMonster("necromancer servant", {x = 33008, y = 32437, z = 11})
	else
		player:teleportTo(Position(33018, 32437, 10))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The teleport is accessible only once.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

dormitoryTeleport:type("stepin")
dormitoryTeleport:aid(4534, 4535)
dormitoryTeleport:register()
