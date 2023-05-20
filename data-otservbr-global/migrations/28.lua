function onUpdateDatabase()
	Spdlog.info("Updating database to version 29 (transfer coins)")
	db.query("ALTER TABLE `accounts` ADD `coins_transferable` UNSIGNED NOT NULL DEFAULT '0';")
	return true
end
