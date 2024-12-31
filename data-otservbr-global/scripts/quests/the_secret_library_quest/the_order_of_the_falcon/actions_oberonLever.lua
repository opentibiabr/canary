local config = {
	boss = {
		name = "Grand Master Oberon",
		createFunction = function()
			Game.createMonster("Grand Master Oberon", Position(33365, 31318, 9), true, true):setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.OberonHeal, 0)
			return true
		end,
	},
	timeToFightAgain = 20 * 60 * 60,
	playerPositions = {
		{ pos = Position(33364, 31344, 9), teleport = Position(33364, 31322, 9) },
		{ pos = Position(33362, 31344, 9), teleport = Position(33364, 31322, 9) },
		{ pos = Position(33363, 31344, 9), teleport = Position(33364, 31322, 9) },
		{ pos = Position(33365, 31344, 9), teleport = Position(33364, 31322, 9) },
		{ pos = Position(33366, 31344, 9), teleport = Position(33364, 31322, 9) },
	},
	specPos = {
		from = Position(33356, 31311, 9),
		to = Position(33376, 31328, 9),
	},
	exit = Position(33297, 31285, 9),
}

local leverOberon = BossLever(config)
leverOberon:aid(57605)
leverOberon:register()
