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

function getTitle(uid)
	local player = Player(uid)
	if not player then
		return false
	end

	for i = #titles, 1, -1 do
		if player:getStorageValue(titles[i].storageID) == 1 then
			return titles[i].title
		end
	end

	return false
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
function getJackLastMissionState(player)
	if not IsRunningGlobalDatapack() then
		return true
	end

	if player:getStorageValue(Storage.TibiaTales.JackFutureQuest.LastMissionState) == 1 then
		return "You told Jack the truth about his personality. You also explained that you and Spectulus \z
		made a mistake by assuming him as the real Jack."
	else
		return "You lied to the confused Jack about his true personality. You and Spectulus made him \z
		believe that he is in fact a completely different person. Now he will never be able to find out the truth."
	end
end

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

function checkBoss(centerPosition, rangeX, rangeY, bossName, bossPos)
	local spectators, found = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY), false
	for i = 1, #spectators do
		local spec = spectators[i]
		if spec:isMonster() then
			if spec:getName() == bossName then
				found = true
				break
			end
		end
	end
	if not found then
		local boss = Game.createMonster(bossName, bossPos, true, true)
		boss:setReward(true)
	end
	return found
end

function clearBossRoom(playerId, centerPosition, onlyPlayers, rangeX, rangeY, exitPosition)
	local spectators, spectator = Game.getSpectators(centerPosition, false, onlyPlayers, rangeX, rangeX, rangeY, rangeY)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isPlayer() and ((playerId ~= nil and spectator.uid == playerId) or playerId == nil) then
			spectator:teleportTo(exitPosition)
			exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end

		if spectator:isMonster() then
			spectator:remove()
		end
	end
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

function roomIsOccupied(centerPosition, onlyPlayers, rangeX, rangeY)
	local spectators = Game.getSpectators(centerPosition, false, onlyPlayers, rangeX, rangeX, rangeY, rangeY)
	if #spectators ~= 0 then
		return true
	end
	return false
end

function clearForgotten(fromPosition, toPosition, exitPosition, storage)
	for x = fromPosition.x, toPosition.x do
		for y = fromPosition.y, toPosition.y do
			for z = fromPosition.z, toPosition.z do
				if Tile(Position(x, y, z)) then
					local creature = Tile(Position(x, y, z)):getTopCreature()
					if creature then
						if creature:isPlayer() then
							creature:teleportTo(exitPosition)
							exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
							creature:say("Time out! You were teleported out by strange forces.", TALKTYPE_MONSTER_SAY)
						elseif creature:isMonster() then
							creature:remove()
						end
					end
				end
			end
		end
	end
	Game.setStorageValue(storage, 0)
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

function resetFerumbrasAscendantHabitats()
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Corrupted, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Desert, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Dimension, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Grass, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Ice, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Mushroom, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Roshamuul, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.Venom, 0)
	Game.setStorageValue(GlobalStorage.FerumbrasAscendant.Habitats.AllHabitats, 0)

	for _, spec in pairs(Game.getSpectators(Position(33629, 32693, 12), false, false, 25, 25, 85, 85)) do
		if spec:isPlayer() then
			spec:teleportTo(Position(33630, 32648, 12))
			spec:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			spec:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were teleported because the habitats are returning to their original form.")
		elseif spec:isMonster() then
			spec:remove()
		end
	end

	for x = 33611, 33625 do
		for y = 32658, 32727 do
			local position = Position(x, y, 12)
			local tile = Tile(position)
			if not tile then
				return
			end
			local ground = tile:getGround()
			if not ground then
				return
			end
			ground:remove()
			local items = tile:getItems()
			if items then
				for i = 1, #items do
					local item = items[i]
					item:remove()
				end
			end
		end
	end

	for x = 33634, 33648 do
		for y = 32658, 32727 do
			local position = Position(x, y, 12)
			local tile = Tile(position)
			if not tile then
				return
			end
			local ground = tile:getGround()
			if not ground then
				return
			end
			ground:remove()
			local items = tile:getItems()
			if items then
				for i = 1, #items do
					local item = items[i]
					item:remove()
				end
			end
		end
	end

	Game.loadMap(DATA_DIRECTORY .. "/world/quest/ferumbras_ascendant/habitats.otbm")
	return true
end

