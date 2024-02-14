local function Nightmarewebhook(message) -- New local function that runs on delay to send webhook message.
	Webhook.sendMessage(":thought_balloon: " .. message, announcementChannels["serverAnnouncements"])
end

local nightmareIsleConfig = {
	{ displayName = "North of Ankrahmun", mapName = "ankrahmun-north", storage = GlobalStorage.WorldBoard.NightmareIsle.AnkrahmunNorth },
	{ displayName = "North of Darashia", mapName = "darashia-north", storage = GlobalStorage.WorldBoard.NightmareIsle.DarashiaNorth },
	{ displayName = "West of Darashia", mapName = "darashia-west", storage = GlobalStorage.WorldBoard.NightmareIsle.DarashiaWest },
}

local nightmareIsleEvent = GlobalEvent("Nightmare Isle")

function nightmareIsleEvent.onStartup()
	for _, config in ipairs(nightmareIsleConfig) do
		Game.setStorageValue(config.storage, -1)
	end

	local randomMap = nightmareIsleConfig[math.random(#nightmareIsleConfig)]
	Game.loadMap(DATA_DIRECTORY .. "/world/world_changes/nightmare_isle/" .. randomMap.mapName .. ".otbm")
	Game.setStorageValue(randomMap.storage, 1)

	logger.info("[World Change] Nightmare Isle is active in " .. randomMap.displayName)

	addEvent(Nightmarewebhook, 60000, string.format("Nightmare Isle will be active %s today", randomMap.displayName))
	return true
end

nightmareIsleEvent:register()

local teleportExits = {
	{ position = Position(33255, 32678, 7), storage = GlobalStorage.WorldBoard.NightmareIsle.AnkrahmunNorth },
	{ position = Position(33215, 32273, 7), storage = GlobalStorage.WorldBoard.NightmareIsle.DarashiaNorth },
	{ position = Position(33032, 32400, 7), storage = GlobalStorage.WorldBoard.NightmareIsle.DarashiaWest },
}

local teleportExit = MoveEvent()

function teleportExit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	for _, config in ipairs(teleportExits) do
		if Game.getStorageValue(config.storage) == 1 then
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(config.position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
	return true
end

teleportExit:uid(35020)
teleportExit:register()

local teleportEntrace = MoveEvent()

function teleportEntrace.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(Position(33497, 32616, 8))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

teleportEntrace:uid(64001, 64002, 64003)
teleportEntrace:register()

local teleportPositions = {
	[64103] = Position(33475, 32641, 10),
	[64104] = Position(33473, 32647, 9),
	[64105] = Position(33463, 32585, 8),
	[64106] = Position(33457, 32580, 8),
	[64107] = Position(33422, 32582, 8),
	[64108] = Position(33430, 32600, 10),
	[64109] = Position(33420, 32604, 10),
	[64120] = Position(33446, 32616, 11),
	[64121] = Position(33460, 32632, 10),
	[64122] = Position(33429, 32626, 10),
	[64123] = Position(33425, 32633, 8),
	[64124] = Position(33435, 32631, 8),
	[64125] = Position(33478, 32621, 10),
	[64126] = Position(33484, 32629, 8),
	[64127] = Position(33452, 32617, 11),
	[64128] = Position(33419, 32589, 10),
}

local teleportLadder = MoveEvent()

function teleportLadder.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetPosition = teleportPositions[item.actionid]
	if not targetPosition then
		return true
	end

	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(targetPosition)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

teleportLadder:type("stepin")

for index, value in pairs(teleportPositions) do
	teleportLadder:aid(index)
end

teleportLadder:register()
