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
