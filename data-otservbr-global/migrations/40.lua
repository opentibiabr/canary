function onUpdateDatabase()
	logger.info("Updating database to version 40 (optimize house_lists)")

	db.query([[
			ALTER TABLE `house_lists`
			ADD COLUMN `version` bigint NOT NULL DEFAULT 0 AFTER `listid`,
			ADD INDEX `version` (`version`),
			ADD PRIMARY KEY (`house_id`, `listid`);
		]])

	db.query([[
		ALTER TABLE `house_lists` 
		MODIFY `version` bigint(20) NOT NULL DEFAULT '0';
	]])
end
