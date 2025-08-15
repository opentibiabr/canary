function onUpdateDatabase()
	logger.info("Updating database to version 37 (add pronoun to players)")
	db.query("ALTER TABLE `players` ADD `pronoun` int(11) NOT NULL DEFAULT '0';")
end
