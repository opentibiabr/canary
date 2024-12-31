function onUpdateDatabase()
	logger.info("Updating database to version 24 (random mount outfit window)")
	db.query("ALTER TABLE `players` ADD `randomize_mount` SMALLINT(1) NOT NULL DEFAULT '0'")
end
