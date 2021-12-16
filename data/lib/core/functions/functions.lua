-- From here down are the functions of TFS
function getTibiaTimerDayOrNight()
	local light = getWorldLight()
	if (light == 40) then
		return "night"
	else
		return "day"
	end
end

function getHours(seconds)
	return math.floor((seconds/60)/60)
end

function getMinutes(seconds)
	return math.floor(seconds/60)
end

function getSeconds(seconds)
	return seconds%60
end

function getTime(seconds)
	local hours, minutes = getHours(seconds), getMinutes(seconds)
	if (minutes > 59) then
		minutes = minutes-hours*60
	end

	if (minutes < 10) then
		minutes = "0" ..minutes
	end

	return hours..":"..minutes.. "h"
end

function getTimeinWords(secs)
	local hours, minutes, seconds = getHours(secs), getMinutes(secs), getSeconds(secs)
	if (minutes > 59) then
		minutes = minutes-hours*60
	end

	local timeStr = ''

	if hours > 0 then
		timeStr = timeStr .. ' hours '
	end

	timeStr = timeStr .. minutes .. ' minutes and '.. seconds .. ' seconds.'

	return timeStr
end

function getFormattedWorldTime()
	local worldTime = getWorldTime()
	local hours = math.floor(worldTime / 60)

	local minutes = worldTime % 60
	if minutes < 10 then
		minutes = '0' .. minutes
	end
	return hours .. ':' .. minutes
end

function getLootRandom()
	return math.random(0, MAX_LOOTCHANCE) * 100 / (configManager.getNumber(configKeys.RATE_LOOT) * SCHEDULE_LOOT_RATE)
end

local start = os.time()
local linecount = 0
debug.sethook(function(event, line)
	linecount = linecount + 1
	if systemTime() - start >= 1 then
		if linecount >= 30000 then
			Spdlog.warn(string.format("[debug.sethook] - Possible infinite loop in file [%s] near line [%d]",
				debug.getinfo(2).source, line))
			debug.sethook()
		end
		linecount = 0
		start = os.time()
	end
end, "l")

function getRateFromTable(t, level, default)
	for _, rate in ipairs(t) do
		if level >= rate.minlevel and (not rate.maxlevel or level <= rate.maxlevel) then
			return rate.multiplier
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
		local accountId = result.getNumber(resultId, "account_id")
		result.free(resultId)
		return accountId
	end
	return 0
end

function getMoneyCount(string)
	local b,
	e = string:find("%d+")
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
		player:sendTextMessage(MESSAGE_TRADE, "Paid " .. amount .. " gold from bank account. Your account balance is now " .. player:getBankBalance() .. " gold.")
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
	return (ItemType(2160):getWeight() * crystal) + (ItemType(2152):getWeight() * platinum) +
	(ItemType(2148):getWeight() * gold)
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
		local ret = result.getNumber(resultQuery, "marriage_spouse")
		result.free(resultQuery)
		return ret
	end
	return -1
end

function getPlayerMarriageStatus(id)
	local resultQuery = db.storeQuery("SELECT `marriage_status` FROM `players` WHERE `id` = " .. db.escapeString(id))
	if resultQuery ~= false then
		local ret = result.getNumber(resultQuery, "marriage_status")
		result.free(resultQuery)
		return ret
	end
	return -1
end

function getPlayerNameById(id)
	local resultName = db.storeQuery("SELECT `name` FROM `players` WHERE `id` = " .. db.escapeString(id))
	local name = result.getString(resultName, "name")
	if resultName ~= false then
		result.free(resultName)
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

-- The following 2 functions can be used for delayed shouted text
function say(param)
	selfSay(text)
	doCreatureSay(param.cid, param.text, 1)
end

function delayedSay(text, delay)
	local delaySay = delay or 0
	local cid = getNpcCid()
	addEvent(say, delaySay, {cid = cid, text = text})
end

function clearMap(centerPosition, rangeX, rangeY, resetGlobalStorage)
	local spectators,
	spectator = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() then
			spectator:remove()
		end
	end
	if Game.getStorageValue(resetGlobalStorage) == 1 then
		Game.setStorageValue(resetGlobalStorage, -1)
	end
end

function mapIsOccupied(centerPosition, rangeX, rangeY)
	local spectators = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	if #spectators ~= 0 then
		return true
	end
	return false
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

function playerExists(name)
	local resultId = db.storeQuery("SELECT `name` FROM `players` WHERE `name` = " .. db.escapeString(name))
	if resultId then
		result.free(resultId)
		return true
	end
	return false
