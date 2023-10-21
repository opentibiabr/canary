local config = {
	boss = { name = "Magma Bubble" },
	encounter = "Magma Bubble",
	requiredLevel = 500,

	playerPositions = {
		{ pos = Position(33669, 32926, 15), teleport = Position(33655, 32917, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33669, 32927, 15), teleport = Position(33655, 32917, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33669, 32928, 15), teleport = Position(33655, 32917, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33669, 32929, 15), teleport = Position(33655, 32917, 15), effect = CONST_ME_TELEPORT },
		{ pos = Position(33669, 32930, 15), teleport = Position(33655, 32917, 15), effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = Position(33630, 32887, 15),
		to = Position(33672, 32921, 15),
	},
	exit = Position(33659, 32897, 14),
}

local lever = BossLever(config)
lever:position({ x = 33669, y = 32925, z = 15 })
lever:register()

local zone = lever:getZone()
zone:addArea({ x = 33633, y = 32915, z = 15 }, { x = 33649, y = 32928, z = 15 })
