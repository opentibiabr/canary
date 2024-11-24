function onUpdateDatabase()
	logger.info("Updating database to version 48 (player bosstiary and player kills unique key)")

	db.query([[
		ALTER TABLE `player_bosstiary`
		ADD PRIMARY KEY (`player_id`)
	]])

	db.query([[
		ALTER TABLE `player_kills`
		ADD PRIMARY KEY (`player_id`, `target`, `time`);
	]])

	return true
end
