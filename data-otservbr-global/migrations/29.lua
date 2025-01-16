function onUpdateDatabase()
	logger.info("Updating database to version 30 (looktypeEx)")
	db.query("ALTER TABLE `boosted_boss` ADD `looktypeEx` int unsigned NOT NULL DEFAULT '0';")
	return true
end
