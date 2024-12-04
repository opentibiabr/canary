SoulPit = {
	SoulCoresConfiguration = {
		chanceToGetSameMonsterSoulCore = 30, -- 30%
		chanceToDropSoulCore = 50, -- 50%
		chanceToGetOminousSoulCore = 5, -- 5%
		monsterVariationsSoulCore = {
			["Horse"] = "horse soul core (taupe)",
			["Brown Horse"] = "horse soul core (brown)",
			["Grey Horse"] = "horse soul core (gray)",
			["Nomad"] = "nomad soul core (basic)",
			["Nomad Blue"] = "nomad soul core (blue)",
			["Nomad Female"] = "nomad soul core (female)",
			["Purple Butterfly"] = "butterfly soul core (purple)",
			["Butterfly"] = "butterfly soul core (blue)",
			["Blue Butterfly"] = "butterfly soul core (blue)",
			["Red Butterfly"] = "butterfly soul core (red)",
		},
		monstersDifficulties = {
			["Harmless"] = 1,
			["Trivial"] = 2,
			["Easy"] = 3,
			["Medium"] = 4,
			["Hard"] = 5,
			["Challenge"] = 6,
		},
	},
	encounter = nil,
	kickEvent = nil,
	soulCores = Game.getSoulCoreItems(),
	requiredLevel = 8,
	playerPositions = {
		{
			pos = Position(32371, 31155, 8),
			teleport = Position(32373, 31138, 8),
			effect = CONST_ME_TELEPORT,
		},
		{
			pos = Position(32371, 31156, 8),
			teleport = Position(32373, 31138, 8),
			effect = CONST_ME_TELEPORT,
		},
		{
			pos = Position(32371, 31157, 8),
			teleport = Position(32373, 31138, 8),
			effect = CONST_ME_TELEPORT,
		},
		{
			pos = Position(32371, 31158, 8),
			teleport = Position(32373, 31138, 8),
			effect = CONST_ME_TELEPORT,
		},
		{
			pos = Position(32371, 31159, 8),
			teleport = Position(32373, 31138, 8),
			effect = CONST_ME_TELEPORT,
		},
	},
	waves = {
		[1] = {
			stacks = {
				[1] = 7,
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
		overpowerSoulPit = {
			player = true,
			monster = false,
		},
		enrageSoulPit = {
			player = false,
			monster = true,
		},
		opressorSoulPit = {
			player = false,
			monster = true,
		},
	},
	timeToKick = 3 * 1000, -- 3 seconds
	checkMonstersDelay = 4.5 * 1000, -- 4.5 seconds | The check delay should never be less than the timeToSpawnMonsters.
	timeToSpawnMonsters = 4 * 1000, -- 4 seconds
	totalMonsters = 7,
	obeliskActive = 49175,
	obeliskInactive = 49174,
	obeliskPosition = Position(32371, 31154, 8),
	bossPosition = Position(32372, 31135, 8),
	exit = Position(32371, 31164, 8),
	zone = Zone("soulpit"),
}

SoulPit.zone:addArea(Position(32365, 31134, 8), Position(32382, 31152, 8))
