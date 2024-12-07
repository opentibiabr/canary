function onUpdateDatabase()
	logger.info("Updating database to version 48 (feat: animus mastery (soulpit))")

	db.query("ALTER TABLE `players` ADD `animus_mastery` mediumblob NOT NULL;")

	return true
end
