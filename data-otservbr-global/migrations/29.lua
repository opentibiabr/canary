function onUpdateDatabase()
	logger.info("Updating database to version 29 (looktypeEx)")
	db.query("ALTER TABLE `boosted_boss` ADD `looktypeEx` int unsigned NOT NULL DEFAULT '0';")
end
