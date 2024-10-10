local teleportDestinations = {
	[4541] = { position = Position(33017, 32419, 11), storageKey = Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission74 },
	[4542] = { position = Position(33018, 32425, 11), storageKey = Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission75 },
}

local sacrificeTeleport = MoveEvent()

function sacrificeTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local destination = teleportDestinations[item.actionid]
	if destination and player:getStorageValue(destination.storageKey) == 1 then
		player:teleportTo(destination.position)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true
end

sacrificeTeleport:type("stepin")

for actionId in pairs(teleportDestinations) do
	sacrificeTeleport:aid(actionId)
end

sacrificeTeleport:register()
