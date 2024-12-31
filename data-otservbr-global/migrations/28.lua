function onUpdateDatabase()
	logger.info("Updating database to version 28 (transfer coins)")
	db.query("ALTER TABLE `accounts` ADD `coins_transferable` int unsigned NOT NULL DEFAULT '0';")
end
