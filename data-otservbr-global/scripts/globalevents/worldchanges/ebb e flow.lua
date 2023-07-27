local config = {
    -- Starting position to where players will be teleported when the map is flooded and are not in raft
    waitPosition = Position(33893, 31020, 8),

    -- Time to change, default time is 2 minutes (120 * 1000)
    interval = (30 * 1000),

    -- Central basement position on the first floor to be used as a getSpectators reference
	positionFirstFloor = {fromPosition = Position(33873, 30994, 8), toPosition = Position(33961, 31149, 8), center = Position(33919, 31072, 8)},

    -- Basement positions on the second floor to be used as a getSpectators reference
	positionSecondFloor = {fromPosition = Position(33873, 30994, 9), toPosition = Position(33961, 31149, 9),center = Position(33919, 31072, 9)},

	boatPositionEmptyRoom = {
		{center = Position(33924, 31019, 9), rangeMinX = 1, rangeMaxX = 2, rangeMinY = 1, rangeMaxY = 2},
		{center = Position(33923, 31045, 9), rangeMinX = 2, rangeMaxX = 3, rangeMinY = 1, rangeMaxY = 2},
		{center = Position(33898, 31058, 9), rangeMinX = 3, rangeMaxX = 3, rangeMinY = 1, rangeMaxY = 2},
		{center = Position(33941, 31059, 9), rangeMinX = 2, rangeMaxX = 2, rangeMinY = 1, rangeMaxY = 2},		
		{center = Position(33938, 31091, 9), rangeMinX = 2, rangeMaxX = 3, rangeMinY = 2, rangeMaxY = 3},		
		{center = Position(33902, 31103, 9), rangeMinX = 2, rangeMaxX = 3, rangeMinY = 1, rangeMaxY = 2},		
		{center = Position(33917, 31113, 9), rangeMinX = 1, rangeMaxX = 1, rangeMinY = 1, rangeMaxY = 2},
		{center = Position(33939, 31108, 9), rangeMinX = 2, rangeMaxX = 3, rangeMinY = 2, rangeMaxY = 2}
	},

	boatPositionFloodedRoom = {
		{center = Position(33924, 31019, 8), rangeMinX = 1, rangeMaxX = 2, rangeMinY = 1, rangeMaxY = 2},
		{center = Position(33923, 31045, 8), rangeMinX = 2, rangeMaxX = 3, rangeMinY = 1, rangeMaxY = 2},
		{center = Position(33898, 31058, 8), rangeMinX = 3, rangeMaxX = 3, rangeMinY = 1, rangeMaxY = 2},
		{center = Position(33941, 31059, 8), rangeMinX = 2, rangeMaxX = 2, rangeMinY = 1, rangeMaxY = 2},		
		{center = Position(33938, 31091, 8), rangeMinX = 2, rangeMaxX = 3, rangeMinY = 2, rangeMaxY = 3},		
		{center = Position(33902, 31103, 8), rangeMinX = 2, rangeMaxX = 3, rangeMinY = 1, rangeMaxY = 2},		
		{center = Position(33917, 31113, 8), rangeMinX = 1, rangeMaxX = 1, rangeMinY = 1, rangeMaxY = 2},
		{center = Position(33939, 31108, 8), rangeMinX = 2, rangeMaxX = 3, rangeMinY = 2, rangeMaxY = 2}
	},

	safeSpots = {
		{center = Position(33893, 31020, 8), rangeMinX = 0, rangeMaxX = 0, rangeMinY = 0, rangeMaxY = 0} -- Onde o Player sera teleportado caso esteja fora da balsa ao encher.
	}
}

-- Função que vai iniciar o mapa vazio quando o servidor começar.
local EbbAndFlow = GlobalEvent("EbbAndFlow")
function EbbAndFlow.onStartup(interval)
	Game.loadMap('data-otservbr-global/world/quest/soul_war/ebb_and_flow/empty.otbm') -- localização do arquivo em sua datapack
	Game.setStorageValue(GlobalStorage.SoulWarQuest.EddAndFlow.Empty, 1)
	Game.setStorageValue(GlobalStorage.SoulWarQuest.EddAndFlow.Active, 0)
	return true
end

EbbAndFlow:register()

-- Funções de alteração do mapa.
local function loadMapEmpty()
	Game.loadMap('data-otservbr-global/world/quest/soul_war/ebb_and_flow/empty.otbm') -- localização do arquivo em sua datapack
end

