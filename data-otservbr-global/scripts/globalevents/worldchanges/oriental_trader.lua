local config = {
	enableSpawn = true,
	spawnChance = 33,

	[1] = {
		removeItems = {
			{ position = Position(33096, 32882, 6), itemId = 4977 },
			{ position = Position(33096, 32883, 6), itemId = 4977 },
			{ position = Position(33096, 32883, 6), itemId = 4920 },
			{ position = Position(33096, 32884, 6), itemId = 4920 },
			{ position = Position(33096, 32885, 6), itemId = 4920 },
		},

		yasirPosition = Position(33102, 32884, 6),
		mapName = "Ankrahmun",
	},

	[2] = {
		yasirPosition = Position(32400, 31815, 6),
		mapName = "Carlin",
	},

	[3] = {
		yasirPosition = Position(32314, 32895, 6),
		mapName = "Liberty Bay",
	},
}

local function yasirwebhook(message)
	Webhook.sendMessage(":man_wearing_turban_tone4: " .. message, announcementChannels["serverAnnouncements"])
end

local function spawnYasir(position)
	local npc = Game.createNpc("yasir", position)
	if npc then
		npc:setMasterPos(position)
	end
end

local orientalTrader = GlobalEvent("Oriental Trader")

function orientalTrader.onStartup()
	if config.enableSpawn and math.random(100) <= config.spawnChance then
		local randTown = config[math.random(#config)]
		logger.info("[World Change] Yasir has arrived in {} today!", randTown.mapName)

		if randTown.removeItems then
			local item
			for i = 1, #randTown.removeItems do
				local tile = Tile(randTown.removeItems[i].position)
				if tile then
					item = tile:getItemById(randTown.removeItems[i].itemId)
				end

				if item then
					item:remove()
				end
			end
		end

		local mapName = string.removeAllSpaces(randTown.mapName):lower()
		Game.loadMap(DATA_DIRECTORY .. "/world/world_changes/oriental_trader/" .. mapName .. ".otbm")

		local message = string.format("[World Change] Yasir has arrived in %s today!", randTown.mapName)
		addEvent(yasirwebhook, 60000, message)
		addEvent(spawnYasir, 60000, randTown.yasirPosition)

		Game.setStorageValue(GlobalStorage.Yasir, 1)
	else
		logger.info("Yasir: not this time")
		local message = "Yasir: not spawned today"
		addEvent(yasirwebhook, 60000, message)

		Game.setStorageValue(GlobalStorage.Yasir, -1)
	end
end

orientalTrader:register()
