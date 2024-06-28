local teleportTile = MoveEvent()

function teleportTile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	-- UIDs específicos do tile
	local specificUIDs = { 25031, 25032 }

	-- Posições específicas
	local specificPositions = {
		{ x = 32477, y = 31905, z = 7 },
		{ x = 32476, y = 31906, z = 7 },
	}

	-- Posição de teletransporte
	local teleportPosition = { x = 32478, y = 31908, z = 7 }

	-- Verifica se a posição, o UID e o itemID coincidem
	for _, pos in ipairs(specificPositions) do
		if position.x == pos.x and position.y == pos.y and position.z == pos.z and item:getId() == 599 and table.contains(specificUIDs, item.uid) then
			player:teleportTo(teleportPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			break
		end
	end

	return true
end

-- Registra o evento para os UIDs específicos
teleportTile:uid(25031, 25032)
teleportTile:register()
