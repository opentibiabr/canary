local config = {
	boss = {
		name = "King Zelos",
		createFunction = function()
			return GraveDanger.start("King Zelos", Position(33443, 31545, 13))
		end,
	},
	requiredLevel = 250,
	timeToDefeat = 24 * 60,
	timeToFightAgain = 20 * 60 * 60,
	onUseExtra = function(player)
		return GraveDanger.checkEntry("King Zelos", player)
	end,
	playerPositions = {
		{ pos = Position(33485, 31546, 13), teleport = Position(33436, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33485, 31547, 13), teleport = Position(33436, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33485, 31548, 13), teleport = Position(33436, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33485, 31545, 13), teleport = Position(33436, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33485, 31544, 13), teleport = Position(33436, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31546, 13), teleport = Position(33436, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31547, 13), teleport = Position(33436, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31548, 13), teleport = Position(33436, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31545, 13), teleport = Position(33436, 31572, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33486, 31544, 13), teleport = Position(33436, 31572, 13), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33414, 31520, 13),
		to = Position(33474, 31574, 13),
	},
	exit = Position(32172, 31918, 8),
}

local lever = BossLever(config)
lever:position(Position(33484, 31546, 13))
lever:register()
