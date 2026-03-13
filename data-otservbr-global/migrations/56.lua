function onUpdateDatabase()
	logger.info("Updating database to version 56 (feat: accounts email + password indexes)")

	db.query("CREATE INDEX `accounts_email` ON `accounts` (`email`);")
	db.query("CREATE INDEX `accounts_password` ON `accounts` (`password`);")
end
