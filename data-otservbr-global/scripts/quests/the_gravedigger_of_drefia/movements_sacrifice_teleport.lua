local sacrificeTeleport = MoveEvent()

function sacrificeTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 4541 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission74) == 1 then
		player:teleportTo(Position(33017, 32419, 11))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	if item.actionid == 4542 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission75) == 1 then
		player:teleportTo(Position(33018, 32425, 11))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
end

sacrificeTeleport:type("stepin")
sacrificeTeleport:aid(4541, 4542)
sacrificeTeleport:register()
