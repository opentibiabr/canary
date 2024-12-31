-- Function to perform database cleanup tasks
local function cleanupDatabase()
	db.query("TRUNCATE TABLE `players_online`")

	local currentTime = os.time()
	db.asyncQuery("DELETE FROM `guild_wars` WHERE `status` IN (0, 2, 3) OR (`status` = 0 AND (`started` + 72 * 60 * 60) <= " .. currentTime .. ")")
	db.asyncQuery("DELETE FROM `players` WHERE `deletion` != 0 AND `deletion` < " .. currentTime)
	db.asyncQuery("DELETE FROM `ip_bans` WHERE `expires_at` != 0 AND `expires_at` <= " .. currentTime)
	db.asyncQuery("DELETE FROM `market_history` WHERE `inserted` <= " .. (currentTime - configManager.getNumber(configKeys.MARKET_OFFER_DURATION)))
	db.query("DELETE FROM `player_storage` WHERE `key` IN (" .. Global.Storage.FamiliarSummonEvent10 .. ", " .. Global.Storage.FamiliarSummonEvent60 .. ")")

	db.query("UPDATE `players` SET `isreward` = " .. DAILY_REWARD_NOTCOLLECTED)
	db.query("UPDATE `player_storage` SET `value` = 0 WHERE `player_storage`.`key` = 51052")
end

-- Function to move expired bans to ban history
local function moveExpiredBansToHistory()
	local resultId = db.storeQuery("SELECT * FROM `account_bans` WHERE `expires_at` != 0 AND `expires_at` <= " .. os.time())
	if resultId then
		repeat
			local accountId = Result.getNumber(resultId, "account_id")
			db.asyncQuery("INSERT INTO `account_ban_history` (`account_id`, `reason`, `banned_at`, `expired_at`, `banned_by`) VALUES (" .. accountId .. ", " .. db.escapeString(Result.getString(resultId, "reason")) .. ", " .. Result.getNumber(resultId, "banned_at") .. ", " .. Result.getNumber(resultId, "expires_at") .. ", " .. Result.getNumber(resultId, "banned_by") .. ")")
			db.asyncQuery("DELETE FROM `account_bans` WHERE `account_id` = " .. accountId)
		until not Result.next(resultId)

		Result.free(resultId)
	end
end

-- Function to store towns in the database
local function storeTownsInDatabase()
	db.query("TRUNCATE TABLE `towns`")

	for i, town in ipairs(Game.getTowns()) do
		local position = town:getTemplePosition()
		db.query("INSERT INTO `towns` (`id`, `name`, `posx`, `posy`, `posz`) VALUES (" .. town:getId() .. ", " .. db.escapeString(town:getName()) .. ", " .. position.x .. ", " .. position.y .. ", " .. position.z .. ")")
	end
end

-- Functions to recursively check for duplicate values in a given variable's storage and log the results
local seen, duplicatesValues

local function checkDuplicateStorageValues(varTable)
	for _, value in pairs(varTable) do
		if type(value) == "table" then
			checkDuplicateStorageValues(value)
		elseif seen[value] then
			table.insert(duplicatesValues, value)
		else
			seen[value] = true
		end
	end
	return #duplicatesValues > 0 and duplicatesValues or false
end

local function checkAndLogDuplicateValues(tableNames)
	for _, tableName in ipairs(tableNames) do
		local varTable = _G[tableName]
		if type(varTable) == "table" then
			seen = {}
			duplicatesValues = {}

			local duplicates = checkDuplicateStorageValues(varTable)
			if duplicates then
				logger.warn("Checking {}: Duplicate values found: {}", tableName, table.concat(duplicates, ", "))
			else
				logger.info("Checking {}: No duplicate values found.", tableName)
			end
		else
			logger.warn("{} is not a table. Unable to check for duplicate values.", varTable)
		end

		seen = nil
		duplicatesValues = nil
	end
end

-- Function to update event rates based on EventsScheduler data
local function updateEventRates()
	local lootRate = EventsScheduler.getEventSLoot()
	if lootRate ~= 100 then
		SCHEDULE_LOOT_RATE = lootRate
	end

	local bossLootRate = EventsScheduler.getEventSBossLoot()
	if bossLootRate ~= 100 then
		SCHEDULE_BOSS_LOOT_RATE = bossLootRate
	end

	local expRate = EventsScheduler.getEventSExp()
	if expRate ~= 100 then
		SCHEDULE_EXP_RATE = expRate
	end

	local skillRate = EventsScheduler.getEventSSkill()
	if skillRate ~= 100 then
		SCHEDULE_SKILL_RATE = skillRate
	end

	local spawnRate = EventsScheduler.getSpawnMonsterSchedule()
	if spawnRate ~= 100 then
		SCHEDULE_SPAWN_RATE = spawnRate
	end

	-- Log information if any of the rates are not 100%
	if expRate ~= 100 or lootRate ~= 100 or spawnRate ~= 100 or skillRate ~= 100 or bossLootRate ~= 100 then
		logger.info("[Events] Exp: {}%, Loot: {}%, Spawn: {}%, Skill: {}%, Boss loot: {}%", expRate, lootRate, spawnRate, skillRate, bossLootRate)
	end
end

-- Function to reset account sessions based on configuration and authentication type
local function resetAccountSessions()
	if AUTH_TYPE == "session" then
		if configManager.getBoolean(configKeys.RESET_SESSIONS_ON_STARTUP) then
			db.query("TRUNCATE TABLE `account_sessions`")
		else
			db.query("DELETE FROM `account_sessions` WHERE `expires` <= " .. os.time())
		end
	end
end

local serverInitialization = GlobalEvent("Server Initialization")

function serverInitialization.onStartup()
	logger.debug("Loaded {} npcs and spawned {} monsters", Game.getNpcCount(), Game.getMonsterCount())
	logger.debug("Loaded {} towns with {} houses in total", #Game.getTowns(), #Game.getHouses())

	cleanupDatabase()
	moveExpiredBansToHistory()
	storeTownsInDatabase()
	checkAndLogDuplicateValues({ "Global", "GlobalStorage", "Storage" })
	updateEventRates()
	HirelingsInit()
	resetAccountSessions()
end

serverInitialization:register()
