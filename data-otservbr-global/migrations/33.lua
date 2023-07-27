function onUpdateDatabase()
	Spdlog.info("Updating database to version 34 (create vip system columns)")
	db.query(
		[[
			ALTER TABLE `accounts`
				ADD COLUMN `vipdays` int(11) NOT NULL DEFAULT 0 AFTER `lastday`,
				ADD COLUMN `viplastday` int(10) NOT NULL DEFAULT 0 AFTER `vipdays`;
		]]
	)
	return true
end
