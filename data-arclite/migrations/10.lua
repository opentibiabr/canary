function onUpdateDatabase()
	Spdlog.info("Updating database to version 11 (Guilds Balance)")
	db.query("ALTER TABLE `guilds` ADD `balance` bigint(20) UNSIGNED NOT NULL DEFAULT '0';")
	return true
end
