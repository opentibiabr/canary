function onUpdateDatabase()
	Spdlog.info("Updating database to version 29 (towns to show in house's page)")
	db.query("ALTER TABLE `towns` ADD `show_site` BOOLEAN NOT NULL DEFAULT TRUE;")
	return true
end
