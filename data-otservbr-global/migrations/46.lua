function onUpdateDatabase()
	logger.info("Updating database to version 47 (migrate gamestore to cpp)")

	db.query([[
			ALTER TABLE `store_history`
			ADD `type` smallint(2) UNSIGNED NOT NULL DEFAULT '0',
			ADD `show_detail` smallint(2) UNSIGNED NOT NULL DEFAULT '0',
			CHANGE `timestamp` `player_name` varchar(255) DEFAULT NULL,
			CHANGE `coins` `total_price` bigint NOT NULL DEFAULT '0',
			CHANGE `time` `created_at` bigint UNSIGNED NOT NULL DEFAULT '0'
		]])

	return true
end
