function onUpdateDatabase()
	Spdlog.info("Updating database to version 1 (store c++)")
	db.query("ALTER TABLE `accounts` ADD `tournament_coins` int(11) NOT NULL DEFAULT 0")
	db.query("ALTER TABLE `coins_transactions` ADD `coin_type` tinyint(1) NOT NULL DEFAULT 0")
	return true
end
