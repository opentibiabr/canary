function onUpdateDatabase()
	logger.info("Updating database to version 59 (add player expert pvp mode column)")

	local column = db.storeQuery("SHOW COLUMNS FROM `players` LIKE 'expert_pvp_mode';")
	if column then
		logger.warn("Column players.expert_pvp_mode already exists, skipping migration")
		Result.free(column)
		return true
	end

	if not db.query("ALTER TABLE `players` ADD COLUMN `expert_pvp_mode` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' AFTER `skulltime`;") then
		logger.error("Failed to add players.expert_pvp_mode column.")
		return false
	end

	return true
end
