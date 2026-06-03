local DRYADS_PER_WAVE = 25
local WAVE_INTERVAL = 15 * 60 * 1000
local ROSEMARIE_POS = { x = 32534, y = 32827, z = 7 }

local WAVES = {
	{
		message = "Dryads have returned to protect the forest north of Edron.",
		from = { x = 33166, y = 31694, z = 7 },
		to = { x = 33241, y = 31736, z = 7 },
	},
	{
		message = "Dryads have returned to protect the northern forests near Ab'Dendriel.",
		from = { x = 32414, y = 31691, z = 7 },
		to = { x = 32483, y = 31736, z = 7 },
	},
	{
		message = "Dryads have returned to protect the jungle of Tiquanda.",
		from = { x = 32755, y = 32739, z = 7 },
		to = { x = 32824, y = 32780, z = 7 },
	},
	{
		message = "Dryads have returned to protect their tree gardens underneath Cormaya.",
		from = { x = 33154, y = 31976, z = 11 },
		to = { x = 33283, y = 32066, z = 11 },
	},
}

local function spawnDryads(wave)
	Game.broadcastMessage(wave.message, MESSAGE_EVENT_ADVANCE)

	local spawned = 0
	local attempts = 0

	while spawned < DRYADS_PER_WAVE and attempts < DRYADS_PER_WAVE * 10 do
		local pos = {
			x = math.random(wave.from.x, wave.to.x),
			y = math.random(wave.from.y, wave.to.y),
			z = wave.from.z,
		}
		local tile = Tile(pos)
		if tile and tile:isWalkable() then
			Game.createMonster("Dryad", pos, false, true)
			spawned = spawned + 1
		end
		attempts = attempts + 1
	end
end

local function scheduleWave(index)
	spawnDryads(WAVES[index])
	local next = index < #WAVES and index + 1 or 1
	addEvent(function()
		scheduleWave(next)
	end, WAVE_INTERVAL)
end

local dryadRaid = GlobalEvent("FlowerMonth")

function dryadRaid.onStartup()
	local t = os.date("*t")
	local month = t.month

	if month == 6 then
		Game.createNpc("Rosemarie", ROSEMARIE_POS, true)
		scheduleWave(1)
		print(string.format("[%04d-%02d-%02d %02d:%02d:%02d.000] [info] [World Change] Flower Month event is active.", t.year, t.month, t.day, t.hour, t.min, t.sec))
	end

	return true
end

dryadRaid:register()
