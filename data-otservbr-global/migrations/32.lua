function onUpdateDatabase()
	logger.info("Updating database to version 32 (wheel of destiny)")
	db.query([[
	CREATE TABLE IF NOT EXISTS `player_wheeldata` (
		`player_id` int(11) NOT NULL,
		`slot` blob NOT NULL,
		INDEX `player_id` (`player_id`),
		CONSTRAINT `player_wheeldata_players_fk`
			FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
			ON DELETE CASCADE
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])
end
