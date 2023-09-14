function onUpdateDatabase()
	Spdlog.info("Updating database to version 3 (account refactor)")

	db.query([[
		LOCK TABLES
			players WRITE,
			account_bans WRITE,
			account_ban_history WRITE,
			account_viplist WRITE,
			store_history WRITE,
			accounts WRITE;
	]])

	db.query([[
		ALTER TABLE `players`
			DROP FOREIGN KEY `players_account_fk`,
			MODIFY account_id int(11) UNSIGNED NOT NULL;
	]])

	db.query([[
		ALTER TABLE `account_bans`
			DROP PRIMARY KEY,
			DROP FOREIGN KEY `account_bans_account_fk`,
			MODIFY `account_id` int(11) UNSIGNED NOT NULL;
	]])

	db.query([[
		ALTER TABLE `account_ban_history`
			DROP FOREIGN KEY `account_bans_history_account_fk`,
			MODIFY `account_id` int(11) UNSIGNED NOT NULL;
	]])

	db.query([[
		ALTER TABLE `account_viplist`
			DROP INDEX `account_viplist_unique`,
			DROP FOREIGN KEY `account_viplist_account_fk`,
			MODIFY `account_id` int(11) UNSIGNED NOT NULL;
	]])

	db.query([[
		ALTER TABLE `store_history`
			DROP FOREIGN KEY `store_history_account_fk`,
			MODIFY `account_id` int(11) UNSIGNED NOT NULL;
	]])

	db.query([[
		ALTER TABLE `accounts`
			MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
			MODIFY `type` tinyint(1) UNSIGNED NOT NULL DEFAULT '1',
			MODIFY `coins` int(12) UNSIGNED NOT NULL DEFAULT '0',
			MODIFY `creation` int(11) UNSIGNED NOT NULL DEFAULT '0';
	]])

	db.query([[
		ALTER TABLE `players`
			ADD CONSTRAINT `players_account_fk`
			FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
				ON DELETE CASCADE;
	]])

	db.query([[
		ALTER TABLE `account_bans`
			ADD CONSTRAINT `account_bans_pk` PRIMARY KEY (`account_id`),
			ADD CONSTRAINT `account_bans_account_fk`
			FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
				ON DELETE CASCADE
				ON UPDATE CASCADE;
	]])

	db.query([[
		ALTER TABLE `account_ban_history`
			ADD CONSTRAINT `account_bans_history_account_fk`
			FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
				ON DELETE CASCADE
				ON UPDATE CASCADE;
	]])

	db.query([[
		ALTER TABLE `account_viplist`
			ADD CONSTRAINT `account_viplist_unique` UNIQUE (`account_id`, `player_id`),
			ADD CONSTRAINT `account_viplist_account_fk`
				FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
					ON DELETE CASCADE;
	]])

	db.query([[
		ALTER TABLE `store_history`
			ADD CONSTRAINT `store_history_account_fk`
				FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
					ON DELETE CASCADE;
	]])

	db.query([[
		UNLOCK TABLES;
	]])

	db.query([[
		CREATE TABLE IF NOT EXISTS `coins_transactions` (
				`id`          int(11)       UNSIGNED NOT NULL AUTO_INCREMENT,
				`account_id`  int(11)       UNSIGNED NOT NULL,
				`type`        tinyint(1)    UNSIGNED NOT NULL,
				`amount`      int(12)       UNSIGNED NOT NULL,
				`description` varchar(3500) NOT NULL,
				`timestamp`   timestamp     DEFAULT CURRENT_TIMESTAMP,
				INDEX `account_id` (`account_id`),
				CONSTRAINT `coins_transactions_pk` PRIMARY KEY (`id`),
				CONSTRAINT `coins_transactions_account_fk`
					FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
						ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])

	return true
end