local function loadMapInundate()
	Game.loadMap('data-otservbr-global/world/quest/soul_war/ebb_and_flow/inundate.otbm') -- localização do arquivo em sua datapack
end

local function playerInSafeSpot()
	for i = 1, #config.safeSpots do
		local safeSpot = config.safeSpots[i]
		local specs, spec = Game.getSpectators(safeSpot.center, false, true, safeSpot.rangeMinX, safeSpot.rangeMaxX, safeSpot.rangeMinX, safeSpot.rangeMaxY)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				return true
			end
		end
	end
end

local function playerInBoatEmptyRoom()
	for i = 1, #config.boatPositionEmptyRoom do
		local boat = config.boatPositionEmptyRoom[i]
		local specs, spec = Game.getSpectators(boat.center, false, true, boat.rangeMinX, boat.rangeMaxX, boat.rangeMinX, boat.rangeMaxY)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				local specPos = spec:getPosition()
				specPos = {x = specPos.x, y = specPos.y, z = specPos.z - 1}
				spec:teleportTo(specPos)
				return true
			else
				spec:remove()
				return true
			end
		end
	end
end

local function playerInBoatInundateRoom()
	for i = 1, #config.boatPositionFloodedRoom do
		local boat = config.boatPositionFloodedRoom[i]
		local specs, spec = Game.getSpectators(boat.center, false, true, boat.rangeMinX, boat.rangeMaxX, boat.rangeMinX, boat.rangeMaxY)
		for i = 1, #specs do
			spec = specs[i]
			if spec:isPlayer() then
				local specPos = spec:getPosition()
				specPos = {x = specPos.x, y = specPos.y, z = specPos.z + 1}
				spec:teleportTo(specPos)
				return true
			end
		end
	end
end

local function sendPlayerToStart()
	local specs, spec = Game.getSpectators(config.positionSecondFloor.center, false, false, 44, 44, 74, 74)
	for i = 1, #specs do
		spec = specs[i]
		if spec:isPlayer() then
			if playerInBoatEmptyRoom() or playerInBoatInundateRoom() or playerInSafeSpot() then
			else
				spec:teleportTo(config.waitPosition)
			end
		else
			spec:remove()
		end
	end
end

local function ChecksPlayersOnSecondFloor()
	local specs, spec = Game.getSpectators(config.positionSecondFloor.center, false, true, 44, 44, 74, 74)
	for i = 1, #specs do
		spec = specs[i]
		if spec:isPlayer() then
			return true
		end
	end
end

local function ChecksPlayersOnFirstFloor()
	local specs, spec = Game.getSpectators(config.positionFirstFloor.center, false, true, 44, 44, 74, 74)
	for i = 1, #specs do
		spec = specs[i]
		if spec:isPlayer() then
			return true
		end
	end
end

local function isWater(itemId) -- ids de oceano que irão preencher a parte superior ao inundar
	local water = {4597, 4598, 4599, 4600, 4601, 4602, 4609, 4610, 4611, 4612, 4613, 4614} -- ok
		for i = 1, #water do
			if itemId == water[i] then
				return true
			end
		end
	end

	local function isFloatRaft(itemId) -- ids da balsa com agua
		local raft = {7187, 7188, 7190, 7191, 7192, 7193, 7194, 7195, 7272} -- ok?
			for i = 1, #raft do
				if itemId == raft[i] then
					return true
				end
			end
		end

	local function floatingBorder(itemId) -- boarda do piso superior com agua
		local floatingBorder = {31171,31172,31173,31174,31175,31176,31177,31178,31179,31180,31181,31182, 11516, 11529, 11520, 11523, 11526, 11530, 11531, 11538, 11533, 11534, 11535} -- ok
		for i = 1, #floatingBorder do
			if itemId == floatingBorder[i] then
				return true
			end
		end
	end

	local function stoneBorder(itemId) -- borda do piso superior sem agua
		local stoneBorder = {19946,19949,19950,17477,19951,17478,17479,19947,19948,19953,19957,19952,19956,19954,19955} -- ok
		for i = 1, #stoneBorder do
			if itemId == stoneBorder[i] then
				return true
			end
		end
	end

