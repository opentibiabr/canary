function onUpdateDatabase()
	logger.info("Updating database to version 59 (add address family to persistent IP bans)")

	local function columnExists(tableName, columnName)
		local resultId = db.storeQuery("SHOW COLUMNS FROM `" .. tableName .. "` LIKE " .. db.escapeString(columnName) .. ";")
		if resultId then
			Result.free(resultId)
			return true
		end
		return false
	end

	local function primaryKeyHasFamilyAndAddress()
		local query = "SELECT COUNT(*) AS `count` FROM `information_schema`.`STATISTICS` WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'ip_bans' AND `INDEX_NAME` = 'PRIMARY' AND `COLUMN_NAME` IN ('ip_family', 'ip_address');"
		local resultId = db.storeQuery(query)
		if not resultId then
			return false
		end

		local count = Result.getNumber(resultId, "count")
		Result.free(resultId)
		return count == 2
	end

	if not columnExists("ip_bans", "ip_family") then
		if not db.query("ALTER TABLE `ip_bans` ADD COLUMN `ip_family` tinyint(3) UNSIGNED NOT NULL DEFAULT 4 AFTER `ip_address`;") then
			logger.error("Failed to add ip_bans.ip_family column.")
			return false
		end
	end

	-- Existing rows created by the previous IPv6 ban migration store the canonical address as text.
	-- IPv6 addresses contain ':', while legacy IPv4 rows are stored as dotted decimal strings.
	if not db.query("UPDATE `ip_bans` SET `ip_family` = CASE WHEN LOCATE(':', `ip_address`) > 0 THEN 6 ELSE 4 END;") then
		logger.error("Failed to backfill ip_bans.ip_family values.")
		return false
	end

	if primaryKeyHasFamilyAndAddress() then
		return true
	end

	if not db.query("ALTER TABLE `ip_bans` DROP PRIMARY KEY;") then
		logger.error("Failed to drop ip_bans primary key.")
		return false
	end

	if not db.query("ALTER TABLE `ip_bans` ADD PRIMARY KEY (`ip_family`, `ip_address`);") then
		logger.error("Failed to add ip_bans composite primary key.")
		return false
	end

	return true
end
