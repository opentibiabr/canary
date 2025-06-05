function onUpdateDatabase()
	logger.info("Updating database to version 50 (feat: player death participants)")

	db.query("ALTER TABLE `player_deaths` ADD COLUMN `participants` TEXT NOT NULL DEFAULT '[]';")
end
