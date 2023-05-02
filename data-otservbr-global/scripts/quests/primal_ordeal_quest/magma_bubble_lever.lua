local config = {
	boss = {
		name = "Magma Bubble",
		position = Position(33654, 32909, 15)
	},
	requiredLevel = 500,
	timeToFightAgain = 20 * 60 * 60,
	timeToDefeatBoss = 20 * 60,
	playerPositions = {
		{pos = Position(33669, 32926, 15), teleport = Position(33655, 32917, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(33669, 32927, 15), teleport = Position(33655, 32917, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(33669, 32928, 15), teleport = Position(33655, 32917, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(33669, 32929, 15), teleport = Position(33655, 32917, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(33669, 32930, 15), teleport = Position(33655, 32917, 15), effect = CONST_ME_TELEPORT}
	},
	specPos = {
		from = Position(33640, 32899, 15),
		to = Position(33663, 32920, 15)
	},
	exit = Position(33659, 32897, 14),
	storage = Storage.Quest.U12_90.PrimalOrdeal.Bosses.MagmaBubbleTimer
}

local MagmaBubbleLever = Action()
function MagmaBubbleLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return CreateDefaultLeverBoss(player, config)
end

MagmaBubbleLever:position({x = 33669, y = 32925, z = 15})
MagmaBubbleLever:register()