-- Remoção de sqms do 1 andar ao alterar o mapa
local function reloadFirstFloor()
	for x = config.positionFirstFloor.fromPosition.x, config.positionFirstFloor.toPosition.x do
		for y = config.positionFirstFloor.fromPosition.y, config.positionFirstFloor.toPosition.y do
			for z = config.positionFirstFloor.fromPosition.z, config.positionFirstFloor.toPosition.z do
				local tile = Tile(Position(x, y, z))
				if not tile then
					break
				end
				local items = tile:getItems()
				if items then
					for i = 1, #items do
					local itemid = items[i]:getId()
						if floatingBorder(itemid) or stoneBorder(itemid) then
						items[i]:remove()
						end
					end
				end
				local ground = tile:getGround()
				if ground then
					if isWater(ground.itemid) or isFloatRaft(ground.itemid) then
						ground:remove()
					end
				end
			end
		end
	end
end

-- Config de sqms do 2 andar ao alterar o mapa
local function reloadSecondFloor()
		for x = config.positionSecondFloor.fromPosition.x, config.positionSecondFloor.toPosition.x do
			for y = config.positionSecondFloor.fromPosition.y, config.positionSecondFloor.toPosition.y do
				for z = config.positionSecondFloor.fromPosition.z, config.positionSecondFloor.toPosition.z do
					local tile = Tile(Position(x, y, z))
					if not tile then
						break
					end
					local items = tile:getItems()
					if items then
						for i = 1, #items do
						local itemid = items[i]:getId()
                        local openDoor = 6254
                        local closedDoor = 6253
                        if itemid == openDoor then
                            items[i]:transform(closedDoor)
                        end
					end
				end
            end
		end
	end
end

local function reloadMap()
	-- Game.getStorageValue(GlobalStorage.SoulWarQuest.EddAndFlow.Empty)
		reloadFirstFloor()
		reloadSecondFloor()
end

-- Infos que serão levadas ao console quando ocorrer a troca de mapa - para fins de teste de evento/tempo
local eddAndFlowInundate = GlobalEvent("eddAndFlowInundate")
function eddAndFlowInundate.onThink(interval, lastExecution)
	 if ChecksPlayersOnSecondFloor() or ChecksPlayersOnFirstFloor() then
		Game.setStorageValue(GlobalStorage.SoulWarQuest.EddAndFlow.Active, 1)
		Spdlog.info('Ebb And Flow - Mapa Inundado')
	 else
		Game.setStorageValue(GlobalStorage.SoulWarQuest.EddAndFlow.Active, 0)
		Spdlog.info('Ebb And Flow - Mapa Vazio')
	 end
		if Game.getStorageValue(GlobalStorage.SoulWarQuest.EddAndFlow.Empty) <= 1 then
			-- Game.broadcastMessage('Map flooded in 2 minutes.', MESSAGE_EVENT_ADVANCE)
			addEvent(reloadMap, config.interval) -- Correct 120 * 1000
			addEvent(loadMapInundate, config.interval) -- Correct 120 * 1000
			addEvent(sendPlayerToStart, config.interval) -- Correct 120 * 1000
			Game.setStorageValue(GlobalStorage.SoulWarQuest.EddAndFlow.Empty, 2)
			Game.setStorageValue(GlobalStorage.SoulWarQuest.EddAndFlow.doors, -1)
			return true
		else
			-- Game.broadcastMessage('Map empty in 2 minutes.', MESSAGE_EVENT_ADVANCE)
			addEvent(reloadMap, config.interval) -- Correct 120 * 1000
			addEvent(loadMapEmpty, config.interval) -- Correct 120 * 1000
			addEvent(playerInBoatInundateRoom, config.interval) -- Correct 120 * 1000
			Game.setStorageValue(GlobalStorage.SoulWarQuest.EddAndFlow.Empty, 0)
			Game.setStorageValue(GlobalStorage.SoulWarQuest.EddAndFlow.doors, 1)
			return true
		end
	return true
end

eddAndFlowInundate:interval(config.interval)
eddAndFlowInundate:register()

local lockDoorInundate = Action()
function lockDoorInundate.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local inundateRoom = Game.getStorageValue(GlobalStorage.SoulWarQuest.EddAndFlow.doors)
	if inundateRoom ~= 1 then
		local door = item:getId()
		local openDoor = 6252 -- cid
		local closedDoor = 6253 -- cid
		if door == closedDoor then
			item:transform(openDoor)
			return true
		else
			item:transform(closedDoor)
			return true
		end
	else
		player:say("The door can't be opened. The other side is flooded.", TALKTYPE_MONSTER_SAY, false, player) -- Ciptibia
		return true
	end
	return true
end

lockDoorInundate:aid(26001)
lockDoorInundate:register()