function onUpdateDatabase()
	logger.info("Updating database to version 30 (loyalty)")
	db.query([[
		ALTER TABLE `accounts` ADD COLUMN `premdays_purchased` int(11) NOT NULL DEFAULT 0;
	]])
end
