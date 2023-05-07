local config = {
	boss = {
		name = "The Pale Worm",
		position = Position(33805, 31504, 14)
	},
	requiredLevel = 250,
	timeToFightAgain = 20 * 60 * 60,
	timeToDefeatBoss = 25 * 60,
	playerPositions = {
		{pos = Position(33772, 31504, 14), teleport = Position(33808, 31515, 14), effect = CONST_ME_TELEPORT},
		{pos = Position(33773, 31504, 14), teleport = Position(33808, 31515, 14), effect = CONST_ME_TELEPORT},
		{pos = Position(33774, 31504, 14), teleport = Position(33808, 31515, 14), effect = CONST_ME_TELEPORT},
		{pos = Position(33775, 31504, 14), teleport = Position(33808, 31515, 14), effect = CONST_ME_TELEPORT},
		{pos = Position(33773, 31503, 14), teleport = Position(33808, 31515, 14), effect = CONST_ME_TELEPORT},
		{pos = Position(33774, 31503, 14), teleport = Position(33808, 31515, 14), effect = CONST_ME_TELEPORT},
		{pos = Position(33775, 31503, 14), teleport = Position(33808, 31515, 14), effect = CONST_ME_TELEPORT},
		{pos = Position(33773, 31505, 14), teleport = Position(33808, 31515, 14), effect = CONST_ME_TELEPORT},
		{pos = Position(33774, 31505, 14), teleport = Position(33808, 31515, 14), effect = CONST_ME_TELEPORT},
		{pos = Position(33775, 31505, 14), teleport = Position(33808, 31515, 14), effect = CONST_ME_TELEPORT}
	},
	specPos = {
		from = Position(33793, 31496, 14),
		to = Position(33816, 31515, 14)
	},
	exit = Position(33572, 31451, 10),
	storage = Storage.Quest.U12_30.FeasterOfSouls.PaleWormTimer
}

local paleWormLever = Action()
function paleWormLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return CreateDefaultLeverBoss(player, config)
end

paleWormLever:position({x = 33771, y = 31504, z = 14})
paleWormLever:register()