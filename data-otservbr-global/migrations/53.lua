function onUpdateDatabase()
	logger.info("Updating database to version 54 (feat: support to 15.00)")
	db.query([[
		ALTER TABLE `players`
		ADD `virtue` int(10) UNSIGNED NOT NULL DEFAULT '0',
		ADD `harmony` int(10) UNSIGNED NOT NULL DEFAULT '0';
	]])
end
