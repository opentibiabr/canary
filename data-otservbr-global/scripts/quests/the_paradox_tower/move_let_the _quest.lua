local teleportTileBack = MoveEvent()

function teleportTileBack.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	-- UIDs específicos do tile
	local specificUIDs = { 25034, 25035, 25036, 25037 }

	-- Posições específicas
	local specificPositions = {
		{ x = 32486, y = 31927, z = 7 },
		{ x = 32487, y = 31927, z = 7 },
		{ x = 32486, y = 31928, z = 7 },
		{ x = 32487, y = 31928, z = 7 },
	}

	-- Posição de teletransporte
	local teleportPosition = { x = 32566, y = 31959, z = 1 }

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
teleportTileBack:uid(25034, 25035, 25036, 25037)
teleportTileBack:register()
