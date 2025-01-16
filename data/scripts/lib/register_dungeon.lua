DungeonConfig = {
	minionPositions = {
		[1] = { playerPos = Position(1133, 1150, 12), bossPos = Position(1133, 1146, 12), playerId = 0 },
		[2] = { playerPos = Position(1148, 1150, 12), bossPos = Position(1148, 1146, 12), playerId = 0 },
		[3] = { playerPos = Position(1133, 1167, 12), bossPos = Position(1133, 1163, 12), playerId = 0 },
		[4] = { playerPos = Position(1148, 1167, 12), bossPos = Position(1148, 1163, 12), playerId = 0 },
	},
	portalId = 1949,
	hurakPos = Position(1121, 1132, 12),
	hurakIsDead = false,
	hurakExit = Position(32369, 32241, 7),
}

function resetPlayersInHurakWifes()
	DungeonConfig.hurakIsDead = false
	for k, value in ipairs(DungeonConfig.minionPositions) do
		value.playerId = 0
	end
	clearBossRoom(nil, Position(1141, 1155, 12), false, 32, 32, DungeonConfig.hurakExit) -- 4 salas
end

function updateDungeonSlot(playerId, entered)
	for k, value in ipairs(DungeonConfig.minionPositions) do
		if value.playerId == 0 and entered then
			value.playerId = playerId
			return { value.playerPos, value.bossPos }
		elseif value.playerId == playerId and not entered then
			value.playerId = 0
			local hurakPos = DungeonConfig.hurakPos
			removePortalDungeon(hurakPos)
			return hurakPos
		end
	end
end

function removePortalDungeon(position)
	local portal = Tile(position):getItemById(DungeonConfig.portalId)
	if portal then
		portal:remove()
	end
end
