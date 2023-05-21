local config = {
	boss = {
		name = "Plagirath",
		position = Position(33172, 31501, 13)
	},
	timeToFightAgain = 20 * 60 * 60,
	timeToDefeatBoss = 30 * 60,
	playerPositions = {
		{ pos = Position(33229, 31500, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33229, 31501, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33229, 31502, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33229, 31503, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33229, 31504, 13), teleport = Position(33173, 31504, 13), effect = CONST_ME_TELEPORT }
	},
	specPos = {
		from = Position(33159, 31488, 13),
		to = Position(33190, 31515, 13)
	},
	exit = Position(33319, 32318, 13),
	storage = Storage.FerumbrasAscension.PlagirathTimer
}

local ferumbrasAscendantPlagirathLever = Action()
function ferumbrasAscendantPlagirathLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return CreateDefaultLeverBoss(player, config)
end

ferumbrasAscendantPlagirathLever:uid(1022)
ferumbrasAscendantPlagirathLever:register()
