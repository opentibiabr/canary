local config = {
	boss = {
		name = "The Nightmare Beast",
		position = Position(32208, 32046, 15)
	},
	requiredLevel = 250,
	timeToFightAgain = 20 * 60 * 60,
	timeToDefeatBoss = 20 * 60,
	playerPositions = {
		{pos = Position(32212, 32070, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(32210, 32070, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(32211, 32070, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(32213, 32070, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(32214, 32070, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(32210, 32071, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(32211, 32071, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(32212, 32071, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(32213, 32071, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(32214, 32071, 15), teleport = Position(32208, 32052, 15), effect = CONST_ME_TELEPORT}
	},
	specPos = {
		from = Position(32195, 32035, 15),
		to = Position(32220, 32055, 15)
	},
	exit = Position(32211, 32084, 15),
	storage = Storage.Quest.U12_00.TheDreamCourts.NightmareBeastTimer
}

local nightmareBeastLever = Action()
function nightmareBeastLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return CreateDefaultLeverBoss(player, config)
end

nightmareBeastLever:position({x = 32212, y = 32069, z = 15})
nightmareBeastLever:register()