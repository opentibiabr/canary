function onUpdateDatabase()
	logger.info("Updating database to version 18 (Prey system rework + Task hunting system)")
	db.query([[
		ALTER TABLE `players`
			DROP `prey_stamina_1`,
			DROP `prey_stamina_2`,
			DROP `prey_stamina_3`,
			DROP `prey_column`,
			ADD `prey_wildcard` bigint(21) NOT NULL DEFAULT 0,
			ADD `task_points` bigint(21) NOT NULL DEFAULT 0;
	]])

	db.query([[
		DROP TABLE `player_prey`;
	]])

	db.query([[
		DROP TABLE `prey_slots`;
	]])

	db.query([[
		CREATE TABLE IF NOT EXISTS `player_taskhunt` (
			`player_id` int(11) NOT NULL,
			`slot` tinyint(1) NOT NULL,
			`state` tinyint(1) NOT NULL,
			`raceid` varchar(250) NOT NULL,
			`upgrade` tinyint(1) NOT NULL,
			`rarity` tinyint(1) NOT NULL,
			`kills` varchar(250) NOT NULL,
			`disabled_time` bigint(20) NOT NULL,
			`free_reroll` bigint(20) NOT NULL,
			`monster_list` BLOB NULL
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])

	db.query([[
		CREATE TABLE IF NOT EXISTS `player_prey` (
			`player_id` int(11) NOT NULL,
			`slot` tinyint(1) NOT NULL,
			`state` tinyint(1) NOT NULL,
			`raceid` varchar(250) NOT NULL,
			`option` tinyint(1) NOT NULL,
			`bonus_type` tinyint(1) NOT NULL,
			`bonus_rarity` tinyint(1) NOT NULL,
			`bonus_percentage` varchar(250) NOT NULL,
			`bonus_time` varchar(250) NOT NULL,
			`free_reroll` bigint(20) NOT NULL,
			`monster_list` BLOB NULL
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])
end
