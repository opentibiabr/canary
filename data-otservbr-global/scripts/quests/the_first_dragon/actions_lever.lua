local config = {
	boss = {
		name = "spirit of fertility",
		position = Position(33625, 31021, 14),
	},
	timeToFightAgain = 20 * 60 * 60,
	playerPositions = {
		{ pos = Position(33583, 30993, 14), teleport = Position(33592, 31017, 14) },
		{ pos = Position(33582, 30993, 14), teleport = Position(33574, 31017, 14) },
		{ pos = Position(33584, 30993, 14), teleport = Position(33592, 31035, 14) },
		{ pos = Position(33582, 30994, 14), teleport = Position(33574, 31035, 14) },
		{ pos = Position(33583, 30994, 14), teleport = Position(33583, 31026, 14) },
		{ pos = Position(33584, 30994, 14), teleport = Position(33574, 31017, 14) },
		{ pos = Position(33582, 30995, 14), teleport = Position(33592, 31017, 14) },
		{ pos = Position(33583, 30995, 14), teleport = Position(33592, 31035, 14) },
		{ pos = Position(33584, 30995, 14), teleport = Position(33574, 31035, 14) },
		{ pos = Position(33582, 30996, 14), teleport = Position(33583, 31026, 14) },
		{ pos = Position(33583, 30996, 14), teleport = Position(33574, 31017, 14) },
		{ pos = Position(33584, 30996, 14), teleport = Position(33592, 31017, 14) },
		{ pos = Position(33582, 30997, 14), teleport = Position(33592, 31035, 14) },
		{ pos = Position(33583, 30997, 14), teleport = Position(33574, 31035, 14) },
		{ pos = Position(33584, 30997, 14), teleport = Position(33583, 31026, 14) },
	},
	specPos = {
		from = Position(33566, 31006, 14),
		to = Position(33626, 31032, 14),
	},
	monsters = {
		{ name = "fallen challenger", pos = Position(33592, 31013, 14) },
		{ name = "fallen challenger", pos = Position(33583, 31022, 14) },
		{ name = "fallen challenger", pos = Position(33574, 31013, 14) },
		{ name = "fallen challenger", pos = Position(33574, 31031, 14) },
		{ name = "fallen challenger", pos = Position(33592, 31031, 14) },
		{ name = "unbeatable dragon", pos = Position(math.random(33610, 33622), math.random(31016, 31030), 14) },
		{ name = "unbeatable dragon", pos = Position(math.random(33610, 33622), math.random(31016, 31030), 14) },
		{ name = "unbeatable dragon", pos = Position(math.random(33610, 33622), math.random(31016, 31030), 14) },
		{ name = "unbeatable dragon", pos = Position(math.random(33610, 33622), math.random(31016, 31030), 14) },
		{ name = "unbeatable dragon", pos = Position(math.random(33610, 33622), math.random(31016, 31030), 14) },
	},
	exit = Position(33597, 30994, 14),
	onUseExtra = function(creature)
		if creature and creature:isPlayer() then
			creature:setStorageValue(Storage.Quest.U11_02.TheFirstDragon.SomewhatBeatable, 0)
		end
	end,
}

local leverFirstDragon = BossLever(config)
leverFirstDragon:position(Position(33583, 30992, 14))
leverFirstDragon:register()
