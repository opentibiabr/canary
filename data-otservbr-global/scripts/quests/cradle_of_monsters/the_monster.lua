local config = {
	boss = { name = "The Monster" },
	encounter = "The Monster",
	requiredLevel = 250,

	playerPositions = {
		{ pos = { x = 33812, y = 32584, z = 12 }, teleport = { x = 33831, y = 32591, z = 12 }, effect = CONST_ME_TELEPORT },
		{ pos = { x = 33811, y = 32584, z = 12 }, teleport = { x = 33831, y = 32591, z = 12 }, effect = CONST_ME_TELEPORT },
		{ pos = { x = 33810, y = 32584, z = 12 }, teleport = { x = 33831, y = 32591, z = 12 }, effect = CONST_ME_TELEPORT },
		{ pos = { x = 33809, y = 32584, z = 12 }, teleport = { x = 33831, y = 32591, z = 12 }, effect = CONST_ME_TELEPORT },
		{ pos = { x = 33808, y = 32584, z = 12 }, teleport = { x = 33831, y = 32591, z = 12 }, effect = CONST_ME_TELEPORT },
	},
	specPos = {
		from = { x = 33828, y = 32584, z = 12 },
		to = { x = 33846, y = 32598, z = 12 },
	},
	exitTeleporter = { x = 33829, y = 32591, z = 12 },
	exit = { x = 33810, y = 32587, z = 12 },
}

local lever = BossLever(config)
lever:position({ x = 33813, y = 32584, z = 12 })
lever:register()

-- Entrance to lever room
SimpleTeleport({ x = 33792, y = 32581, z = 12 }, { x = 33806, y = 32584, z = 12 })
-- Exit from lever room
SimpleTeleport({ x = 33804, y = 32584, z = 12 }, { x = 33792, y = 32579, z = 12 })
