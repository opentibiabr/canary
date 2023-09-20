local config = {
	["Monday"] = "Plagueroot",
	["Tuesday"] = "Malofur_Mangrinder",
	["Wednesday"] = "Maxxenius",
	["Thursday"] = "Alptramun",
	["Friday"] = "Izcandar_the_Banished",
	["Saturday"] = "Maxxenius",
	["Sunday"] = "Alptramun",
}
local spawnByDay = true

local DreamCourts = GlobalEvent("DreamCourts")
function DreamCourts.onStartup()
	if spawnByDay then
		logger.info("[WorldChanges] Dream Courts loaded: {}.otbm", config[os.date("%A")])
		Game.loadMap("data-otservbr-global/world/world_changes/dream_courts_bosses/" .. config[os.date("%A")] .. ".otbm")
	end
	return true
end

DreamCourts:register()
