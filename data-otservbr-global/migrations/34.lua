function onUpdateDatabase()
	Spdlog.info("Updating database to version 35 (bosstiary tracker)")
	db.query("ALTER TABLE `player_bosstiary` ADD `tracker` blob NOT NULL;")
	return true
end
