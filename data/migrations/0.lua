function onUpdateDatabase()
	Spdlog.info("Updating database to version 1 (store c++)")
	db.query("ALTER TABLE `accounts` ADD `tournament_coins` INT(11) NOT NULL DEFAULT 0")
	db.query("DROP TABLE `coins_transactions`")
	db.query([[CREATE TABLE IF NOT EXISTS `store_history` (`account_id` int(11) NOT NULL, `mode` smallint(2) NOT NULL DEFAULT '0', `description` VARCHAR(3500) NOT NULL, `coin_amount` int(12) NOT NULL, `time` bigint(20) unsigned NOT NULL, KEY `account_id` (`account_id`), FOREIGN KEY (`account_id`) REFERENCES `accounts`(`id`) ON DELETE CASCADE) ENGINE=InnoDB;]])
	return true
end
