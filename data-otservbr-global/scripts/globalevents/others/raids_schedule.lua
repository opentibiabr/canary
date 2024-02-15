local raidSchedule = {
	["Tuesday"] = {
		["16:00"] = { raidName = "Midnight Panther" },
	},
	["Wednesday"] = {
		["12:00"] = { raidName = "Draptor" },
	},
	["Thursday"] = {
		["19:00"] = { raidName = "Undead Cavebear" },
	},
	["Friday"] = {
		["06:00"] = { raidName = "Titanica" },
	},
	["Saturday"] = {
		["20:00"] = { raidName = "Draptor" },
	},
	["Sunday"] = {
		["15:00"] = { raidName = "Midnight Panther" },
		["13:00"] = { raidName = "Orc Backpack" },
	},
	["31/10"] = {
		["16:00"] = { raidName = "Halloween Hare" },
	},
}

local spawnRaidsEvent = GlobalEvent("SpawnRaidsEvent")

function spawnRaidsEvent.onThink(interval, lastExecution, thinkInterval)
	local currentDayOfWeek, currentDate = os.date("%A"), getRealDate()
	local raidsToSpawn = {}

	if raidSchedule[currentDayOfWeek] then
		raidsToSpawn[#raidsToSpawn + 1] = raidSchedule[currentDayOfWeek]
	end

	if raidSchedule[currentDate] then
		raidsToSpawn[#raidsToSpawn + 1] = raidSchedule[currentDate]
	end

	if #raidsToSpawn > 0 then
		for i = 1, #raidsToSpawn do
			local currentRaidSchedule = raidsToSpawn[i][getRealTime()]
			if currentRaidSchedule and not currentRaidSchedule.alreadyExecuted then
				Game.startRaid(currentRaidSchedule.raidName)
				currentRaidSchedule.alreadyExecuted = true
			end
		end
	end
	return true
end

spawnRaidsEvent:interval(60000)
spawnRaidsEvent:register()
