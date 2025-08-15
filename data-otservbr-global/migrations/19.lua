function onUpdateDatabase()
	logger.info("Updating database to version 19 (Gamestore accepting Tournament Coins)")

	db.query("ALTER TABLE `accounts` ADD `tournament_coins` int(11) NOT NULL DEFAULT 0 AFTER `coins`")
	db.query("ALTER TABLE `store_history` ADD `coin_type` tinyint(1) NOT NULL DEFAULT 0 AFTER `description`")
	db.query("ALTER TABLE `store_history` DROP COLUMN `coins`") -- Not in use anywhere.
end
