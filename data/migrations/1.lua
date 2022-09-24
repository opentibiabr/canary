function onUpdateDatabase()
	Spdlog.info("Updating database to version 2 (Offline Training size)")
	db.query(
		[[
			ALTER TABLE `players`
				MODIFY offlinetraining_skill tinyint(1) NOT NULL DEFAULT '-1';
		]]
	)

	return true
end
