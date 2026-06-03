local setting = {
	[1] = { position = Position(32400, 32480, 4), entering = true, newPosition = Position(32397, 32480, 4) },
	[2] = { position = Position(32400, 32481, 4), entering = true, newPosition = Position(32397, 32481, 4) },
	[3] = { position = Position(32398, 32480, 4), entering = false, newPosition = Position(32401, 32480, 4) },
	[4] = { position = Position(32398, 32481, 4), entering = false, newPosition = Position(32401, 32481, 4) },
}

local bounacCheckpoint = MoveEvent()

function bounacCheckpoint.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport
	for _, data in pairs(setting) do
		if data.position == position then
			teleport = data
			break
		end
	end

	if not teleport then
		return true
	end

	if teleport.entering then
		if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.AccessEasternSide) >= 1 then
			player:teleportTo(teleport.newPosition)
			fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
			teleport.newPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end
	else
		player:teleportTo(teleport.newPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		teleport.newPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end

	return true
end

bounacCheckpoint:type("stepin")
for _, data in pairs(setting) do
	bounacCheckpoint:position(data.position)
end
bounacCheckpoint:register()
