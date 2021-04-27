local config = {
	amphoraPositions = {
		Position(32792, 32527, 10),
		Position(32823, 32525, 10),
		Position(32876, 32584, 10),
		Position(32744, 32586, 10)
	},
	brokenAmphoraId = 2252 --4997
}

local mission9TheDeepestCatacombTeleport = MoveEvent()

function mission9TheDeepestCatacombTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.uid == 12129 then
		if player:getStorageValue(Storage.TheApeCity.Questline) >= 17 then
			player:teleportTo(Position(32749, 32536, 10))
			position:sendMagicEffect(CONST_ME_TELEPORT)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:teleportTo(fromPosition, true)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have access to this area.")
		end
	elseif item.uid == 12130 then
		for i = 1, #config.amphoraPositions do
			local amphoraItem = Tile(config.amphoraPositions[i]):getItemById(config.brokenAmphoraId)
			if not amphoraItem then
				player:teleportTo({x = 32852, y = 32544, z = 10})
				position:sendMagicEffect(CONST_ME_TELEPORT)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
					"There are 4 large amphoras that must be broken in order to open the teleporter.")
				return true
			end
		end
		player:teleportTo({x = 32885, y = 32632, z = 11})
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
end

mission9TheDeepestCatacombTeleport:type("stepin")
mission9TheDeepestCatacombTeleport:uid(9257, 9258)
mission9TheDeepestCatacombTeleport:register()
