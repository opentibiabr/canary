function onUpdateDatabase()
	logger.info("Updating database to version 58 (add persistent IPv6 IP ban support)")

	local function columnExists(tableName, columnName)
		local resultId = db.storeQuery("SHOW COLUMNS FROM `" .. tableName .. "` LIKE " .. db.escapeString(columnName) .. ";")
		if resultId then
			Result.free(resultId)
			return true
		end
		return false
	end

	local function legacyIpExpression(columnName)
		return "CONCAT((`" .. columnName .. "` & 255), '.', ((`" .. columnName .. "` >> 8) & 255), '.', ((`" .. columnName .. "` >> 16) & 255), '.', ((`" .. columnName .. "` >> 24) & 255))"
	end

	local function primaryKeyExists()
		local resultId = db.storeQuery("SELECT COUNT(*) AS `count` FROM `information_schema`.`STATISTICS` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'ip_bans' AND `INDEX_NAME` = 'PRIMARY';")
		if not resultId then
			return false
		end

		local count = Result.getNumber(resultId, "count")
		Result.free(resultId)
		return count > 0
	end

	local function primaryKeyIsOnIpAddress()
		local resultId = db.storeQuery("SELECT COUNT(*) AS `count` FROM `information_schema`.`STATISTICS` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'ip_bans' AND `INDEX_NAME` = 'PRIMARY';")
		if not resultId then
			return false
		end

		local primaryKeyColumnCount = Result.getNumber(resultId, "count")
		Result.free(resultId)
		if primaryKeyColumnCount ~= 1 then
			return false
		end

		resultId = db.storeQuery("SELECT COUNT(*) AS `count` FROM `information_schema`.`STATISTICS` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'ip_bans' AND `INDEX_NAME` = 'PRIMARY' AND `COLUMN_NAME` = 'ip_address';")
		if not resultId then
			return false
		end

		local count = Result.getNumber(resultId, "count")
		Result.free(resultId)
		return count == 1
	end

	local function indexExists(tableName, indexName)
		local resultId = db.storeQuery("SELECT COUNT(*) AS `count` FROM `information_schema`.`STATISTICS` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = " .. db.escapeString(tableName) .. " AND `INDEX_NAME` = " .. db.escapeString(indexName) .. ";")
		if not resultId then
			return false
		end

		local count = Result.getNumber(resultId, "count")
		Result.free(resultId)
		return count > 0
	end

	if not columnExists("players", "lastip_address") then
		if not db.query("ALTER TABLE `players` ADD COLUMN `lastip_address` varchar(45) NOT NULL DEFAULT '' AFTER `lastip`;") then
			logger.error("Failed to add players.lastip_address column.")
			return false
		end
	end

	if not db.query("UPDATE `players` SET `lastip_address` = " .. legacyIpExpression("lastip") .. " WHERE `lastip_address` = '' AND `lastip` != 0;") then
		logger.error("Failed to backfill players.lastip_address values.")
		return false
	end

	if not columnExists("ip_bans", "ip_address") then
		if not db.query("ALTER TABLE `ip_bans` ADD COLUMN `ip_address` varchar(45) NOT NULL DEFAULT '' AFTER `ip`;") then
			logger.error("Failed to add ip_bans.ip_address column.")
			return false
		end
	end

	if not db.query("UPDATE `ip_bans` SET `ip_address` = " .. legacyIpExpression("ip") .. " WHERE `ip_address` = '' AND `ip` != 0;") then
		logger.error("Failed to backfill ip_bans.ip_address values.")
		return false
	end

	-- The legacy schema used ip_bans.ip as the primary key, which cannot store more than one IPv6 ban
	-- because IPv6 bans keep ip = 0 for compatibility with old IPv4-only code.
	if not primaryKeyIsOnIpAddress() then
		if primaryKeyExists() then
			if not db.query("ALTER TABLE `ip_bans` DROP PRIMARY KEY, ADD PRIMARY KEY (`ip_address`);") then
				logger.error("Failed to migrate ip_bans primary key to ip_address.")
				return false
			end
		elseif not db.query("ALTER TABLE `ip_bans` ADD PRIMARY KEY (`ip_address`);") then
			logger.error("Failed to add ip_bans.ip_address primary key.")
			return false
		end
	end

	if not indexExists("ip_bans", "ip_bans_ip") then
		if not db.query("CREATE INDEX `ip_bans_ip` ON `ip_bans` (`ip`);") then
			logger.error("Failed to create ip_bans_ip index.")
			return false
		end
	end

	return true
end
