function onUpdateDatabase()
	logger.info("Updating database to version 34 (bosstiary tracker)")
	db.query("ALTER TABLE `player_bosstiary` ADD `tracker` blob NOT NULL;")
end
