function onUpdateDatabase()
	logger.info("Updating database to version 38 (create kv store)")
	db.query([[
		CREATE TABLE IF NOT EXISTS `kv_store` (
			`key_name` varchar(191) NOT NULL,
			`timestamp` bigint NOT NULL,
			`value` longblob NOT NULL,
			PRIMARY KEY (`key_name`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])
end
