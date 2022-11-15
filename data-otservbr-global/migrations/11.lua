function onUpdateDatabase()
	Spdlog.info("Updating database to version 12 (Player get daily reward)")
	db.query("ALTER TABLE `players` ADD `isreward` tinyint(1) NOT NULL DEFAULT 1")
	return true
end
