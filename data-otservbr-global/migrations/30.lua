function onUpdateDatabase()
	Spdlog.info("Updating database to version 31 (allow longer password)")
	-- Switch to TEXT to allow longer passwords (such as bcrypt encrypted)
	db.query([[
		ALTER TABLE `accounts` MODIFY `password` TEXT NOT NULL;
	]])
	return true
end
