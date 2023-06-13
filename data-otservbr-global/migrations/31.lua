function onUpdateDatabase()
	Spdlog.info("Updating database to version 32 (account_sessions)")
	db.query([[
			CREATE TABLE IF NOT EXISTS `account_sessions` (
				`id` VARCHAR(191) NOT NULL,
				`account_id` INTEGER UNSIGNED NOT NULL,
				`expires` BIGINT UNSIGNED NOT NULL,

				PRIMARY KEY (`id`)
		) ENGINE=MEMORY DEFAULT CHARSET=utf8;
		ALTER TABLE `accounts` MODIFY `password` TEXT NOT NULL;
	]])
	return true
end
