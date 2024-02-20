function Game.broadcastMessage(message, messageType)
	if not messageType then
		messageType = MESSAGE_GAME_HIGHLIGHT
	end

	for _, player in ipairs(Game.getPlayers()) do
		player:sendTextMessage(messageType, message)
	end
end

function Game.convertIpToString(ip)
	local band = bit.band
	local rshift = bit.rshift
	return string.format("%d.%d.%d.%d", band(ip, 0xFF), band(rshift(ip, 8), 0xFF), band(rshift(ip, 16), 0xFF), rshift(ip, 24))
end

function Game.getHouseByPlayerGUID(playerGUID)
	local houses, house = Game.getHouses()
	for i = 1, #houses do
		house = houses[i]
		if house:getOwnerGuid() == playerGUID then
			return house
		end
	end
	return nil
end

function Game.getPlayersByIPAddress(ip, mask)
	if not mask then
		mask = 0xFFFFFFFF
	end
	local masked = bit.band(ip, mask)
	local result = {}
	local players, player = Game.getPlayers()
	for i = 1, #players do
		player = players[i]
		if bit.band(player:getIp(), mask) == masked then
			result[#result + 1] = player
		end
	end
	return result
end

function Game.getReverseDirection(direction)
	if direction == WEST then
		return EAST
	elseif direction == EAST then
		return WEST
	elseif direction == NORTH then
		return SOUTH
	elseif direction == SOUTH then
		return NORTH
	elseif direction == NORTHWEST then
		return SOUTHEAST
	elseif direction == NORTHEAST then
		return SOUTHWEST
	elseif direction == SOUTHWEST then
		return NORTHEAST
	elseif direction == SOUTHEAST then
		return NORTHWEST
	end
	return NORTH
end

function Game.getSkillType(weaponType)
	if weaponType == WEAPON_CLUB then
		return SKILL_CLUB
	elseif weaponType == WEAPON_SWORD then
		return SKILL_SWORD
	elseif weaponType == WEAPON_AXE then
		return SKILL_AXE
	elseif weaponType == WEAPON_DISTANCE or weaponType == WEAPON_MISSILE then
		return SKILL_DISTANCE
	elseif weaponType == WEAPON_SHIELD then
		return SKILL_SHIELD
	end
	return SKILL_FIST
end

if not globalStorageTable then
	globalStorageTable = {}
end

function Game.getStorageValue(key)
	if type(globalStorageTable) == "table" and key ~= nil then
		return globalStorageTable[key] or -1
	else
		logger.error("[Game.getStorageValue] Invalid table or key: {}", key)
		return -1
	end
end

function Game.setStorageValue(key, value)
	if type(globalStorageTable) == "table" and key ~= nil then
		if value == -1 then
			globalStorageTable[key] = nil
		else
			globalStorageTable[key] = value
		end
	else
		logger.error("[Game.setStorageValue] Invalid table or key: {}", key)
	end
end

function Game.getGlobalValue(key)
	local keyNumber = tonumber(key)
	if not keyNumber then
		key = "'" .. key .. "'"
	end

	local result = db.storeQuery("SELECT `value` FROM `global_storage` WHERE `key` = " .. key)
	if result then
		local value = tonumber(result:getDataInt("value")) or result:getDataString("value")
		result:free()
		return value
	else
		logger.error("[Game.getGlobalValue] Unable to retrieve value for key: {}", key)
		return -1
	end
end

function Game.setGlobalValue(key, value)
	local keyNumber = tonumber(key)
	if not keyNumber then
		key = "'" .. key .. "'"
	end

	local valueNumber = tonumber(value)
	if not valueNumber then
		value = "'" .. value .. "'"
	end

	local query = db.query("INSERT INTO `global_storage` (`key`, `value`) VALUES (" .. key .. ", " .. value .. ") ON DUPLICATE KEY UPDATE `value` = " .. value)
	if not query then
		logger.error("[Game.setGlobalValue] Unable to set value for key {}", key)
	end
end
