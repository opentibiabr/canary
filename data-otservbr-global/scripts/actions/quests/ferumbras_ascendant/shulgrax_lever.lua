local config = {
	boss = {
		name = "Shulgrax",
		position = Position(33485, 32786, 13)
	},
	timeToFightAgain = 20 * 60 * 60,
	timeToDefeatBoss = 30 * 60,
	playerPositions = {
		{ pos = Position(33434, 32785, 13), teleport = Position(33485, 32790, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33434, 32786, 13), teleport = Position(33485, 32790, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33434, 32787, 13), teleport = Position(33485, 32790, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33434, 32788, 13), teleport = Position(33485, 32790, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33434, 32789, 13), teleport = Position(33485, 32790, 13), effect = CONST_ME_TELEPORT }
	},
	specPos = {
		from = Position(33474, 32775, 13),
		to = Position(33496, 32798, 13)
	},
	exit = Position(33319, 32318, 13),
	storage = Storage.FerumbrasAscension.ShulgraxTimer
}

local ferumbrasAscendantShulgraxLever = Action()
function ferumbrasAscendantShulgraxLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return CreateDefaultLeverBoss(player, config)
end

ferumbrasAscendantShulgraxLever:uid(1028)
ferumbrasAscendantShulgraxLever:register()
