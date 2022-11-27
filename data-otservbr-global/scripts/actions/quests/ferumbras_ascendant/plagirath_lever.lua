local config = {
	bossName = "Plagirath",
	timeToFightAgain = 20 * 60 * 60,
	timeToDefeatBoss = 30 * 60,
	playerPositions = {
		{ pos = Position(33229, 31500, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33229, 31501, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33229, 31502, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33229, 31503, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33229, 31504, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT }
	},
	bossPosition = Position(33172, 31501, 13),
	specPos = {
		from = Position(33159, 31488, 13),
		to = Position(33190, 31515, 13)
	},
	exit = Position(33319, 32318, 13),
	storage = Storage.FerumbrasAscension.PlagirathTimer
}

local ferumbrasAscendantPlagirathLever = Action()
function ferumbrasAscendantPlagirathLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	CreateDefaultLeverBoss(player, config)
	return true
end

ferumbrasAscendantPlagirathLever:uid(1022)
ferumbrasAscendantPlagirathLever:register()
