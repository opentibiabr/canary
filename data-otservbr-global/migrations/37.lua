function onUpdateDatabase()
	logger.info("Updating database to version 38 (add pronoun to players)")
	db.query("ALTER TABLE `players` ADD `pronoun` int(11) NOT NULL DEFAULT '0';")
	return true
end
