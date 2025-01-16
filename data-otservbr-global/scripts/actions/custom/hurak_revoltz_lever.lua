local config = {
	boss = {
		name = "Hurak Revoltz",
		position = DungeonConfig.hurakPos,
	},
	requiredLevel = 250,
	timeToFightAgain = 10, -- In hour
	playerPositions = {
		{ pos = Position(1091, 1128, 12), teleport = Position(1121, 1136, 12), effect = CONST_ME_TELEPORT },
		{ pos = Position(1092, 1128, 12), teleport = Position(1121, 1136, 12), effect = CONST_ME_TELEPORT },
		{ pos = Position(1093, 1128, 12), teleport = Position(1121, 1136, 12), effect = CONST_ME_TELEPORT },
		{ pos = Position(1094, 1128, 12), teleport = Position(1121, 1136, 12), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(1114, 1126, 12),
		to = Position(1128, 1138, 12),
	},
	timeAfterKill = 35,
	onUseExtra = function()
		local portal = Tile(DungeonConfig.hurakPos):getItemById(DungeonConfig.portalId)
		if portal then
			portal:remove()
		end
		resetPlayersInHurakWifes()
	end,
	exit = Position(32369, 32241, 7),
}

local lever = BossLever(config)
lever:position(Position(1090, 1128, 12))
lever:register()
