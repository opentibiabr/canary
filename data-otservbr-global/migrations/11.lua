function onUpdateDatabase()
	logger.info("Updating database to version 11 (Player get daily reward)")
	db.query("ALTER TABLE `players` ADD `isreward` tinyint(1) NOT NULL DEFAULT 1")
end
