function onUpdateDatabase()
	logger.info("Updating database to version 47 (multiworld system)")

	db.query("ALTER TABLE `server_config` ADD `worldId` INT(11) NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `boosted_creature` ADD `worldId` INT(11) NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `boosted_boss` ADD `worldId` INT(11) NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `player_bosstiary` ADD `worldId` INT(11) NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `players_online` ADD `worldId` INT(11) NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `players` ADD `worldId` INT(11) NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `houses` ADD `worldId` INT(11) NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `house_lists` ADD `worldId` INT(11) NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `account_viplist` ADD `worldId` INT(11) NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `tile_store` ADD `worldId` INT(11) NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `market_offers` ADD `worldId` INT(11) NOT NULL DEFAULT '0';")
	db.query("ALTER TABLE `market_history` ADD `worldId` INT(11) NOT NULL DEFAULT '0';")

	return true
end
