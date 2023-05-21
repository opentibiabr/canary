local config = {
	boss = {
		name = "Ragiaz",
		position = Position(33481, 32334, 13)
	},
	timeToFightAgain = 20 * 60 * 60,
	timeToDefeatBoss = 30 * 60,
	playerPositions = {
		{ pos = Position(33456, 32356, 13), teleport = Position(33482, 32339, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33457, 32356, 13), teleport = Position(33482, 32339, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33458, 32356, 13), teleport = Position(33482, 32339, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33459, 32356, 13), teleport = Position(33482, 32339, 13), effect = CONST_ME_TELEPORT },
		{ pos = Position(33460, 32356, 13), teleport = Position(33482, 32339, 13), effect = CONST_ME_TELEPORT }
	},
	specPos = {
		from = Position(33468, 32319, 13),
		to = Position(33495, 32347, 13)
	},
	exit = Position(33319, 32318, 13),
	storage = Storage.FerumbrasAscension.RagiazTimer
}

local deathDragons = {
	Position(33476, 32331, 13),
	Position(33476, 32340, 13),
	Position(33487, 32340, 13),
	Position(33488, 32331, 13)
}

local ferumbrasAscendantRagiaz = Action()
function ferumbrasAscendantRagiaz.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if CreateDefaultLeverBoss(player, config) then
		for _, pos in pairs(deathDragons) do
			Game.createMonster('Death Dragon', pos, true, true)
		end
		return true
	end
	return false
end

ferumbrasAscendantRagiaz:uid(1023)
ferumbrasAscendantRagiaz:register()
