function onUpdateDatabase()
	logger.info("Updating database to version 44 (fix: mana shield column size for more than 65k)")

	db.query([[
			ALTER TABLE `players`
    	MODIFY COLUMN `manashield` INT UNSIGNED NOT NULL DEFAULT '0',
    	MODIFY COLUMN `max_manashield` INT UNSIGNED NOT NULL DEFAULT '0';
	]])
end
