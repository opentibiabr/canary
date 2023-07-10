function onUpdateDatabase()
	Spdlog.info("Updating database to version 23 (fix offline training skill size)")
	db.query(
		[[
			ALTER TABLE `players`
				MODIFY offlinetraining_skill tinyint(2) NOT NULL DEFAULT '-1';
		]]
	)
	return true
end
