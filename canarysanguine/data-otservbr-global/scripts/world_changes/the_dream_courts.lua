local dreamCourtsConfig = {
	["Monday"] = { map = "plagueroot", bossName = "Plagueroot" },
	["Tuesday"] = { map = "malofur_mangrinder", bossName = "Malofur Mangrinder" },
	["Wednesday"] = { map = "maxxenius", bossName = "Maxxenius" },
	["Thursday"] = { map = "alptramun", bossName = "Alptramun" },
	["Friday"] = { map = "izcandar_the_banished", bossName = "Izcandar the Banished" },
	["Saturday"] = { map = "maxxenius", bossName = "Maxxenius" },
	["Sunday"] = { map = "alptramun", bossName = "Alptramun" },
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
