local config = {
	boss = {
		name = "Foreshock",
		position = Position(32208, 31248, 14),
	},
	playerPositions = {
		{ pos = Position(32182, 31244, 14), teleport = Position(32208, 31256, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32182, 31245, 14), teleport = Position(32208, 31256, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32182, 31246, 14), teleport = Position(32208, 31256, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32182, 31247, 14), teleport = Position(32208, 31256, 14), effect = CONST_ME_TELEPORT },
		{ pos = Position(32182, 31248, 14), teleport = Position(32208, 31256, 14), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(32197, 31236, 14),
		to = Position(32220, 31260, 14),
	},
	monsters = {
		{ name = "Spark of Destruction", pos = Position(32203, 31246, 14) },
		{ name = "Spark of Destruction", pos = Position(32205, 31251, 14) },
		{ name = "Spark of Destruction", pos = Position(32210, 31251, 14) },
		{ name = "Spark of Destruction", pos = Position(32212, 31246, 14) },
	},
	onUseExtra = function()
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.ForeshockHealth, 105000)
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.AftershockHealth, 105000)
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.ForeshockStage, -1)
		Game.setStorageValue(GlobalStorage.HeartOfDestruction.AftershockStage, -1)
		local tile = Tile(Position(32199, 31248, 14))
		if tile then
			local vortex = tile:getItemById(23482)
			if vortex then
				vortex:transform(23483)
				vortex:setActionId(14345)
			end
		end
	end,
	exit = Position(32230, 31358, 11),
}

local lever = BossLever(config)
lever:position(Position(32182, 31243, 14))
lever:register()
