function onUpdateDatabase()
	logger.info("Updating database to version 49 (feat: animus mastery (soulpit))")

	db.query("ALTER TABLE `players` ADD `animus_mastery` mediumblob DEFAULT NULL;")
end
