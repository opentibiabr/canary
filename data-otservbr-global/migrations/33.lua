function onUpdateDatabase()
	Spdlog.info("Updating database to version 34 (multi-world)")
	db.query([[
		CREATE TABLE IF NOT EXISTS `worlds`(
			`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
			`name` varchar(32) NOT NULL,
			CONSTRAINT `worlds_pk` PRIMARY KEY (`id`),
			CONSTRAINT `worlds_unique` UNIQUE (`name`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])

	db.query([[
		ALTER TABLE players
			ADD COLUMN world_id int(11) unsigned not null default 1,
			ADD CONSTRAINT `world_id_fk` FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`)
			ON DELETE CASCADE
			ON UPDATE CASCADE
	]])

	db.query([[
		ALTER TABLE houses
			ADD COLUMN map_id int(25) not null,
			ADD COLUMN world_id int(11) unsigned not null default 1,
			ADD CONSTRAINT `houses_world_id_fk` FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`)
			ON DELETE CASCADE
			ON UPDATE CASCADE
	]])
		
	return true
end
