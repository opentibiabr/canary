function onUpdateDatabase()
	Spdlog.info("Updating database to version 21 (Fix market price size)")
	db.query("ALTER TABLE `market_history` CHANGE `price` `price` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `market_offers` CHANGE `price` `price` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0';")
	return true
end
