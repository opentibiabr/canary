function onUpdateDatabase()
	logger.info("Updating database to version 5 (quickloot)")
	db.query("ALTER TABLE `players` ADD `quickloot_fallback` TINYINT DEFAULT 0")
end
