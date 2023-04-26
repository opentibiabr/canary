local config = {
	boss = {
		name = "Goshnar's Cruelty",
		position = Position(33856, 31866, 7)
	},
	requiredLevel = 250,
	timeToFightAgain = 20 * 60 * 60,
	timeToDefeatBoss = 20 * 60,
	playerPositions = {
		{pos = Position(33854, 31854, 6), teleport = Position(33856, 31872, 7), effect = CONST_ME_TELEPORT},
		{pos = Position(33855, 31854, 6), teleport = Position(33856, 31872, 7), effect = CONST_ME_TELEPORT},
		{pos = Position(33856, 31854, 6), teleport = Position(33856, 31872, 7), effect = CONST_ME_TELEPORT},
		{pos = Position(33857, 31854, 6), teleport = Position(33856, 31872, 7), effect = CONST_ME_TELEPORT},
		{pos = Position(33858, 31854, 6), teleport = Position(33856, 31872, 7), effect = CONST_ME_TELEPORT}
	},
	specPos = {
		from = Position(33847, 31858, 7),
		to = Position(33864, 31874, 7)
	},
	exit = Position(33621, 31427, 10),
	storage = Storage.Quest.U12_40.SoulWar.GoshnarCrueltyTimer
}

local goshnarsCrueltyLever = Action()
function goshnarsCrueltyLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return CreateDefaultLeverBoss(player, config)
end

goshnarsCrueltyLever:position({x = 33853, y = 31854, z = 6})
goshnarsCrueltyLever:register()