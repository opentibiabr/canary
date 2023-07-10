local raids = {
	-- Weekly
	--Segunda-Feira
	['Monday'] = {
		['06:00'] = {raidName = 'RatsThais'},
	},

	--Terça-Feira
	['Tuesday'] = {
		['16:00'] = {raidName = 'Midnight Panther'}
	},

	--Quarta-Feira
	['Wednesday'] = {
		['12:00'] = {raidName = 'Draptor'}
	},

	--Quinta-Feira
	['Thursday'] = {
		['19:00'] = {raidName = 'Undead Cavebear'}
	},

	--Sexta-feira
	['Friday'] = {
		['06:00'] = {raidName = 'Titanica'}
	},

	--Sábado
	['Saturday'] = {
		['20:00'] = {raidName = 'Draptor'}
	},

	--Domingo
	['Sunday'] = {
		['15:00'] = {raidName = 'Midnight Panther'},
		['13:00'] = {raidName = 'Orc Backpack'}
	},

	-- By date (Day/Month)
	['31/10'] = {
		['16:00'] = {raidName = 'Halloween Hare'}
	}
}

local spawnRaids = GlobalEvent("spawn raids")
function spawnRaids.onThink(interval, lastExecution, thinkInterval)
	local day, date = os.date('%A'), getRealDate()

	local raidDays = {}
	if raids[day] then
		raidDays[#raidDays + 1] = raids[day]
	end
	if raids[date] then
		raidDays[#raidDays + 1] = raids[date]
	end
	if #raidDays == 0 then
		return true
	end

	for i = 1, #raidDays do
		local settings = raidDays[i][getRealTime()]
		if settings and not settings.alreadyExecuted then
			Game.startRaid(settings.raidName)
			settings.alreadyExecuted = true
		end
	end
	return true
end

spawnRaids:interval(60000)
spawnRaids:register()
