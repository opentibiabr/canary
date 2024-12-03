SoulPit = {
	encounter = nil,
	soulCores = Game.getSoulCoreItems(),
	requiredLevel = 8,
	playerPositions = {
		{ pos = Position(32371, 31155, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(32371, 31156, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(32371, 31157, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(32371, 31158, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
		{ pos = Position(32371, 31159, 8), teleport = Position(32373, 31138, 8), effect = CONST_ME_TELEPORT },
	},
	waves = {
		[1] = {
			stacks = {
				[1] = 6,
				[40] = 1
			},
		},
		[2] = {
			stacks = {
				[1] = 4,
				[5] = 3,
			},
		},
		[3] = {
			stacks = {
				[1] = 5,
				[15] = 2,
			},
		},
		[4] = {
			stacks = {
				[1] = 3,
				[5] = 3,
				[40] = 1,
			},
		},
	},
	effects = {
		[1] = CONST_ME_TELEPORT,
		[5] = CONST_ME_ORANGETELEPORT,
		[15] = CONST_ME_REDTELEPORT,
		[40] = CONST_ME_PURPLETELEPORT,
	},
	possibleAbilities = {
		"overpowerSoulPit",
		"enrageSoulPit",
		"opressorSoulPit",
	},
	bossAbilities = {
		["overpowerSoulPit"] = {
			player = true,
			monster = false,
		},
		["enrageSoulPit"] = {
			player = false,
			monster = true,
		},
		["opressorSoulPit"] = {
			player = false,
			monster = true,
		},
	},
	timeToKick = 3 * 1000, -- 3 seconds
	checkMonstersDelay = 4.5 * 1000, -- 4.5 seconds | The check delay should never be less than the timeToSpawnMonsters.
	timeToSpawnMonsters = 4 * 1000, -- 4 seconds
	totalMonsters = 7,
	bossPosition = Position(32372, 31135, 8),
	exit = Position(32371, 31164, 8),
	zone = Zone("soulpit"),
}

SoulPit.zone:addArea(Position(32365, 31134, 8), Position(32382, 31152, 8))
