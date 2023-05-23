local config = {
	boss = {
		name = "Duke Krule",
		position = Position(33456, 31473, 13)
	},
	requiredLevel = 250,
	timeToFightAgain = 20 * 60 * 60,
	timeToDefeatBoss = 20 * 60,
	playerPositions = {
		{pos = Position(33455, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT},
		{pos = Position(33456, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT},
		{pos = Position(33457, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT},
		{pos = Position(33458, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT},
		{pos = Position(33459, 31493, 13), teleport = Position(33455, 31464, 13), effect = CONST_ME_TELEPORT}
	},
	specPos = {
		from = Position(33447, 31464, 13),
		to = Position(33464, 31481, 13)
	},
	exit = Position(32347, 32167, 12),
	storage = Storage.Quest.U12_20.GraveDanger.Bosses.DukeKruleTimer
}

local dukeKruleLever = Action()
function dukeKruleLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return CreateDefaultLeverBoss(player, config)
end

dukeKruleLever:position({x = 33454, y = 31493, z = 13})
dukeKruleLever:register()