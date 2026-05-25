local RAID_STORAGE = 120226
local waveEvent = nil

local spawnAreaPalomino = {
	from = Position(32438, 32231, 7),
	to = Position(32442, 32238, 7),
}

local spawnAreaAppaloosa = {
	from = Position(32846, 32114, 7),
	to = Position(32850, 32120, 7),
}

local function spawnPalominoHorses()
	local horsesToSpawn = {
		{ name = "Horse", amount = 3 },
		{ name = "Grey Horse", amount = 1 },
		{ name = "Brown Horse", amount = 2 },
	}

	for _, horseInfo in ipairs(horsesToSpawn) do
		for i = 1, horseInfo.amount do
			local spawnPos = Position(math.random(spawnAreaPalomino.from.x, spawnAreaPalomino.to.x), math.random(spawnAreaPalomino.from.y, spawnAreaPalomino.to.y), spawnAreaPalomino.from.z)
			Game.createMonster(horseInfo.name, spawnPos, true, true)
		end
	end
end

local function spawnAppaloosaHorses()
	local horsesToSpawn = {
		{ name = "Horse", amount = 1 },
		{ name = "Grey Horse", amount = 1 },
		{ name = "Brown Horse", amount = 1 },
	}

	for _, horseInfo in ipairs(horsesToSpawn) do
		for i = 1, horseInfo.amount do
			local spawnPos = Position(math.random(spawnAreaAppaloosa.from.x, spawnAreaAppaloosa.to.x), math.random(spawnAreaAppaloosa.from.y, spawnAreaAppaloosa.to.y), spawnAreaAppaloosa.from.z)
			Game.createMonster(horseInfo.name, spawnPos, true, true)
		end
	end
end

local horseStable = MoveEvent()

function horseStable.onStepIn(creature, item, position, fromPosition)
	if not creature:isMonster() then
		return true
	end

	if creature:getName() == "Horse" then
		creature:remove()
		local currentStorage = Game.getStorageValue(RAID_STORAGE) or 0
		if currentStorage > os.time() then
			if math.random(30) == 1 then
				Game.setStorageValue(RAID_STORAGE, 0)
				if waveEvent then
					stopEvent(waveEvent)
					waveEvent = nil
				end
				spawnPalominoHorses()
				spawnAppaloosaHorses()
				position:sendMagicEffect(CONST_ME_POFF)
			else
				position:sendMagicEffect(CONST_ME_POFF)
			end
		else
			position:sendMagicEffect(CONST_ME_POFF)
		end
	end
	return true
end

horseStable:type("stepin")
horseStable:id(31159)
horseStable:register()
