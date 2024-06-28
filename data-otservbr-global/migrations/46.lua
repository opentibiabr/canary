function onUpdateDatabase()
	logger.info("Updating database to version 47 (fix: rename column `tracker list` to `tracker_list`)")

	db.query([[
		ALTER TABLE `player_charms`
			CHANGE COLUMN `tracker list` tracker_list BLOB NULL;
	]])
	return true
end
