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

	if not columnExists("players", "lastip_address") then
		if not db.query("ALTER TABLE `players` ADD COLUMN `lastip_address` varchar(45) NOT NULL DEFAULT '' AFTER `lastip`;") then
			logger.error("Failed to add players.lastip_address column.")
			return false
		end
	end

	db.query("UPDATE `players` SET `lastip_address` = " .. legacyIpExpression("lastip") .. " WHERE `lastip_address` = '' AND `lastip` != 0;")

	if not columnExists("ip_bans", "ip_address") then
		if not db.query("ALTER TABLE `ip_bans` ADD COLUMN `ip_address` varchar(45) NOT NULL DEFAULT '' AFTER `ip`;") then
			logger.error("Failed to add ip_bans.ip_address column.")
			return false
		end
	end

	db.query("UPDATE `ip_bans` SET `ip_address` = " .. legacyIpExpression("ip") .. " WHERE `ip_address` = '' AND `ip` != 0;")

	-- The legacy schema used ip_bans.ip as the primary key, which cannot store more than one IPv6 ban
	-- because IPv6 bans keep ip = 0 for compatibility with old IPv4-only code.
	if not db.query("ALTER TABLE `ip_bans` DROP PRIMARY KEY;") then
		logger.error("Failed to drop legacy ip_bans primary key.")
		return false
	end

	if not db.query("ALTER TABLE `ip_bans` ADD PRIMARY KEY (`ip_address`);") then
		logger.error("Failed to add ip_bans.ip_address primary key.")
		return false
	end

	if not db.query("CREATE INDEX `ip_bans_ip` ON `ip_bans` (`ip`);") then
		logger.error("Failed to create ip_bans_ip index.")
		return false
	end

	return true
end
