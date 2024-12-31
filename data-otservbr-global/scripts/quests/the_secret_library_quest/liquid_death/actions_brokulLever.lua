local config = {
	boss = {
		name = "Brokul",
		position = Position(33483, 31437, 15),
	},
	timeToFightAgain = 20 * 60 * 60,
	minPlayers = 5,
	playerPositions = {
		{ pos = Position(33522, 31465, 15), teleport = Position(33484, 31446, 15) },
		{ pos = Position(33520, 31465, 15), teleport = Position(33484, 31446, 15) },
		{ pos = Position(33521, 31465, 15), teleport = Position(33484, 31446, 15) },
		{ pos = Position(33523, 31465, 15), teleport = Position(33484, 31446, 15) },
		{ pos = Position(33524, 31465, 15), teleport = Position(33484, 31446, 15) },
	},
	specPos = {
		from = Position(33472, 31427, 15),
		to = Position(33496, 31450, 15),
	},
	exit = Position(33528, 31464, 14),
	onUseExtra = function(creature, infoPositions)
		if creature and creature:isPlayer() then
			if creature:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline) >= 6 then
				return true
			end
			return false
		end
	end,
}

local leverBrokul = BossLever(config)
leverBrokul:aid(34000)
leverBrokul:register()
