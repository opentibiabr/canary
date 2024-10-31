local config = {
	['Monday'] = 'Alptramun',
	['Tuesday'] = 'Izcandar_the_Banished',
	['Friday'] = 'Malofur_Mangrinder',
	['Thursday'] = 'Maxxenius',
	['Wednesday'] = 'Malofur_Mangrinder',
	['Saturday'] = 'Plagueroot',
	['Sunday'] = 'Maxxenius'
}


local spawnByDay = true

local globalevents_dream_courts_worldchange = GlobalEvent("startupCourts")

function globalevents_dream_courts_worldchange.onStartup(interval)
	if spawnByDay then
		print('>> [dream courts] loaded: ' .. config[os.date("%A")])
		Game.loadMap('data/world/worldchanges/dream_courts_bosses/' .. config[os.date("%A")] ..'.otbm')
	else
		 print('>> dream courts boss: not boss today')
	end
	return true
end

globalevents_dream_courts_worldchange:register()

local globalevents_dream_courts_worldchange = GlobalEvent("fixCourts")

function globalevents_dream_courts_worldchange.onTime(interval)
	if spawnByDay then
		print('>> [dream courts] loaded: ' .. config[os.date("%A")])
		Game.loadMap('data/world/worldchanges/dream_courts_bosses/' .. config[os.date("%A")] ..'.otbm')
	else
		 print('>> dream courts boss: not boss today')
	end

	return true
end

globalevents_dream_courts_worldchange:time("00:00")
globalevents_dream_courts_worldchange:register()