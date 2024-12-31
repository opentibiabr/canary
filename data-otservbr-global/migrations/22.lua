function onUpdateDatabase()
	logger.info("Updating database to version 22 (fix offline training skill size)")
	db.query([[
			ALTER TABLE `players`
				MODIFY offlinetraining_skill tinyint(2) NOT NULL DEFAULT '-1';
		]])
end
