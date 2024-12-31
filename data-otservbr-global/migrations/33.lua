function onUpdateDatabase()
	logger.info("Updating database to version 33 (add primary keys)")
	db.query([[
		ALTER TABLE `player_prey`
		ADD PRIMARY KEY (`player_id`, `slot`);
	]])
	db.query([[
		ALTER TABLE `player_taskhunt`
		ADD PRIMARY KEY (`player_id`, `slot`);
	]])
	db.query([[
		ALTER TABLE `player_items`
		ADD PRIMARY KEY (`player_id`, `sid`);
	]])
	db.query([[
		ALTER TABLE `player_spells`
		ADD PRIMARY KEY (`player_id`, `name`);
	]])
	db.query([[
		ALTER TABLE `player_stash`
		ADD PRIMARY KEY (`player_id`, `item_id`);
	]])
	db.query([[
		ALTER TABLE `player_wheeldata`
		ADD PRIMARY KEY (`player_id`);
	]])
end
