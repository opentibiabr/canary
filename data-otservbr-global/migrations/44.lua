function onUpdateDatabase()
	db.query("ALTER TABLE `players` MODIFY COLUMN `manashield` INT UNSIGNED NOT NULL DEFAULT '0'")
	db.query("ALTER TABLE `players` MODIFY COLUMN `max_manashield` INT UNSIGNED NOT NULL DEFAULT '0'")
	return true
end
