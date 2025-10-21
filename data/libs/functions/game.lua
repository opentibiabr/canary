function getGlobalStorage(key)
	local keyNumber = tonumber(key)
	if not keyNumber then
		key = "'" .. key .. "'"
	end
	local resultId = db.storeQuery("SELECT `value` FROM `global_storage` WHERE `key` = " .. key)
	if resultId ~= false then
		local isNumber = tonumber(Result.getString(resultId, "value"))
		if isNumber then
			local val = Result.getNumber(resultId, "value")
			Result.free(resultId)
			return val
		else
			local val = Result.getString(resultId, "value")
			Result.free(resultId)
			return val
		end
	end
	return -1
end

function setGlobalStorage(key, value)
	local keyNumber = tonumber(key)
	if not keyNumber then
		key = "'" .. key .. "'"
	end
	local valueNumber = tonumber(value)
	if not valueNumber then
		value = "'" .. value .. "'"
	end
	db.query("INSERT INTO `global_storage` (`key`, `value`) VALUES (" .. key .. ", " .. value .. ") ON DUPLICATE KEY UPDATE `value` = " .. value)
end

function Game.broadcastMessage(message, messageType)
	if not messageType then
		messageType = MESSAGE_GAME_HIGHLIGHT
	end

	for _, player in ipairs(Game.getPlayers()) do
		player:sendTextMessage(messageType, message)
	end
end

local bit_band = bit.band
local bit_rshift = bit.rshift
local bit_lshift = bit.lshift
local bit_bor = bit.bor

local function normalizeIPv6MappedIPv4(ip)
        if type(ip) ~= "string" then
                return ip
        end

        local mapped = ip:match("^::ffff:(%d+%.%d+%.%d+%.%d+)$")
        if mapped then
                return mapped
        end

        return ip
end

local function ipv4StringToNumber(ip)
        if type(ip) ~= "string" then
                return nil
        end

        local a, b, c, d = ip:match("^(%d+)%.(%d+)%.(%d+)%.(%d+)$")
	if not a then
		return nil
	end

	a, b, c, d = tonumber(a), tonumber(b), tonumber(c), tonumber(d)
	if not a or a > 255 or not b or b > 255 or not c or c > 255 or not d or d > 255 then
		return nil
	end

	return bit_bor(a, bit_lshift(b, 8), bit_lshift(c, 16), bit_lshift(d, 24))
end

function Game.convertIpToString(ip)
	if type(ip) == "string" then
		return ip
	end

	if type(ip) ~= "number" then
		return "unknown"
	end

	return string.format("%d.%d.%d.%d", bit_band(ip, 0xFF), bit_band(bit_rshift(ip, 8), 0xFF), bit_band(bit_rshift(ip, 16), 0xFF), bit_rshift(ip, 24))
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
        mask = mask or 0xFFFFFFFF

        local players = Game.getPlayers()
        local result = {}

        local targetNumber
        if type(ip) == "number" then
                targetNumber = ip
        else
                local normalizedIp = normalizeIPv6MappedIPv4(ip)
                targetNumber = ipv4StringToNumber(normalizedIp)
                ip = normalizedIp
        end

        if targetNumber then
                local masked = bit_band(targetNumber, mask)
                for i = 1, #players do
                        local player = players[i]
                        local playerIp = player:getIp()
                        if type(playerIp) == "string" then
                                playerIp = normalizeIPv6MappedIPv4(playerIp)
                        end

                        local playerNumber = type(playerIp) == "number" and playerIp or ipv4StringToNumber(playerIp)
                        if playerNumber and bit_band(playerNumber, mask) == masked then
                                result[#result + 1] = player
                        end
                end
                return result
        end

        if type(ip) == "string" then
                for i = 1, #players do
                        local player = players[i]
                        local playerIp = player:getIp()
                        if normalizeIPv6MappedIPv4(playerIp) == ip then
                                result[#result + 1] = player
                        end
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
	return globalStorageTable[key] or -1
end

function Game.setStorageValue(key, value)
	if key == nil then
		logger.error("[Game.setStorageValue] Key is nil")
		return
	end

	if value == -1 then
		if globalStorageTable[key] then
			globalStorageTable[key] = nil
		end
		return
	end

	globalStorageTable[key] = value
end

function Game.getTimeInWords(seconds)
	local days = math.floor(seconds / (24 * 3600))
	seconds = seconds % (24 * 3600)
	local hours = math.floor(seconds / 3600)
	seconds = seconds % 3600
	local minutes = math.floor(seconds / 60)
	seconds = seconds % 60

	local timeParts = {}

	if days > 0 then
		table.insert(timeParts, days .. (days > 1 and " days" or " day"))
	end

	if hours > 0 then
		table.insert(timeParts, hours .. (hours > 1 and " hours" or " hour"))
	end

	if minutes > 0 then
		table.insert(timeParts, minutes .. (minutes > 1 and " minutes" or " minute"))
	end

	if seconds > 0 or #timeParts == 0 then
		table.insert(timeParts, seconds .. (seconds > 1 and " seconds" or " second"))
	end

	local timeStr = table.concat(timeParts, ", ")
	local lastComma = timeStr:find(", [%a%d]+$")
	if lastComma then
		timeStr = timeStr:sub(1, lastComma - 1) .. " and" .. timeStr:sub(lastComma + 1)
	end
	return timeStr
end

function Game.getPlayerAccountId(name)
	local player = Player(name)
	if player then
		return player:getAccountId()
	end

	local resultId = db.storeQuery("SELECT `account_id` FROM `players` WHERE `name` = " .. db.escapeString(name))
	if resultId then
		local accountId = result.getNumber(resultId, "account_id")
		result.free(resultId)
		return accountId
	end
	return 0
end
