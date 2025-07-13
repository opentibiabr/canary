function onUpdateDatabase()
	logger.info("Updating database to version 51 (feat: player death participants)")

	db.query("ALTER TABLE `player_deaths` ADD COLUMN `participants` TEXT NOT NULL;")
end
