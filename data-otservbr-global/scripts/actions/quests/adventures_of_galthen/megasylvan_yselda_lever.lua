local config = {
	boss = {
		name = "Megasylvan Yselda",
		position = Position(32619, 32493, 12)
	},
	requiredLevel = 250,
	timeToFightAgain = 20 * 60 * 60,
	timeToDefeatBoss = 20 * 60,
	playerPositions = {
		{pos = Position(32578, 32500, 12), teleport = Position(32619, 32498, 12), effect = CONST_ME_TELEPORT},
		{pos = Position(32578, 32501, 12), teleport = Position(32619, 32498, 12), effect = CONST_ME_TELEPORT},
		{pos = Position(32578, 32502, 12), teleport = Position(32619, 32498, 12), effect = CONST_ME_TELEPORT},
		{pos = Position(32578, 32503, 12), teleport = Position(32619, 32498, 12), effect = CONST_ME_TELEPORT},
		{pos = Position(32578, 32504, 12), teleport = Position(32619, 32498, 12), effect = CONST_ME_TELEPORT}
	},
	specPos = {
		from = Position(32601, 32486, 12),
		to = Position(32633, 32509, 12)
	},
	exit = Position(32580, 32480, 12),
	storage = Storage.Quest.U12_70.AdventuresOfGalthen.MegasylvanYseldaTimer
}

local megasylvanYseldaLever = Action()
function megasylvanYseldaLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return CreateDefaultLeverBoss(player, config)
end

megasylvanYseldaLever:position({x = 32578, y = 32499, z = 12})
megasylvanYseldaLever:register()