function checkWallArito(item, toPosition)
	if not item:isItem() then
		return false
	end
	local wallTile = Tile(Position(33206, 32536, 6))
	if not wallTile or wallTile:getItemCountById(7181) > 0 then
		return false
	end
	local checkEqual = {
		[2886] = { Position(33207, 32537, 6), { 5858, -1 }, Position(33205, 32537, 6) },
		[3307] = { Position(33205, 32537, 6), { 2016, 1 }, Position(33207, 32537, 6), 5858 },
	}
	local it = checkEqual[item:getId()]
	if it and it[1] == toPosition and Tile(it[3]):getItemCountById(it[2][1], it[2][2]) > 0 then
		wallTile:getItemById(1085):transform(7181)

		if it[4] then
			item:transform(it[4])
		end

		addEvent(function()
			if Tile(Position(33206, 32536, 6)):getItemCountById(7476) > 0 then
				Tile(Position(33206, 32536, 6)):getItemById(7476):transform(1085)
			end
			if Tile(Position(33205, 32537, 6)):getItemCountById(5858) > 0 then
				Tile(Position(33205, 32537, 6)):getItemById(5858):remove()
			end
		end, 5 * 60 * 1000)
	else
		if it and it[4] and it[1] == toPosition then
			item:transform(it[4])
		end
	end
end

function placeSpawnRandom(fromPositon, toPosition, monsterName, ammount, hasCall, storage, value, removestorage, sharedHP, event, message)
	for _x = fromPositon.x, toPosition.x do
		for _y = fromPositon.y, toPosition.y do
			for _z = fromPositon.z, toPosition.z do
				local tile = Tile(Position(_x, _y, _z))
				if not removestorage then
					if tile and tile:getTopCreature() and tile:getTopCreature():isMonster() and tile:getTopCreature():getName() == monsterName then
						tile:getTopCreature():remove()
					end
				else
					if tile and tile:getTopCreature() and tile:getTopCreature():isMonster() and tile:getTopCreature():getStorageValue(storage) == value then
						tile:getTopCreature():remove()
					end
				end
			end
		end
	end
	if ammount and ammount > 0 then
		local summoned = 0
		local tm = os.time()
		repeat
			local tile = false
			-- repeat
			local position = {
				x = math.random(fromPositon.x, toPosition.x),
				y = math.random(fromPositon.y, toPosition.y),
				z = math.random(fromPositon.z, toPosition.z),
			}
			-- tile = Tile(position)
			-- passing = tile and #tile:getItems() <= 0
			-- until (passing == true)
			local monster = Game.createMonster(monsterName, position)
			if monster then
				summoned = summoned + 1
				-- Set first spawn
				monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				if hasCall then
					monster:setStorage(storage, value)
					if sharedHP then
						monster:beginSharedLife(tm)
						monster:registerEvent("sharedLife")
					end
					if event then
						monster:registerEvent(event)
					end
					local function SendMessage(mit, message)
						if not Monster(mit) then
							return false
						end
						Monster(mit):say(message, TALKTYPE_MONSTER_SAY)
					end
					if message then
						addEvent(SendMessage, 200, monster:getId(), message)
					end
				end
			end
		until summoned == ammount
	end
end

