local teleports = {
	{teleportPosition = {x = 33013, y = 31880, z = 9}, teleportDestination = Position(32996, 31922, 10), storage = Storage.BigfootBurden.Warzone1Access, value = 1},
	{teleportPosition = {x = 33019, y = 31886, z = 9}, teleportDestination = Position(33011, 31943, 11), storage = Storage.BigfootBurden.Warzone2Access, value = 2},
	{teleportPosition = {x = 33022, y = 31902, z = 9}, teleportDestination = Position(32989, 31909, 12), storage = Storage.BigfootBurden.Warzone3Access, value = 3},
}

local warzoneTeleport = MoveEvent()
function warzoneTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for a = 1, #teleports do
		if player:getPosition() == Position(teleports[a].teleportPosition) then
			if player:getStorageValue(Storage.BigfootBurden.Rank) < 1440 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not permitted to enter.")
				player:teleportTo(fromPosition)
				position:sendMagicEffect(CONST_ME_TELEPORT)
				return true
			end

			if player:getStorageValue(Storage.BigfootBurden.WarzoneStatus) < 1 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You finally have enough renown among the gnomes, ask Gnomission for a mission to fight on the warzones.")
				player:teleportTo(fromPosition)
				position:sendMagicEffect(CONST_ME_TELEPORT)
				return true
			end

			if player:getStorageValue(teleports[a].storage) < 1 and not player:removeItem(16242, 1) then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need a mission crystal or a job done with Gnomission to enter.")
				player:teleportTo(fromPosition)
				position:sendMagicEffect(CONST_ME_TELEPORT)
				return true
			end

			player:teleportTo(teleports[a].teleportDestination)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	return true
end

for b = 1, #teleports do
	warzoneTeleport:position(teleports[b].teleportPosition)
end
warzoneTeleport:register()
