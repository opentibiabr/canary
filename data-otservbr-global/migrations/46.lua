function onUpdateDatabase()
	logger.info("Updating database to version 47 (cast system)")
	db.query([[
		CREATE TABLE IF NOT EXISTS `active_casters` (
			`caster_id` INT NOT NULL AUTO_INCREMENT,
			`cast_viewers` TINYINT(4) UNSIGNED NOT NULL DEFAULT '0',
			`cast_status` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
			PRIMARY KEY (`caster_id`)
		);
	]])

	return true
end
