function onUpdateDatabase()
	logger.info("Updating database to version 21 (forge and tier system)")
	db.query("ALTER TABLE `market_offers` ADD `tier` tinyint UNSIGNED NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `market_history` ADD `tier` tinyint UNSIGNED NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `players` ADD `forge_dusts` bigint(21) NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `players` ADD `forge_dust_level` bigint(21) UNSIGNED NOT NULL DEFAULT '100';")
end
