local spawnAreaPalomino = {
	from = Position(32438, 32231, 7),
	to = Position(32442, 32238, 7),
}

local spawnAreaAppaloosa = {
	from = Position(32846, 32114, 7),
	to = Position(32850, 32120, 7),
}

local RAID_STORAGE = 120226

local function spawnPalominoHorses()
	if Game.getStorageValue(RAID_STORAGE) > os.time() then
		return
	end

	local horsesToSpawn = {
		{ name = "Horse", amount = 3 },
		{ name = "Grey Horse", amount = 1 },
		{ name = "Brown Horse", amount = 2 },
	}

	for _, horseInfo in ipairs(horsesToSpawn) do
		for i = 1, horseInfo.amount do
			local x = math.random(spawnAreaPalomino.from.x, spawnAreaPalomino.to.x)
			local y = math.random(spawnAreaPalomino.from.y, spawnAreaPalomino.to.y)
			local spawnPos = Position(x, y, spawnAreaPalomino.from.z)
			Game.createMonster(horseInfo.name, spawnPos, true, true)
		end
	end
end

local function spawnAppaloosaHorses()
	if Game.getStorageValue(RAID_STORAGE) > os.time() then
		return
	end

	local horsesToSpawn = {
		{ name = "Horse", amount = 1 },
		{ name = "Grey Horse", amount = 1 },
		{ name = "Brown Horse", amount = 1 },
	}

	for _, horseInfo in ipairs(horsesToSpawn) do
		for i = 1, horseInfo.amount do
			local x = math.random(spawnAreaAppaloosa.from.x, spawnAreaAppaloosa.to.x)
			local y = math.random(spawnAreaAppaloosa.from.y, spawnAreaAppaloosa.to.y)
			local spawnPos = Position(x, y, spawnAreaAppaloosa.from.z)
			Game.createMonster(horseInfo.name, spawnPos, true, true)
		end
	end
end

local horseStartup = GlobalEvent("HorseStartup")
function horseStartup.onStartup()
	spawnPalominoHorses()
	spawnAppaloosaHorses()
	return true
end

horseStartup:register()
