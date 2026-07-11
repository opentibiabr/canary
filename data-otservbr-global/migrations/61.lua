function onUpdateDatabase()
	logger.info("Updating database to version 61 (channel_switch_audit consumption tracking)")

	-- Purely additive, nullable column: NULL means "not yet consumed by the
	-- target channel's login", a timestamp means the resolved position from
	-- this row was already applied once and must not be reused by a later,
	-- unrelated login to the same channel (see docs/multichannel/
	-- ARCHITECTURE.md §6).
	local column = db.storeQuery("SHOW COLUMNS FROM `channel_switch_audit` LIKE 'consumed_at';")
	if column then
		logger.warn("Column channel_switch_audit.consumed_at already exists, skipping")
		Result.free(column)
		return true
	end

	if not db.query("ALTER TABLE `channel_switch_audit` ADD COLUMN `consumed_at` bigint(20) DEFAULT NULL;") then
		logger.error("Failed to add channel_switch_audit.consumed_at column.")
		return false
	end

	return true
end
