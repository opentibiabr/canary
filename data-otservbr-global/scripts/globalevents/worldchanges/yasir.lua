local config = {
	-- Ankrahmun
	[1] = {
		removeItems = {
			{position = Position(33096, 32882, 6), itemId = 4977},
			{position = Position(33096, 32883, 6), itemId = 4977},
			{position = Position(33096, 32883, 6), itemId = 4920},
			{position = Position(33096, 32884, 6), itemId = 4920},
			{position = Position(33096, 32885, 6), itemId = 4920},
			{position = Position(33097, 32883, 6), itemId = 4976}
		},
		fromPosition = Position(33099, 32875, 7),
		toPosition = Position(33106, 32893, 7),
		mapName = 'ankrahmun',
		yasirPosition = Position(33102, 32884, 6)
	},
	-- Carlin
	[2] = {
		removeItems = {
			{position = Position(32393, 31814, 6), itemId = 9491},
			{position = Position(32393, 31815, 6), itemId = 9491},
			{position = Position(32393, 31816, 6), itemId = 9491}
		},
		fromPosition = Position(32397, 31806, 7),
		toPosition = Position(32403, 31824, 7),
		mapName = 'carlin',
		yasirPosition = Position(32400, 31815, 6)
	},
	-- Liberty Bay
	[3] = {
		removeItems = {
			{position = Position(32309, 32896, 6), itemId = 2279},
			{position = Position(32309, 32895, 6), itemId = 2279},
			{position = Position(32309, 32894, 6), itemId = 2279},
			{position = Position(32309, 32893, 6), itemId = 2279},
			{position = Position(32309, 32896, 6), itemId = 2257},
			{position = Position(32309, 32895, 6), itemId = 2257},
			{position = Position(32309, 32894, 6), itemId = 2257},
			{position = Position(32309, 32893, 6), itemId = 2257}
		},
		fromPosition = Position(32311, 32884, 1),
		toPosition = Position(32318, 32904, 7),
		mapName = 'libertybay',
		yasirPosition = Position(32314, 32895, 6)
	}
}

local function yasirwebhook(message) -- New local function that runs on delay to send webhook message.
	Webhook.send("[Yasir] ", message, WEBHOOK_COLOR_ONLINE) --Sends webhook message
end

local yasirEnabled = true
local yasirChance = 33

local function spawnYasir(position)
	local npc = Game.createNpc('yasir', position)
	if npc then
		npc:setMasterPos(position)
	end
end

local yasir = GlobalEvent("yasir")

function yasir.onStartup()
	if yasirEnabled then
		if math.random(100) <= yasirChance then
			local randTown = config[math.random(#config)]
			Spdlog.info(string.format("[WorldChanges] Yasir: %s", randTown.mapName))
			local message = string.format("Yasir is in %s today.", randTown.mapName) -- Declaring the message to send to webhook.
			iterateArea(
			function(position)
				local tile = Tile(position)
				if tile then
					local items = tile:getItems()
					if items then
						for i = 1, #items do
							items[i]:remove()
						end
					end

					local ground = tile:getGround()
					if ground then
						ground:remove()
					end
				end
			end,
			randTown.fromPosition,
			randTown.toPosition
			)

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

			Game.loadMap(DATA_DIRECTORY.. '/world/world_changes/oriental_trader/' .. randTown.mapName .. '.otbm')
			addEvent(spawnYasir, 5000, randTown.yasirPosition)
			addEvent(yasirwebhook, 60000, message) -- Event with 1 minute delay to send webhook message after server starts.
			setGlobalStorageValue(GlobalStorage.Yasir, 1)
		else
			Spdlog.info("Yasir: not this time")
			local message = "Yasir: not spawned today" -- Declaring the message to send to webhook.
			addEvent(yasirwebhook, 60000, message) -- Event with 1 minute delay to send webhook message after server starts.
			setGlobalStorageValue(GlobalStorage.Yasir, 0)
		end
	end
end

yasir:register()
