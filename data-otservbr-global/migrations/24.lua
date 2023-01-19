function onUpdateDatabase()
	Spdlog.info("Updating database to version 25 (binary player items load and save")
	db.query("INSERT INTO `server_config` (`config`, `value`) VALUES ('binary_items', '0')");
	db.query("ALTER TABLE `players` ADD `charm_points` bigint(21) NOT NULL;")
	db.query("ALTER TABLE `players` ADD `charm_upgrade` BOOLEAN NOT NULL;")

	-- Table structure `player_bin_data`
	db.query([[
	CREATE TABLE IF NOT EXISTS `player_bin_data` (
		`player_id` int(11) NOT NULL,
		`id` int(11) NOT NULL AUTO_INCREMENT,
		`inventory` longblob NOT NULL,
		`depot` longblob NOT NULL,
		`inbox` longblob NOT NULL,
		`stash` longblob NOT NULL,
		`reward` longblob NOT NULL,
		`systems` longblob NOT NULL,
		INDEX `player_id` (`player_id`),
		CONSTRAINT `player_bin_data_pk` PRIMARY KEY (`id`),
		CONSTRAINT `player_bin_data_players_fk`
			FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
			ON DELETE CASCADE
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;]])
	return true
end
