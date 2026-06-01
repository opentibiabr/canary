function onUpdateDatabase()
	logger.info("Updating database to version 57 (add players comment column)")

	local column = db.storeQuery("SHOW COLUMNS FROM `players` LIKE 'comment';")
	if column then
		logger.warn("Column players.comment already exists, skipping migration")
		Result.free(column)
		return true
	end

	if not db.query("ALTER TABLE `players` ADD COLUMN `comment` varchar(255) NOT NULL DEFAULT '' AFTER `boss_points`;") then
		logger.error("Failed to add players.comment column.")
		return false
	end

	return true
end
