function PrettyString(tbl, indent)
	if not indent then
		indent = 0
	end
	if type(tbl) ~= "table" then
		return tostring(tbl)
	end
	local toprint = string.rep(" ", indent) .. "{\n"
	indent = indent + 2
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if type(k) == "number" then
			toprint = toprint .. "[" .. k .. "] = "
		elseif type(k) == "string" then
			toprint = toprint .. k .. "= "
		end
		if type(v) == "number" then
			toprint = toprint .. v .. ",\n"
		elseif type(v) == "string" then
			toprint = toprint .. '"' .. v .. '",\n'
		elseif type(v) == "table" then
			toprint = toprint .. PrettyString(v, indent + 2) .. ",\n"
		elseif type(v) == "userdata" then
			toprint = toprint .. '"' .. tostring(v) .. '",\n'
		else
			toprint = toprint .. '"' .. tostring(v) .. '",\n'
		end
	end
	toprint = toprint .. string.rep(" ", indent - 2) .. "}"
	return toprint
end

function getTibiaTimerDayOrNight()
	local light = getWorldLight()
	if light == 40 then
		return "night"
	else
		return "day"
	end
end

function getFormattedWorldTime()
	local worldTime = getWorldTime()
	local hours = math.floor(worldTime / 60)

	local minutes = worldTime % 60
	if minutes < 10 then
		minutes = "0" .. minutes
	end
	return hours .. ":" .. minutes
end

function getTimeInWords(secsParam)
	local secs = tonumber(secsParam)
	local hours, minutes, seconds = getHours(secs), getMinutes(secs), getSeconds(secs)
	local timeStr = ""

	if hours > 0 then
		timeStr = hours .. (hours > 1 and " hours" or " hour")
	end

	if minutes > 0 then
		if timeStr ~= "" then
			timeStr = timeStr .. ", "
		end
		timeStr = timeStr .. minutes .. (minutes > 1 and " minutes" or " minute")
	end

	if seconds > 0 then
		if timeStr ~= "" then
			timeStr = timeStr .. " and "
		end
		timeStr = timeStr .. seconds .. (seconds > 1 and " seconds" or " second")
	end

	return timeStr
end

function getLootRandom(modifier)
	local multi = (configManager.getNumber(configKeys.RATE_LOOT) * SCHEDULE_LOOT_RATE) * (modifier or 1)
	return math.random(0, MAX_LOOTCHANCE) * 100 / math.max(1, multi)
end

local start = os.time()
local linecount = 0
debug.sethook(function(event, line)
	linecount = linecount + 1
	if systemTime() - start >= 1 then
		if linecount >= 30000 then
			logger.warn("[debug.sethook] - Possible infinite loop in file [{}] near line [{}]", debug.getinfo(2).source, line)
			debug.sethook()
		end
		linecount = 0
		start = os.time()
	end
end, "l")

-- OTServBr-Global functions
function getRateFromTable(t, level, default)
	if t ~= nil then
		for _, rate in ipairs(t) do
			if level >= rate.minlevel and (not rate.maxlevel or level <= rate.maxlevel) then
				return rate.multiplier
			end
		end
	end
	return default
end

function getAccountNumberByPlayerName(name)
	local player = Player(name)
	if player ~= nil then
		return player:getAccountId()
	end

	local resultId = db.storeQuery("SELECT `account_id` FROM `players` WHERE `name` = " .. db.escapeString(name))
	if resultId ~= false then
		local accountId = Result.getNumber(resultId, "account_id")
		Result.free(resultId)
		return accountId
	end
	return 0
end

function getMoneyCount(string)
	local b, e = string:find("%d+")
	local money = b and e and tonumber(string:sub(b, e)) or -1
	if isValidMoney(money) then
		return money
	end
	return -1
end

function getBankMoney(cid, amount)
	local player = Player(cid)
	if player:getBankBalance() >= amount then
		player:setBankBalance(player:getBankBalance() - amount)
		player:sendTextMessage(MESSAGE_TRADE, "Paid " .. FormatNumber(amount) .. " gold from bank account. Your account balance is now " .. FormatNumber(player:getBankBalance()) .. " gold.")
		return true
	end
	return false
end

function getMoneyWeight(money)
	local gold = money
	local crystal = math.floor(gold / 10000)
	gold = gold - crystal * 10000
	local platinum = math.floor(gold / 100)
	gold = gold - platinum * 100
	return (ItemType(3043):getWeight() * crystal) + (ItemType(3035):getWeight() * platinum) + (ItemType(3031):getWeight() * gold)
end

function getRealDate()
	local month = tonumber(os.date("%m", os.time()))
	local day = tonumber(os.date("%d", os.time()))

	if month < 10 then
		month = "0" .. month
	end
	if day < 10 then
		day = "0" .. day
	end
	return day .. "/" .. month
end

function getRealTime()
	local hours = tonumber(os.date("%H", os.time()))
	local minutes = tonumber(os.date("%M", os.time()))

	if hours < 10 then
		hours = "0" .. hours
	end
	if minutes < 10 then
		minutes = "0" .. minutes
	end
	return hours .. ":" .. minutes
end

-- Marry
function getPlayerSpouse(id)
	local resultQuery = db.storeQuery("SELECT `marriage_spouse` FROM `players` WHERE `id` = " .. db.escapeString(id))
	if resultQuery ~= false then
		local ret = Result.getNumber(resultQuery, "marriage_spouse")
		Result.free(resultQuery)
		return ret
	end
	return -1
end

function getPlayerMarriageStatus(id)
	local resultQuery = db.storeQuery("SELECT `marriage_status` FROM `players` WHERE `id` = " .. db.escapeString(id))
	if resultQuery ~= false then
		local ret = Result.getNumber(resultQuery, "marriage_status")
		Result.free(resultQuery)
		return ret
	end
	return -1
