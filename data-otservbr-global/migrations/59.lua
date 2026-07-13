function onUpdateDatabase()
	logger.info("Updating database to version 59 (expand Exaltation Forge dust limits)")

	if
		not db.query([[
		UPDATE `players`
		SET `forge_dust_level` = 100 + ((`forge_dust_level` - 100) * 20)
		WHERE `forge_dust_level` > 100;
	]])
	then
		logger.error("Failed to expand existing Exaltation Forge dust limits.")
		return false
	end

	return true
end
