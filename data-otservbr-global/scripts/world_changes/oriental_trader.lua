local config = {
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

local function removeItems(removeItems)
	for _, removeItem in pairs(removeItems) do
		local tile = Tile(removeItem.position)
		if tile then
			local item = tile:getItemById(removeItem.itemId)
			if item then
				item:remove()
			end
		end
	end
end

local function spawnYasir(position)
	local npc = Game.createNpc("yasir", position)
	if npc then
		npc:setMasterPos(position)
	end
end

local orientalTrader = GlobalEvent("Oriental Trader")

function orientalTrader.onStartup()
	local randTown = config[math.random(#config)]
	logger.info("[World Change] Yasir has arrived in {} today!", randTown.mapName)

	if randTown.removeItems then
		removeItems(randTown.removeItems) -- Use the function to remove items
	end

	local mapName = string.removeAllSpaces(randTown.mapName):lower()
	Game.loadMap(DATA_DIRECTORY .. "/world/world_changes/oriental_trader/" .. mapName .. ".otbm")

	local message = string.format("[World Change] Yasir has arrived in %s today!", randTown.mapName)
	addEvent(yasirwebhook, 60000, message)
	addEvent(spawnYasir, 60000, randTown.yasirPosition)

	Game.setStorageValue(GlobalStorage.Yasir, 1)
end

orientalTrader:register()
