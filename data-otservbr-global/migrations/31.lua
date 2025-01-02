function onUpdateDatabase()
	logger.info("Updating database to version 31 (account_sessions)")
	db.query([[
		CREATE TABLE IF NOT EXISTS `account_sessions` (
			`id` VARCHAR(191) NOT NULL,
			`account_id` INTEGER UNSIGNED NOT NULL,
			`expires` BIGINT UNSIGNED NOT NULL,

			PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])
	-- Switch to TEXT to allow longer passwords (such as bcrypt encrypted)
	db.query([[
		ALTER TABLE `accounts` MODIFY `password` TEXT NOT NULL;
	]])
end
