local function updateWaterPoolsSize()
	for _, pos in ipairs(SoulWarQuest.ebbAndFlow.poolPositions) do
		local tile = Tile(pos)
		if tile then
			local item = tile:getItemById(SoulWarQuest.ebbAndFlow.smallPoolId)
			if item then
				item:transform(SoulWarQuest.ebbAndFlow.MediumPoolId)
				-- Starts another timer for filling after an additional 40 seconds
				addEvent(function()
					local item = tile:getItemById(SoulWarQuest.ebbAndFlow.MediumPoolId)
					if item then
						item:transform(SoulWarQuest.ebbAndFlow.smallPoolId)
					end
				end, 40000) -- 40 seconds
			end
		end
	end
end

local function loadMapEmpty()
	if SoulWarQuest.ebbAndFlow.getZone():countPlayers() > 0 then
		local players = SoulWarQuest.ebbAndFlow.getZone():getPlayers()
		for _, player in ipairs(players) do
			if player:getPosition().z == 8 then
				if player:isInBoatSpot() then
					local teleportPosition = player:getPosition()
					teleportPosition.z = 9
					player:teleportTo(teleportPosition)
					logger.trace("Teleporting player to down.")
				end
				player:sendCreatureAppear()
			end
		end
	end

	Game.loadMap(SoulWarQuest.ebbAndFlow.mapsPath.empty)
	SoulWarQuest.ebbAndFlow.setLoadedEmptyMap(true)
	SoulWarQuest.ebbAndFlow.setActive(false)

	local updatePlayers = EventCallback("UpdatePlayersEmptyEbbFlowMap", true)
	function updatePlayers.mapOnLoad(mapPath)
		if mapPath ~= SoulWarQuest.ebbAndFlow.mapsPath.empty then
			return
		end

		SoulWarQuest.ebbAndFlow.updateZonePlayers()
	end

	updatePlayers:register()

	addEvent(function()
		-- Change the appearance of puddles to indicate the next filling
		updateWaterPoolsSize()
	end, 80000) -- 80 seconds
end

local function getDistance(pos1, pos2)
	return math.sqrt((pos1.x - pos2.x) ^ 2 + (pos1.y - pos2.y) ^ 2 + (pos1.z - pos2.z) ^ 2)
end

local function findNearestRoomPosition(playerPosition)
	local nearestPosition = nil
	local smallestDistance = nil
	for _, room in ipairs(SoulWarQuest.ebbAndFlow.centerRoomPositions) do
		local distance = getDistance(playerPosition, room.conor)
		if not smallestDistance or distance < smallestDistance then
			smallestDistance = distance
			nearestPosition = room.teleportPosition
		end
	end
	return nearestPosition
end

local function loadMapInundate()
	if SoulWarQuest.ebbAndFlow.getZone():countPlayers() > 0 then
		local players = SoulWarQuest.ebbAndFlow.getZone():getPlayers()
		for _, player in ipairs(players) do
			local playerPosition = player:getPosition()
			if playerPosition.z == 9 then
				if player:isInBoatSpot() then
					local nearestCenterPosition = findNearestRoomPosition(playerPosition)
					player:teleportTo(nearestCenterPosition)
					logger.trace("Teleporting player to the near center position room and updating tile.")
				else
					player:teleportTo(SoulWarQuest.ebbAndFlow.waitPosition)
					logger.trace("Teleporting player to wait position and updating tile.")
				end
				playerPosition:sendMagicEffect(CONST_ME_TELEPORT)
			end
			player:sendCreatureAppear()
		end
	end

	Game.loadMap(SoulWarQuest.ebbAndFlow.mapsPath.inundate)
	SoulWarQuest.ebbAndFlow.setLoadedEmptyMap(false)
	SoulWarQuest.ebbAndFlow.setActive(true)

	local updatePlayers = EventCallback("UpdatePlayersInundateEbbFlowMap", true)
	function updatePlayers.mapOnLoad(mapPath)
		if mapPath ~= SoulWarQuest.ebbAndFlow.mapsPath.inundate then
			return
		end

		SoulWarQuest.ebbAndFlow.updateZonePlayers()
	end

	updatePlayers:register()
end

local loadEmptyMap = GlobalEvent("SoulWarQuest.ebbAndFlow")

function loadEmptyMap.onStartup()
	Game.loadMap(SoulWarQuest.ebbAndFlow.mapsPath.ebbFlow)
	loadMapEmpty()
	SoulWarQuest.ebbAndFlow.updateZonePlayers()
end

loadEmptyMap:register()

local eddAndFlowInundate = GlobalEvent("eddAndFlowInundate")

function eddAndFlowInundate.onThink(interval, lastExecution)
	if SoulWarQuest.ebbAndFlow.isLoadedEmptyMap() then
		logger.trace("Map change to empty in {} minutes.", SoulWarQuest.ebbAndFlow.intervalChangeMap)
		loadMapInundate()
	elseif SoulWarQuest.ebbAndFlow.isActive() then
		logger.trace("Map change to inundate in {} minutes.", SoulWarQuest.ebbAndFlow.intervalChangeMap)
		loadMapEmpty()
	end

	return true
end

eddAndFlowInundate:interval(SoulWarQuest.ebbAndFlow.intervalChangeMap * 60 * 1000)
eddAndFlowInundate:register()