function getMonstersInArea(fromPos, toPos, monsterName, ignoreMonsterId)
	local monsters = {}
	for _x = fromPos.x, toPos.x do
		for _y = fromPos.y, toPos.y do
			for _z = fromPos.z, toPos.z do
				local tile = Tile(Position(_x, _y, _z))
				if tile and tile:getTopCreature() then
					for _, pid in pairs(tile:getCreatures()) do
						local mt = Monster(pid)
						if not ignoreMonsterId then
							if mt and mt:isMonster() and mt:getName():lower() == monsterName:lower() and not mt:getMaster() then
								monsters[#monsters + 1] = mt
							end
						else
							if mt and mt:isMonster() and mt:getName():lower() == monsterName:lower() and not mt:getMaster() and ignoreMonsterId ~= mt:getId() then
								monsters[#monsters + 1] = mt
							end
						end
					end
				end
			end
		end
	end
	return monsters
end

function isPlayerInArea(fromPos, toPos)
	for positionX = fromPos.x, toPos.x do
		for positionY = fromPos.y, toPos.y do
			for positionZ = fromPos.z, toPos.z do
				local tile = Tile(Position({ x = positionX, y = positionY, z = positionZ }))
				if tile then
					if tile:getTopCreature() and tile:getTopCreature():isPlayer() then
						return true
					end
				end
			end
		end
	end
	return false
end

function cleanAreaQuest(frompos, topos, itemtable, blockmonsters)
	if not itemtable then
		itemtable = {}
	end
	if not blockmonsters then
		blockmonsters = {}
	end
	for _x = frompos.x, topos.x do
		for _y = frompos.y, topos.y do
			for _z = frompos.z, topos.z do
				local tile = Tile(Position(_x, _y, _z))
				if tile then
					local itc = tile:getItems()
					if itc and tile:getItemCount() > 0 then
						for _, pid in pairs(itc) do
							local itp = ItemType(pid:getId())
							if itp and itp:isCorpse() then
								pid:remove()
							end
						end
					end
					for _, pid in pairs(itemtable) do
						local _until = tile:getItemCountById(pid)
						if _until > 0 then
							for i = 1, _until do
								local it = tile:getItemById(pid)
								if it then
									it:remove()
								end
							end
						end
					end
					local mtempc = tile:getCreatures()
					if mtempc and tile:getCreatureCount() > 0 then
						for _, pid in pairs(mtempc) do
							if pid:isMonster() and not table.contains(blockmonsters, pid:getName():lower()) then
								-- broadcastMessage(pid:getName())
								pid:remove()
							end
						end
					end
				end
			end
		end
	end
	return true
end

function kickerPlayerRoomAfterMin(playername, fromPosition, toPosition, teleportPos, message, monsterName, minutes, firstCall, itemtable, blockmonsters)
	local players = false
	if type(playername) == table then
		players = true
	end
	local player = false
	if not players then
		player = Player(playername)
	end
	local monster = {}
	if monsterName ~= "" then
		monster = getMonstersInArea(fromPosition, toPosition, monsterName)
	end
	if player == false and players == false then
		return false
	end
	if not players and player then
		if player:getPosition():isInRange(fromPosition, toPosition) and minutes == 0 then
			if monsterName ~= "" then
				for _, pid in pairs(monster) do
					if pid:isMonster() then
						if pid:getStorageValue("playername") == playername then
							pid:remove()
						end
					end
				end
			else
				if not itemtable then
					itemtable = {}
				end
				if not blockmonsters then
					blockmonsters = {}
				end
				cleanAreaQuest(fromPosition, toPosition, itemtable, blockmonsters)
			end
			player:teleportTo(teleportPos, true)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
			return true
		end
	else
		if minutes == 0 then
			if monsterName ~= "" then
				for _, pid in pairs(monster) do
					if pid:isMonster() then
						if pid:getStorageValue("playername") == playername then
							pid:remove()
						end
					end
				end
			else
				if not itemtable then
					itemtable = {}
				end
				if not blockmonsters then
					blockmonsters = {}
				end
				cleanAreaQuest(fromPosition, toPosition, itemtable, blockmonsters)
			end
			for _, pid in pairs(playername) do
				local player = Player(pid)
				if player and player:getPosition():isInRange(fromPosition, toPosition) then
					player:teleportTo(teleportPos, true)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
				end
			end
			return true
		end
	end
	local min = 60 -- Use the 60 for 1 minute
	if firstCall then
		addEvent(kickerPlayerRoomAfterMin, 1000, playername, fromPosition, toPosition, teleportPos, message, monsterName, minutes, false, itemtable, blockmonsters)
	else
		local subt = minutes - 1
		if monsterName ~= "" then
			if minutes > 3 and table.maxn(monster) == 0 then
				subt = 2
			end
		end
		addEvent(kickerPlayerRoomAfterMin, min * 1000, playername, fromPosition, toPosition, teleportPos, message, monsterName, subt, false, itemtable, blockmonsters)
	end
end

function checkWeightAndBackpackRoom(player, itemWeight, message)
	local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
	if not backpack or backpack:getEmptySlots(true) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message .. ", but you have no room to take it.")
		return false
	end
	if (player:getFreeCapacity() / 100) < itemWeight then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message .. ". Weighing " .. itemWeight .. " oz, it is too heavy for you to carry.")
		return false
	end
	return true
end

function doCreatureSayWithRadius(cid, text, type, radiusx, radiusy, position)
	if not position then
		position = Creature(cid):getPosition()
	end

	local spectators, spectator = Game.getSpectators(position, false, true, radiusx, radiusx, radiusy, radiusy)
	for i = 1, #spectators do
		spectator = spectators[i]
		spectator:say(text, type, false, spectator, position)
	end
end

--Boss entry
if not bosssPlayers then
	bosssPlayers = {
		addPlayers = function(self, cid)
			local player = Player(cid)
			if not player then
				return false
			end
			if not self.players then
				self.players = {}
			end
			self.players[player:getId()] = 1
		end,
		removePlayer = function(self, cid)
			local player = Player(cid)
			if not player then
				return false
			end
			if not self.players then
				return false
			end
			self.players[player:getId()] = nil
		end,
		getPlayersCount = function(self)
			if not self.players then
				return 0
			end
			local c = 0
			for _ in pairs(self.players) do
				c = c + 1
			end
			return c
		end,
	}
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

-- Can be used in every boss
function kickPlayersAfterTime(players, fromPos, toPos, exit)
	for _, pid in pairs(players) do
		local player = Player(pid)
		if player and player:getPosition():isInRange(fromPos, toPos) then
			player:teleportTo(exit)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were kicked by exceding time inside the boss room.")
		end
	end
end

