function onUpdateDatabase()
	logger.info("Updating database to version 46 (feat: gamestore cpp)")

	db.query([[
			ALTER TABLE `store_history`
			ADD `type` smallint(2) UNSIGNED NOT NULL DEFAULT '0'
		]])

	return true
end
