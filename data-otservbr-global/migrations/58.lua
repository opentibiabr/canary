function onUpdateDatabase()
	logger.info("Updating database to version 58 (add active livestream casters table)")

	if db.tableExists("active_livestream_casters") then
		logger.warn("Table active_livestream_casters already exists, skipping migration")
		return true
	end

	if
		not db.query([[
		CREATE TABLE `active_livestream_casters` (
			`caster_id` int(11) NOT NULL,
			`livestream_status` tinyint(1) UNSIGNED NOT NULL DEFAULT '0',
			`livestream_viewers` int(11) UNSIGNED NOT NULL DEFAULT '0',
			CONSTRAINT `active_livestream_casters_pk` PRIMARY KEY (`caster_id`),
			CONSTRAINT `active_livestream_casters_players_fk`
				FOREIGN KEY (`caster_id`) REFERENCES `players` (`id`)
				ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])
	then
		logger.error("Failed to create active_livestream_casters table.")
		return false
	end

	return true
end
