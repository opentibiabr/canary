local dreamCourtsConfig = {
	["Monday"] = { map = "alptramun", bossName = "Alptramun" },
	["Tuesday"] = { map = "izcandar_the_banished", bossName = "Izcandar the Banished" },
	["Wednesday"] = { map = "malofur_mangrinder", bossName = "Malofur Mangrinder" },
	["Thursday"] = { map = "maxxenius", bossName = "Maxxenius" },
	["Friday"] = { map = "izcandar_the_banished", bossName = "Izcandar the Banished" },
	["Saturday"] = { map = "plagueroot", bossName = "Plagueroot" },
	["Sunday"] = { map = "maxxenius", bossName = "Maxxenius" },
}

local dreamCourtsEvent = GlobalEvent("DreamCourts")

function dreamCourtsEvent.onStartup()
	local currentDay = os.date("%A")
	local dayConfig = dreamCourtsConfig[currentDay]
	if not dayConfig then
		logger.warn("[World Change] The Dream Courts map not defined for the current day: {}", currentDay)
		return false
	end

	Game.loadMap(DATA_DIRECTORY .. "/world/quest/the_dream_courts/" .. dayConfig.map .. ".otbm")
	logger.info("[World Change] The Dream Courts today's boss is: {}!", dayConfig.bossName)

	return true
end

dreamCourtsEvent:register()