function Player:doCheckBossRoom(bossName, fromPos, toPos)
	if self then
		for x = fromPos.x, toPos.x do
			for y = fromPos.y, toPos.y do
				for z = fromPos.z, toPos.z do
					local sqm = Tile(Position(x, y, z))
					if sqm then
						if sqm:getTopCreature() and sqm:getTopCreature():isPlayer() then
							self:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must wait. Someone is challenging " .. bossName .. " now.")
							return false
						end
					end
				end
			end
		end
		-- Room cleaning
		for x = fromPos.x, toPos.x do
			for y = fromPos.y, toPos.y do
				for z = fromPos.z, toPos.z do
					local sqm = Tile(Position(x, y, z))
					if sqm and sqm:getTopCreature() then
						local monster = sqm:getTopCreature()
						if monster then
							monster:remove()
						end
					end
				end
			end
		end
	end
	return true
end

function CheckDustLevel(monsterForge, player)
	local canSetFiendish = false
	local canSetInfluenced
	if type(monsterForge) == "string" and monsterForge == "fiendish" then
		canSetFiendish = true
	end
	local influencedLevel
	if not canSetFiendish then
		influencedLevel = tonumber(monsterForge)
	end
	if influencedLevel and influencedLevel > 0 then
		if influencedLevel > 5 then
			player:sendCancelMessage("Invalid influenced level.")
			return false
		end
		canSetInfluenced = true
	end
	return canSetFiendish, canSetInfluenced, influencedLevel
end

function SetFiendish(monsterType, position, player, monster)
	if monsterType and not monsterType:isForgeCreature() then
		player:sendCancelMessage("Only allowed monsters can be fiendish.")
		return false
	end
	monster:setFiendish(position, player)
end

function SetInfluenced(monsterType, monster, player, influencedLevel)
	if monsterType and not monsterType:isForgeCreature() then
		player:sendCancelMessage("Only allowed monsters can be influenced.")
		return false
	end
	local influencedMonster = Monster(ForgeMonster:pickInfluenced())
	-- If it's reached the limit, we'll remove one to add the new one.
	if ForgeMonster:exceededMaxInfluencedMonsters() then
		if influencedMonster then
			Game.removeInfluencedMonster(influencedMonster:getId())
		end
	end
	Game.addInfluencedMonster(monster)
	monster:setForgeStack(influencedLevel)
end

function ReloadDataEvent(cid)
	local player = Player(cid)
	if not player then
		return
	end

	player:reloadData()
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

--- Get the next occurrence of a time string
---@param timeStr string The time string in the format HH:MM:SS
---@return number|nil The timestamp of the next occurrence, or nil if the string is invalid
function GetNextOccurrence(timeStr)
	local hours, minutes, seconds = string.match(timeStr, "(%d+):(%d+):(%d+)")
	if not hours or not minutes or not seconds then
		error("Invalid time string format.")
		return nil
	end

	hours = tonumber(hours)
	minutes = tonumber(minutes)
	seconds = tonumber(seconds)

	local currentTime = os.time()
	local dateTable = os.date("*t", currentTime)

	dateTable.hour = hours
	dateTable.min = minutes
	dateTable.sec = seconds

	local nextTime = os.time(dateTable)

	if nextTime <= currentTime then
		nextTime = nextTime + (24 * 60 * 60)
	end

	return nextTime
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

--- Convert a duration in milliseconds into a string
---@param duration number The duration in milliseconds
---@return string The string representation of the duration
function FormatDuration(duration)
	if type(duration) == "string" then
		duration = ParseDuration(duration)
	end
	if not duration or type(duration) ~= "number" then
		return ""
	end

	local units = {
		{ "w", 7 * 24 * 60 * 60 * 1000 },
		{ "d", 24 * 60 * 60 * 1000 },
		{ "h", 60 * 60 * 1000 },
		{ "m", 60 * 1000 },
		{ "s", 1000 },
		{ "ms", 1 },
	}

	local remaining = duration
	local parts = {}

	for _, unitInfo in ipairs(units) do
		local unit = unitInfo[1]
		local multiplier = unitInfo[2]

		local count = math.floor(remaining / multiplier)
		if count > 0 then
			table.insert(parts, tostring(count) .. unit)
			remaining = remaining - (count * multiplier)
		end
	end

	if #parts == 0 then
		return "0ms"
	end

	return table.concat(parts)
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

-- Utility to combine onDeath event with a "kill" event for a player with a party (or not).
function onDeathForParty(creature, player, func)
	if not player or not player:isPlayer() then
		return
	end

	local participants = Participants(player, true)
	for _, participant in ipairs(participants) do
		func(creature, participant)
	end
end

function onDeathForDamagingPlayers(creature, func)
	for key, value in pairs(creature:getDamageMap()) do
		local player = Player(key)
		if player then
			func(creature, player)
		end
	end
end
