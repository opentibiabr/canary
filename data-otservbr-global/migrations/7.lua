function onUpdateDatabase()
	logger.info("Updating database to version 7 (recruiter system)")
	db.query("ALTER TABLE `accounts` ADD `recruiter` INT(6) DEFAULT 0")
end
