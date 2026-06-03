local fugueSpawn = MoveEvent()

local spawnAreaMin = Position(32358, 32465, 2)
local spawnAreaMax = Position(32398, 32485, 2)

local triggerTiles = {
	Position(32375, 32480, 2),
	Position(32378, 32481, 2),
}

local TWENTY_HOURS = 20 * 60 * 60

local function fugueAlreadyExists()
	for x = spawnAreaMin.x, spawnAreaMax.x do
		for y = spawnAreaMin.y, spawnAreaMax.y do
			local pos = Position(x, y, spawnAreaMin.z)
			local tile = Tile(pos)
			if tile then
				for _, creature in ipairs(tile:getCreatures()) do
					if creature:getName():lower() == "fugue" then
						return true
					end
				end
			end
		end
	end
	return false
end

function fugueSpawn.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.KesarMission) ~= 2 then
		return true
	end

	if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.FugueSpawned) == 1 then
		return true
	end

	local lastSpawn = player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.FugueSpawnTime)
	if lastSpawn > 0 and (os.time() - lastSpawn) < TWENTY_HOURS then
		return true
	end

	if fugueAlreadyExists() then
		player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.FugueSpawned, 1)
		player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.FugueSpawnTime, os.time())
		return true
	end

	local fuguePos = Position(32371, 32476, 2)
	local warlockPositions = {
		Position(32372, 32477, 2),
		Position(32373, 32476, 2),
		Position(32371, 32477, 2),
		Position(32370, 32476, 2),
		Position(32372, 32478, 2),
	}

	Game.createMonster("Fugue", fuguePos)
	fuguePos:sendMagicEffect(CONST_ME_TELEPORT)

	for _, wpos in ipairs(warlockPositions) do
		Game.createMonster("Usurper Warlock", wpos)
		wpos:sendMagicEffect(CONST_ME_TELEPORT)
	end

	player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.FugueSpawned, 1)
	player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.FugueSpawnTime, os.time())

	return true
end

for _, pos in ipairs(triggerTiles) do
	fugueSpawn:position(pos)
end

fugueSpawn:register()
