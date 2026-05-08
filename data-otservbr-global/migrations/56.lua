function onUpdateDatabase()
	logger.info("Updating database to version 56 (feat: accounts email + password indexes)")

	if not db.query("ALTER TABLE `accounts` MODIFY `password` VARCHAR(255) NOT NULL;") then
		logger.error("Failed to modify password field.")
	end

	if not db.query("CREATE INDEX `accounts_email` ON `accounts` (`email`);") then
		logger.error("Failed to create accounts email index.")
	end

	if not db.query("CREATE INDEX `accounts_password` ON `accounts` (`password`);") then
		logger.error("Failed to create accounts password index.")
	end
end
