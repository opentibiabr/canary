function onUpdateDatabase()
	logger.info("Updating database to version 17 (Fix guild creation myaac)")
	db.query("ALTER TABLE `guilds` ADD `level` int(11) NOT NULL DEFAULT 1")
	db.query("ALTER TABLE `guilds` ADD `points` int(11) NOT NULL DEFAULT 0")
end
