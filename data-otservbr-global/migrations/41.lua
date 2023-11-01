function onUpdateDatabase()
	logger.info("Updating database to version 42 (fix xpboost types)")

	db.query([[
		ALTER TABLE `players`
    MODIFY `xpboost_stamina` smallint(5) UNSIGNED DEFAULT NULL,
    MODIFY `xpboost_value` tinyint(4) UNSIGNED DEFAULT NULL
	]])

	return true
end