end

function getPlayerNameById(id)
	local resultName = db.storeQuery("SELECT `name` FROM `players` WHERE `id` = " .. db.escapeString(id))
	local name = Result.getString(resultName, "name")
	if resultName ~= false then
		Result.free(resultName)
		return name
	end
	return false
end

function setPlayerSpouse(id, val)
	db.query("UPDATE `players` SET `marriage_spouse` = " .. val .. " WHERE `id` = " .. id)
end

function setPlayerMarriageStatus(id, val)
	db.query("UPDATE `players` SET `marriage_status` = " .. val .. " WHERE `id` = " .. id)
end

function clearRoom(centerPosition, rangeX, rangeY, resetGlobalStorage)
	local spectators, spectator = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() then
			spectator:remove()
		end
	end
	if resetGlobalStorage ~= nil and Game.getStorageValue(resetGlobalStorage) == 1 then
		Game.setStorageValue(resetGlobalStorage, -1)
	end
end

function isValidMoney(money)
	return isNumber(money) and money > 0 and money < 4294967296
end

function iterateArea(func, from, to)
	for z = from.z, to.z do
		for y = from.y, to.y do
			for x = from.x, to.x do
				func(Position(x, y, z))
			end
		end
	end
end

function isNumber(str)
	return tonumber(str) ~= nil
end

function isInteger(n)
	return (type(n) == "number") and (math.floor(n) == n)
end

-- Function for the reload talkaction
local logFormat = "[%s] %s (params: %s)"

function logCommand(player, words, param)
	local file = io.open(CORE_DIRECTORY .. "/logs/" .. player:getName() .. " commands.log", "a")
	if not file then
		return
	end

	io.output(file)
	io.write(logFormat:format(os.date("%d/%m/%Y %H:%M"), words, param):trim() .. "\n")
	io.close(file)
end

-- Special lib functions
function insertIndex(i, buffer)
	table.insert(buffer, "[")
	if type(i) == "string" then
		table.insert(buffer, '"')
		table.insert(buffer, i)
		table.insert(buffer, '"')
	elseif type(i) == "number" then
		table.insert(buffer, tostring(i))
	end
	table.insert(buffer, "] = ")
end

function indexToStr(i, v, buffer)
	local tp = type(v)
	local itp = type(i)
	if itp ~= "number" and itp ~= "string" then
		logger.warn("[indexToStr] - Invalid index to serialize: {}", type(i))
	else
		if tp == "table" then
			insertIndex(i, buffer)
			serializeTable(v, buffer)
			table.insert(buffer, ",")
		elseif tp == "number" then
			insertIndex(i, buffer)
			table.insert(buffer, tostring(v))
			table.insert(buffer, ",")
		elseif tp == "string" then
			insertIndex(i, buffer)
			table.insert(buffer, '"')
			table.insert(buffer, v)
			table.insert(buffer, '",')
		elseif tp == "boolean" then
			insertIndex(i, buffer)
			table.insert(buffer, v == true and "true" or "false")
			table.insert(buffer, ",")
		else
			logger.warn("[indexToStr] - Invalid type to serialize: {}, index: {}", tp, i)
		end
	end
end

function serializeTable(t, buffer)
	local buffer = buffer or {}
	table.insert(buffer, "{")
	for i, x in pairs(t) do
		indexToStr(i, x, buffer)
	end
	table.insert(buffer, "}")
	return table.concat(buffer)
end

function table.copy(t, out)
	out = out or {}
	if type(t) ~= "table" then
		return false
	end

	for i, x in pairs(t) do
		if type(x) == "table" then
			out[i] = {}
			table.copy(t[i], out[i])
		else
			out[i] = x
		end
	end
	return out
end

function unserializeTable(str, out)
	local tmp = load("return " .. str)
	if tmp then
		tmp = tmp()
	else
		logger.warn("[unserializeTable] - Unserialization error: {}", str)
		return false
	end
	return table.copy(tmp, out)
end

function HasValidTalkActionParams(player, param, usage)
	if not param or param == "" then
		player:sendCancelMessage("Command param required. Usage: " .. usage)
		return false
	end

	local split = param:split(",")
	if not split[2] then
		player:sendCancelMessage("Insufficient parameters. Usage: " .. usage)
		return false
	end

	return true
end

function FormatNumber(number)
	local _, _, minus, int, fraction = tostring(number):find("([-]?)(%d+)([.]?%d*)")
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction
end

--- Parse a duration string into milliseconds
---@param duration string|number The duration string to parse or a number of milliseconds (for idempotency)
---@return number|nil The duration in milliseconds, or nil if the string is invalid
function ParseDuration(duration)
	if not duration then
		return nil
	end

	if type(duration) == "number" then
		return duration
	end

	local multipliers = {
		w = 7 * 24 * 60 * 60 * 1000,
		d = 24 * 60 * 60 * 1000,
		h = 60 * 60 * 1000,
		m = 60 * 1000,
		s = 1000,
		ms = 1,
	}

	local total = 0

	for numStr, unit in string.gmatch(duration, "([%d%.]+)(%a+)") do
		local num = tonumber(numStr)
		if not num then
			error("Invalid numeric part in duration string")
		end

		local multiplier = multipliers[unit]
		if not multiplier then
			error("Invalid unit in duration string")
		end

		total = total + (num * multiplier)
	end

	if total == 0 then
		error("Invalid duration string")
	end

	return total
end

function toKey(str)
	return str:lower():gsub(" ", "-"):gsub("%s+", "")
end

function toboolean(value)
	if type(value) == "boolean" then
		return value
	end
	if value == "true" then
		return true
	elseif value == "false" then
		return false
	end
end
