function onUpdateDatabase()
	logger.info("Updating database to version 37 (add coin_type to accounts)")
	db.query("ALTER TABLE `coins_transactions` ADD `coin_type` tinyint(1) UNSIGNED NOT NULL DEFAULT '1';")
	return true
end
