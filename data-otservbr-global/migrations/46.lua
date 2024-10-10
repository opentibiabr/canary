function onUpdateDatabase()
	logger.info("Updating database to version 47 (fix: rename column `tracker list` to `tracker_list`)")

	db.query([[
		ALTER TABLE `player_charms`
			CHANGE COLUMN `tracker list` tracker_list BLOB NULL;
	]])
	db.query("ALTER TABLE players MODIFY COLUMN soul TINYINT UNSIGNED NOT NULL DEFAULT 0;")
	db.query("ALTER TABLE players MODIFY COLUMN randomize_mount TINYINT UNSIGNED NOT NULL DEFAULT 0;")
	db.query("ALTER TABLE player_bosstiary MODIFY COLUMN removeTimes TINYINT UNSIGNED NOT NULL DEFAULT 1;")
	return true
end
