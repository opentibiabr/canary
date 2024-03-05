local config = {
	distanceBetweenPositionsX = 8,
	distanceBetweenPositionsY = 8,
	addEventDelay = 100,
	teleportsPerEvent = 10,
	maxEventExecutionTime = 1000,
}

local function isTileValidForTeleport(tile)
	return tile and tile:getGround() and not tile:hasFlag(TILESTATE_TELEPORT)
end

local function teleportToValidPosition(player, x, y, z)
	local tile = Tile(x, y, z)
	if not tile or not isTileValidForTeleport(tile) or not player:teleportTo(tile:getPosition()) then
		for distance = 1, 3 do
			for changeX = -distance, distance, distance do
				for changeY = -distance, distance, distance do
					local checkX, checkY = x + changeX, y + changeY
					if checkX >= 0 and checkY >= 0 then
						tile = Tile(checkX, checkY, z)
						if tile and isTileValidForTeleport(tile) and player:teleportTo(tile:getPosition()) then
							return true
						end
					end
				end
			end
		end
		return false
	end
	return true
end

local function sendScanProgress(player, minX, maxX, minY, maxY, x, y, z, lastProgress)
	local progress = math.floor(((y - minY + (((x - minX) / (maxX - minX)) * config.distanceBetweenPositionsY)) / (maxY - minY)) * 100)
	if progress ~= lastProgress then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Scan progress: " .. progress .. "%")
	end
	return progress
end

local function minimapScan(cid, minX, maxX, minY, maxY, x, y, z, lastProgress)
	local player = Player(cid)
	if not player then
		return false
	end

	local startTimeCheck = os.time()
	local teleportsDone = 0

	while true do
		if startTimeCheck + config.maxEventExecutionTime < startTimeCheck then
			lastProgress = sendScanProgress(player, minX, maxX, minY, maxY, x, y, z, lastProgress)
			addEvent(minimapScan, config.addEventDelay, cid, minX, maxX, minY, maxY, x, y, z, lastProgress)
			break
		end

		x = x + config.distanceBetweenPositionsX
		if x > maxX then
			x, y = minX, y + config.distanceBetweenPositionsY

			if y > maxY then
				player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Scan finished: " .. startTimeCheck)
				break
			end
		end

		if teleportToValidPosition(player, x, y, z) then
			teleportsDone = teleportsDone + 1
			lastProgress = sendScanProgress(player, minX, maxX, minY, maxY, x, y, z, lastProgress)

			if teleportsDone == config.teleportsPerEvent then
				addEvent(minimapScan, config.addEventDelay, cid, minX, maxX, minY, maxY, x, y, z, progress)
				break
			end
		end
	end
end

local function minimapStart(player, minX, maxX, minY, maxY, x, y, z)
	player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Scan started: " .. os.time())
	minimapScan(player:getId(), minX, maxX, minY, maxY, minX - config.distanceBetweenPositionsX, minY, z)
end

local talk = TalkAction("/minimap")

function talk.onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	local positions = param:split(",")
	if #positions ~= 5 then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Command requires 5 parameters: /minimap minX, maxX, minY, maxY, z")
		return true
	end

	for key, position in pairs(positions) do
		local value = tonumber(position)

		if not value then
			player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Invalid parameter " .. key .. ": " .. position)
			return true
		end

		positions[key] = value
	end

	minimapStart(player, positions[1], positions[2], positions[3], positions[4], positions[1] - config.distanceBetweenPositionsX, positions[3], positions[5])
	return false
end

talk:separator(" ")
talk:groupType("god")
talk:register()
