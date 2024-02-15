local config = {
	bosses = {
		{ "Baron Brute", "The Axeorcist" },
		{ "Menace", "Fatality" },
		{ "Incineron", "Coldheart" },
		{ "Dreadwing", "Doomhowl" },
		{ "Haunter", "The Dreadorian" },
		{ "Rocko", "Tremorak" },
		{ "Tirecz" },
	},

	playerPos = {
		Position(33080, 31014, 2),
		Position(33081, 31014, 2),
	},

	teleportPositions = {
		Position(33059, 31032, 3),
		Position(33057, 31034, 3),
	},

	positions = {
		Position(33065, 31035, 3),
		Position(33068, 31034, 3),
		Position(33065, 31033, 3),
		Position(33066, 31037, 3),
	},
}

local function summonBoss(name, position)
	local monsterType = MonsterType(name)
	if not monsterType then
		logger.warn("The New Frontier - Mission 09: Monster with name {} not exist!", name)
		return
	end

	Game.createMonster(monsterType:getName(), position)
	position:sendMagicEffect(CONST_ME_TELEPORT)
end

local function clearArena()
	local spectators = Game.getSpectators(Position(33063, 31034, 3), false, false, 10, 10, 10, 10)
	local exitPosition = Position(33049, 31017, 2)

	for _, spectator in ipairs(spectators) do
		if spectator:isPlayer() then
			spectator:teleportTo(exitPosition)
			exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		else
			spectator:remove()
		end
	end
end

local theNewFrontierArena = Action()

function theNewFrontierArena.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for _, playerPos in ipairs(config.playerPos) do
		local creature = Tile(playerPos):getTopCreature()
		if not creature or creature:getStorageValue(Storage.Quest.U8_54.TheNewFrontier.Questline) >= 26 then
			return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already finished this battle.")
		end
	end

	if Game.getStorageValue(Storage.Quest.U8_54.TheNewFrontier.Mission09[1]) == 1 then
		return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The arena is already in use.")
	end

	Game.setStorageValue(Storage.Quest.U8_54.TheNewFrontier.Mission09[1], 1)
	addEvent(clearArena, 30 * 60 * 1000)

	for i, playerPos in ipairs(config.playerPos) do
		local creature = Tile(playerPos):getTopCreature()
		creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		creature:teleportTo(config.teleportPositions[i])
		creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end

	for i, bosses in ipairs(config.bosses) do
		for j, boss in ipairs(bosses) do
			addEvent(summonBoss, (i - 1) * 90 * 1000, boss, config.positions[j + (i == 1 and 2 or 0)])
		end
	end
	return true
end

theNewFrontierArena:aid(30003)
theNewFrontierArena:register()
