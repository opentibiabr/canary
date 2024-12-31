function onUpdateDatabase()
	logger.info("Updating database to version 23 (forge history)")
	db.query([[
		CREATE TABLE IF NOT EXISTS `forge_history` (
			`id` int NOT NULL AUTO_INCREMENT,
			`player_id` int NOT NULL,
			`action_type` int NOT NULL DEFAULT '0',
			`description` text NOT NULL,
			`is_success` tinyint NOT NULL DEFAULT '0',
			`bonus` tinyint NOT NULL DEFAULT '0',
			`done_at` bigint NOT NULL,
			`done_at_date` datetime DEFAULT NOW(),
			`cost` bigint UNSIGNED NOT NULL DEFAULT '0',
			`gained` bigint UNSIGNED NOT NULL DEFAULT '0',
			CONSTRAINT `forge_history_pk` PRIMARY KEY (`id`),
			FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])
end
