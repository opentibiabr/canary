function onUpdateDatabase()
	logger.info("Updating database to version 42 (fix guildwar_kills_unique)")

	db.query([[
		ALTER TABLE `guildwar_kills`
		DROP INDEX `guildwar_kills_unique`
	]])
end
