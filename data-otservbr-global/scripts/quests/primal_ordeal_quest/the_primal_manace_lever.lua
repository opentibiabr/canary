local config = {
	boss = {
		name = "The Primal Menace",
		position = Position(33558, 32759, 15)
	},
	requiredLevel = 500,
	timeToFightAgain = 20 * 60 * 60,
    timeToDefeatBoss = 20 * 60,
	playerPositions = {
		{pos = Position(33548, 32752, 14), teleport = Position(33565, 32758, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(33549, 32752, 14), teleport = Position(33565, 32758, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(33550, 32752, 14), teleport = Position(33565, 32758, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(33551, 32752, 14), teleport = Position(33565, 32758, 15), effect = CONST_ME_TELEPORT},
		{pos = Position(33552, 32752, 14), teleport = Position(33565, 32758, 15), effect = CONST_ME_TELEPORT}
	},
	specPos = {
		from = Position(33547, 32749, 15),
		to = Position(33570, 32769, 15)
	},
	exit = Position(33520, 32871, 15),
	storage = Storage.Quest.U12_90.PrimalOrdeal.Bosses.ThePrimalMenaceTimer
}

local PrimalMenaceLever = Action()
function PrimalMenaceLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return CreateDefaultLeverBoss(player, config)
end

PrimalMenaceLever:position({x = 33547, y = 32752, z = 14})
PrimalMenaceLever:register()
