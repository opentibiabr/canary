local riverTeleport = MoveEvent()

function riverTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if (player:getStorageValue(player:getStorageValue(Storage.CultsOfTibia.Life.BossTimer)) > os.time()) then
		player:sendCancelMessage('You need to wait for 20 hours to face this boss again.')
		player:teleportTo(fromPosition)
		return false
	end

	if player:getStorageValue(Storage.CultsOfTibia.Life.Mission) < 7 then
		player:teleportTo(Position(33474, 32281, 10))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	if 	player:getStorageValue(Storage.CultsOfTibia.Life.Mission) >= 7 then
		player:teleportTo(Position(33479, 32235, 10))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

riverTeleport:type("stepin")
riverTeleport:aid(5517)
riverTeleport:register()
