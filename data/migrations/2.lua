function onUpdateDatabase()
	Spdlog.info("Updating database to version 3 (Add tier table to market_offers)")
	db.query("ALTER TABLE `market_offers` ADD `tier` smallint UNSIGNED NOT NULL DEFAULT '0';")
	return true
end
