function onUpdateDatabase()
	Spdlog.info("Updating database to version 25 (random mount outfit window)")
	db.query("ALTER TABLE `players` ADD `randomize_mount` SMALLINT(1) NOT NULL DEFAULT '0'")
	return true
end