end

function checkWeightAndBackpackRoom(player, itemWeight, message)
	local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
	if not backpack or backpack:getEmptySlots(true) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message .. ", but you have no room to take it.")
		return false
	end
	if (player:getFreeCapacity() / 100) < itemWeight then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
		message .. ". Weighing " .. itemWeight .. " oz, it is too heavy for you to carry.")
		return false
	end
	return true
end

function isInRange(pos, fromPos, toPos)
	return pos.x >= fromPos.x and pos.y >= fromPos.y
			and pos.z >= fromPos.z and pos.x <= toPos.x
			and pos.y <= toPos.y and pos.z <= toPos.z
end

function isNumber(str)
	return tonumber(str) ~= nil
end

function isInteger(n)
	return (type(n) == "number") and (math.floor(n) == n)
end

-- Function for the reload talkaction
local logFormat = "[%s] %s %s"

function logCommand(player, words, param)
	local file = io.open("data/logs/" .. player:getName() .. " commands.log", "a")
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
		Spdlog.warn("[indexToStr] - Invalid index to serialize: " .. type(i))
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
			Spdlog.warn("[indexToStr] - Invalid type to serialize: " .. tp .. ", index: " .. i)
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
		Spdlog.warn("[unserializeTable] - Unserialization error: " .. str)
		return false
	end
	return table.copy(tmp, out)
end

local function setTableIndexes(t, i, v, ...)
	if i and v then
		t[i] = v
		return setTableIndexes(t, ...)
	end
end

local function getTableIndexes(t, i, ...)
	if i then
		return t[i], getTableIndexes(t, ...)
	end
end

function unpack2(tab, i)
	local i, v = next(tab, i)
	if next(tab, i) then
		return i, v, unpack2(tab, i)
	else
		return i, v
	end
end

function pack(t, ...)
	for i = 1, select("#", ...) do
		local tmp = select(i, ...)
		t[i] = tmp
	end
	return t
end

function Item:setSpecialAttribute(...)
	local tmp
	if self:hasAttribute(ITEM_ATTRIBUTE_SPECIAL) then
		tmp = self:getAttribute(ITEM_ATTRIBUTE_SPECIAL)
	else
		tmp = "{}"
	end

	local tab = unserializeTable(tmp)
	if tab then
		setTableIndexes(tab, ...)
		tmp = serializeTable(tab)
		self:setAttribute(ITEM_ATTRIBUTE_SPECIAL, tmp)
		return true
	end
end

function Item:getSpecialAttribute(...)
	local tmp
	if self:hasAttribute(ITEM_ATTRIBUTE_SPECIAL) then
		tmp = self:getAttribute(ITEM_ATTRIBUTE_SPECIAL)
	else
		tmp = "{}"
	end

	local tab = unserializeTable(tmp)
	if tab then
		return getTableIndexes(tab, ...)
	end
end

if not PLAYER_STORAGE then
	PLAYER_STORAGE = {}
end

function Player:setSpecialStorage(storage, value)
	if not PLAYER_STORAGE[self:getGuid()] then
		self:loadSpecialStorage()
	end

	PLAYER_STORAGE[self:getGuid()][storage] = value
end

function Player:getSpecialStorage(storage)
	if not PLAYER_STORAGE[self:getGuid()] then
		self:loadSpecialStorage()
	end

	return PLAYER_STORAGE[self:getGuid()][storage]
end

function Player:loadSpecialStorage()
	if not PLAYER_STORAGE then
		PLAYER_STORAGE = {}
	end

	PLAYER_STORAGE[self:getGuid()] = {}
	local resultId = db.storeQuery("SELECT * FROM `player_misc` WHERE `player_id` = " .. self:getGuid())
	if resultId then
		local info = result.getStream(resultId , "info") or "{}"
		unserializeTable(info, PLAYER_STORAGE[self:getGuid()])
	end
end

function Player:saveSpecialStorage()
	if PLAYER_STORAGE and PLAYER_STORAGE[self:getGuid()] then
		local tmp = serializeTable(PLAYER_STORAGE[self:getGuid()])
		db.query("DELETE FROM `player_misc` WHERE `player_id` = " .. self:getGuid())
		db.query(string.format("INSERT INTO `player_misc` (`player_id`, `info`) VALUES (%d, %s)", self:getGuid(), db.escapeBlob(tmp, #tmp)))
	end
end
