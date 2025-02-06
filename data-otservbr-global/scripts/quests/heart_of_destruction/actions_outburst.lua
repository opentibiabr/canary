local config = {
	boss = {
		name = "Outburst",
		position = Position(32234, 31284, 14),
	},
	playerPositions = {
		{ pos = Position(32207, 31284, 14), teleport = Position(32234, 31292, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32207, 31285, 14), teleport = Position(32234, 31292, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32207, 31286, 14), teleport = Position(32234, 31292, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32207, 31287, 14), teleport = Position(32234, 31292, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32207, 31288, 14), teleport = Position(32234, 31292, 14), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(32223, 31273, 14),
		to = Position(32246, 31297, 14),
	},
	monsters = {
		{ name = "Spark of Destruction", pos = Position(32229, 31282, 14) },
		{ name = "Spark of Destruction", pos = Position(32230, 31287, 14) },
		{ name = "Spark of Destruction", pos = Position(32237, 31287, 14) },
		{ name = "Spark of Destruction", pos = Position(32238, 31282, 14) },
	},
	onUseExtra = function()
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.OutburstStage, 0)
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.OutburstHealth, 290000)

		local tile = Tile(Position(32225, 31285, 14))
		if tile then
			local vortex = tile:getItemById(23482)
			if vortex then
				vortex:transform(23483)
				vortex:setActionId(14350)
			end
		end
	end,
	exit = Position(32208, 31372, 14),
}

local lever = BossLever(config)
lever:position(Position(32207, 31283, 14))
lever:register()
