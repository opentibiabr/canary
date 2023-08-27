function onUpdateDatabase()
	logger.info("Updating database to version 36 (myacc phone)")
	db.query("ALTER TABLE `accounts` ADD `phone` VARCHAR(15) NULL AFTER `rlname`;")
	return true
	
end