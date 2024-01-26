function onUpdateDatabase()
	logger.info("Updating database to version 43 (feat frags and payment in war system)")

	db.query([[
			ALTER TABLE `guild_wars`
			ADD `frags_limit` smallint(4) UNSIGNED NOT NULL DEFAULT '0',
			ADD `payment` bigint(13) UNSIGNED NOT NULL DEFAULT '0',
			ADD `duration_days` tinyint(3) UNSIGNED NOT NULL DEFAULT '0'
		]])

	return true
end
