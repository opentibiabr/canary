local config = {
	boss = {
		name = "Gorzindel",
		position = Position(32687, 32715, 10)
	},
	requiredLevel = 250,
	timeToFightAgain = 20 * 60 * 60,
	timeToDefeatBoss = 20 * 60,
	playerPositions = {
		{pos = Position(32747, 32749, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT},
		{pos = Position(32748, 32749, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT},
		{pos = Position(32749, 32749, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT},
		{pos = Position(32747, 32750, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT},
		{pos = Position(32747, 32751, 10), teleport = Position(32686, 32721, 10), effect = CONST_ME_TELEPORT}
	},
	specPos = {
		from = Position(32680, 32711, 10),
		to = Position(32695, 32726, 10)
	},
	exit = Position(32660, 32734, 12),
	storage = Storage.Quest.U11_80.TheSecretLibrary.GorzindelTimer
}

local gorzindelLever = Action()
function gorzindelLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return CreateDefaultLeverBoss(player, config)
end

gorzindelLever:position({x = 32746, y = 32749, z = 10})
gorzindelLever:register()