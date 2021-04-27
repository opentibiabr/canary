function onUpdateDatabase()
    Spdlog.info("Updating database to version 15 (Magic Shield Spell)")
	db.query("ALTER TABLE `players` ADD `manashield` SMALLINT UNSIGNED NOT NULL DEFAULT '0' AFTER `skill_manaleech_amount`")
	db.query("ALTER TABLE `players` ADD `max_manashield` SMALLINT UNSIGNED NOT NULL DEFAULT '0' AFTER `manashield`")
	return true
end
