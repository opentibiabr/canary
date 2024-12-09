function onUpdateDatabase()
	logger.info("Updating database to version 47 (fix: creature speed and conditions)")

	db.query("ALTER TABLE `players` MODIFY `conditions` mediumblob NOT NULL;")

	return true
end
