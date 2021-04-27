-- Look README.md for see the reserved action/unique numbers
-- This file is only for teleports items (miscellaneous) not for magic forcefields

TeleportItemAction = {
	-- Feyrist shrines entrance
	-- Path: data\scripts\actions\other\gems.lua
	[15001] = {
		itemId = false,
		itemPos = {
			{x = 32194, y = 31418, z = 2},
			{x = 32194, y = 31419, z = 2},
			{x = 32195, y = 31418, z = 2},
			{x = 32195, y = 31419, z = 2}
		},
	},
	[15002] = {
		itemId = false,
		itemPos = {
			{x = 32910, y = 32338, z = 15},
			{x = 32910, y = 32339, z = 15},
			{x = 32911, y = 32338, z = 15},
			{x = 32911, y = 32339, z = 15}
		}
	},
	[15003] = {
		itemId = false,
		itemPos = {
			{x = 32973, y = 32225, z = 7},
			{x = 32973, y = 32226, z = 7},
			{x = 32974, y = 32225, z = 7},
			{x = 32974, y = 32226, z = 7}
		}
	},
	[15004] = {
		itemId = false,
		itemPos = {
			{x = 33060, y = 32713, z = 5},
			{x = 33060, y = 32714, z = 5},
			{x = 33061, y = 32713, z = 5},
			{x = 33061, y = 32714, z = 5}
		}
	},
	-- Deeper fibula draw well
	-- Path: data\scripts\quests\deeper_fibula\action-draw_well.lua
	[15005] = {
		itemId = false,
		itemPos = {
			{x = 32171, y = 32439, z = 7},
			{x = 32172, y = 32439, z = 7}
		}
	},
}

TeleportItemUnique = {
	[15001] = {
		itemId = 36508,
		itemPos = {x = 33315, y = 32647, z = 6},
		destination = {x = 33384, y = 32627, z = 7},
		effect = CONST_ME_TELEPORT
	},
	[15002] = {
		itemId = 3591,
		itemPos = {x = 33383, y = 32626, z = 7},
		destination = {x = 33314, y = 32647, z = 6},
		effect = CONST_ME_TELEPORT
	},
	[15003] = {
		itemId = 5679,
		itemPos = {x = 33918, y = 31471, z = 7},
		destination = {x = 33916, y = 31466, z = 8},
		effect = CONST_ME_TELEPORT
	}
}
