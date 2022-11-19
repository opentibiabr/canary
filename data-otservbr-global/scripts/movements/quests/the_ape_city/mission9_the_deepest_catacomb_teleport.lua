local mission9TheDeepestCatacombTeleport = MoveEvent()

function mission9TheDeepestCatacombTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	if item.uid == 9257 and player:getStorageValue(Storage.TheApeCity.Questline) >= 17 then
		player:teleportTo(Position(32749, 32536, 10))
		position:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	elseif item.uid == 9258 then
		if Tile(Position(32792, 32527, 10)):getItemById(4996) and Tile(Position(32823, 32525, 10)):getItemById(4996) and Tile(Position(32876, 32584, 10)):getItemById(4996) and Tile(Position(32744, 32586, 10)):getItemById(4996) then
			player:teleportTo(Position(32885, 32632, 11))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		else
			player:teleportTo(fromPosition)
			position:sendMagicEffect(CONST_ME_TELEPORT)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"There are 4 large amphoras that must be broken in order to open the teleporter.")
			return true
		end
	else
		player:teleportTo(fromPosition, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have access to this area.")
	end
end

mission9TheDeepestCatacombTeleport:type("stepin")
mission9TheDeepestCatacombTeleport:uid(9257, 9258)
mission9TheDeepestCatacombTeleport:register()
