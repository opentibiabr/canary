local config = {
	enableSpawn = true,
	spawnChance = 33,
	towns = {
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
	local message = "Yasir: not spawned today"

	if config.enableSpawn and math.random(100) <= config.spawnChance then
		local randTown = config.towns[math.random(#config.towns)]
		if not randTown then
			return false
		end

		if randTown.removeItems then
			for i = 1, #randTown.removeItems do
				local tile = Tile(randTown.removeItems[i].position)
				if tile then
					local item = tile:getItemById(randTown.removeItems[i].itemId)
					if item then
						item:remove()
					end
				end
			end
		end

		local mapName = string.removeAllSpaces(randTown.mapName):lower()
		Game.loadMap(DATA_DIRECTORY .. "/world/world_changes/oriental_trader/" .. mapName .. ".otbm")

		message = string.format("[World Change] Yasir has arrived in %s today!", randTown.mapName)
		addEvent(spawnYasir, 60000, randTown.yasirPosition)

		logger.info(message)
		Game.setStorageValue(GlobalStorage.Yasir, 1)
	else
		logger.info("Yasir: not this time")
		Game.setStorageValue(GlobalStorage.Yasir, -1)
	end
	addEvent(yasirwebhook, 60000, message)
end

orientalTrader:register()
