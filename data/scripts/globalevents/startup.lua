-- Function to reset familiars message storage
local function resetFamiliarsMessageStorage()
	db.query("DELETE FROM `player_storage` WHERE `key` = " .. Global.Storage.FamiliarSummonEvent10)
	db.query("DELETE FROM `player_storage` WHERE `key` = " .. Global.Storage.FamiliarSummonEvent60)
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

-- Function to check and process house auctions
local function processHouseAuctions()
	local currentTime = os.time()
	local resultId = db.storeQuery("SELECT `id`, `highest_bidder`, `last_bid`, " .. "(SELECT `balance` FROM `players` WHERE `players`.`id` = `highest_bidder`) AS `balance` " .. "FROM `houses` WHERE `owner` = 0 AND `bid_end` != 0 AND `bid_end` < " .. currentTime)
	if resultId then
			repeat
					local house = House(Result.getNumber(resultId, "id"))
					if house then
							local highestBidder = Result.getNumber(resultId, "highest_bidder")
							local balance = Result.getNumber(resultId, "balance")
							local lastBid = Result.getNumber(resultId, "last_bid")
							if balance >= lastBid then
									db.query("UPDATE `players` SET `balance` = " .. (balance - lastBid) .. " WHERE `id` = " .. highestBidder)
									house:setOwnerGuid(highestBidder)
							end

							db.asyncQuery("UPDATE `houses` SET `last_bid` = 0, `bid_end` = 0, `highest_bidder` = 0, `bid` = 0 " .. "WHERE `id` = " .. house:getId())
					end
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

-- Function to check duplicated variable keys and log the results
local function checkAndLogDuplicateKeys(variableNames)
	for _, variableName in ipairs(variableNames) do
			local duplicates = checkDuplicateStorageKeys(variableName)
			if duplicates then
					local message = "Duplicate keys found: " .. table.concat(duplicates, ", ")
					logger.warn("Checking " .. variableName .. ": " .. message)
			else
					logger.info("Checking " .. variableName .. ": No duplicate keys found.")
			end
	end
end

-- Function to update event rates based on EventsScheduler data
local function updateEventRates()
	local lootRate = EventsScheduler.getEventSLoot()
	if lootRate ~= 100 then
			SCHEDULE_LOOT_RATE = lootRate
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
	if expRate ~= 100 or lootRate ~= 100 or spawnRate ~= 100 or skillRate ~= 100 then
			logger.info("[Events] Exp: {}%, loot: {}%, Spawn: {}%, Skill: {}%", expRate, lootRate, spawnRate, skillRate)
	end
end

local startup = GlobalEvent("Server Initialization")

function startup.onStartup()
	logger.debug("Loaded {} npcs and spawned {} monsters", Game.getNpcCount(), Game.getMonsterCount())
	logger.debug("Loaded {} towns with {} houses in total", #Game.getTowns(), #Game.getHouses())

	resetFamiliarsMessageStorage()
	moveExpiredBansToHistory()
	processHouseAuctions()
	storeTownsInDatabase()
	checkAndLogDuplicateKeys({"Global", "GlobalStorage", "Storage"})
	updateEventRates()
	HirelingsInit()
end

startup:register()
