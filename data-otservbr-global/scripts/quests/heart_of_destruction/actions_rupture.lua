local config = {
	boss = {
		name = "Rupture",
		position = Position(32332, 31250, 14),
	},
	playerPositions = {
		{ pos = Position(32309, 31248, 14), teleport = Position(32335, 31257, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32309, 31249, 14), teleport = Position(32335, 31257, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32309, 31250, 14), teleport = Position(32335, 31257, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32309, 31251, 14), teleport = Position(32335, 31257, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32309, 31252, 14), teleport = Position(32335, 31257, 14), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(32324, 31239, 14),
		to = Position(32347, 31263, 14),
	},
	monsters = {
		{ name = "Spark of Destruction", pos = Position(32331, 31254, 14) },
		{ name = "Spark of Destruction", pos = Position(32338, 31254, 14) },
		{ name = "Spark of Destruction", pos = Position(32330, 31250, 14) },
		{ name = "Spark of Destruction", pos = Position(32338, 31250, 14) },
	},
	onUseExtra = function()
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceStage, -1)
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.RuptureResonanceActive, -1)

		local tile = Tile(Position(32326, 31250, 14))
		if tile then
			local vortex = tile:getItemById(23482)
			if vortex then
				vortex:transform(23483)
				vortex:setActionId(14343)
			end
		end
	end,
	exit = Position(32088, 31321, 13),
}

local lever = BossLever(config)
lever:position(Position(32309, 31247, 14))
lever:register()
