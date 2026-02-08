function onUpdateDatabase()
	logger.info("Updating database to version 54 (set god to account type 6)")

	local updateAccounts = db.query([[UPDATE accounts SET type = 6 WHERE type = 5;]])

	if not updateAccounts then
		logger.error("Failed to migrate god type values to 6.")
		return false
	end

	return true
end
