local raidSchedule = {
	["Monday"] = {
		["06:00"] = { raidName = "Titanica" },
		["10:00"] = { raidName = "Draptor" },
		["14:00"] = { raidName = "Midnight Panther" },
		["18:00"] = { raidName = "Undead Cavebear" },
		["22:00"] = { raidName = "Orc Backpack" },
	},
	["Tuesday"] = {
		["07:00"] = { raidName = "Titanica" },
		["11:00"] = { raidName = "Draptor" },
		["15:00"] = { raidName = "Midnight Panther" },
		["19:00"] = { raidName = "Undead Cavebear" },
		["23:00"] = { raidName = "Orc Backpack" },
	},
	["Wednesday"] = {
		["08:00"] = { raidName = "Titanica" },
		["12:00"] = { raidName = "Draptor" },
		["16:00"] = { raidName = "Midnight Panther" },
		["20:00"] = { raidName = "Undead Cavebear" },
	},
	["Thursday"] = {
		["09:00"] = { raidName = "Titanica" },
		["13:00"] = { raidName = "Draptor" },
		["17:00"] = { raidName = "Midnight Panther" },
		["21:00"] = { raidName = "Undead Cavebear" },
	},
	["Friday"] = {
		["06:30"] = { raidName = "Titanica" },
		["10:30"] = { raidName = "Draptor" },
		["14:30"] = { raidName = "Midnight Panther" },
		["18:30"] = { raidName = "Undead Cavebear" },
		["22:30"] = { raidName = "Orc Backpack" },
	},
	["Saturday"] = {
		["07:30"] = { raidName = "Titanica" },
		["11:30"] = { raidName = "Draptor" },
		["15:30"] = { raidName = "Midnight Panther" },
		["19:30"] = { raidName = "Undead Cavebear" },
		["23:30"] = { raidName = "Orc Backpack" },
	},
	["Sunday"] = {
		["08:30"] = { raidName = "Titanica" },
		["12:30"] = { raidName = "Draptor" },
		["16:30"] = { raidName = "Midnight Panther" },
		["20:30"] = { raidName = "Undead Cavebear" },
		["18:00"] = { raidName = "Orc Backpack" },
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
