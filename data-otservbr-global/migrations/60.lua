function onUpdateDatabase()
	logger.info("Updating database to version 60 (per-channel composite identity for houses)")

	-- Step 1: add channel_id columns (default 1, so every existing house/list/tile
	-- row is implicitly assigned to Channel 1 without any data movement).
	local housesColumn = db.storeQuery("SHOW COLUMNS FROM `houses` LIKE 'channel_id';")
	if housesColumn then
		logger.warn("Column houses.channel_id already exists, skipping")
		Result.free(housesColumn)
	else
		if not db.query("ALTER TABLE `houses` ADD COLUMN `channel_id` int(11) NOT NULL DEFAULT '1';") then
			logger.error("Failed to add houses.channel_id column.")
			return false
		end
	end

	local houseListsColumn = db.storeQuery("SHOW COLUMNS FROM `house_lists` LIKE 'channel_id';")
	if houseListsColumn then
		logger.warn("Column house_lists.channel_id already exists, skipping")
		Result.free(houseListsColumn)
	else
		if not db.query("ALTER TABLE `house_lists` ADD COLUMN `channel_id` int(11) NOT NULL DEFAULT '1';") then
			logger.error("Failed to add house_lists.channel_id column.")
			return false
		end
	end

	local tileStoreColumn = db.storeQuery("SHOW COLUMNS FROM `tile_store` LIKE 'channel_id';")
	if tileStoreColumn then
		logger.warn("Column tile_store.channel_id already exists, skipping")
		Result.free(tileStoreColumn)
	else
		if not db.query("ALTER TABLE `tile_store` ADD COLUMN `channel_id` int(11) NOT NULL DEFAULT '1';") then
			logger.error("Failed to add tile_store.channel_id column.")
			return false
		end
	end

	-- Step 2: rebuild the houses primary key as (channel_id, id) and repoint the
	-- child foreign keys at the composite key. Guarded so a partially-applied
	-- run can be safely resumed: if channel_id is already part of the PRIMARY
	-- key, the structural rework below is skipped entirely.
	local alreadyComposite = db.storeQuery("SHOW KEYS FROM `houses` WHERE `Key_name` = 'PRIMARY' AND `Column_name` = 'channel_id';")
	if alreadyComposite then
		logger.warn("houses primary key is already composite (channel_id, id), skipping structural rework")
		Result.free(alreadyComposite)
		return true
	end

	if not db.query([[
		ALTER TABLE `house_lists`
			DROP FOREIGN KEY `houses_list_house_fk`;
	]]) then
		logger.error("Failed to drop house_lists foreign key.")
		return false
	end

	if not db.query([[
		ALTER TABLE `tile_store`
			DROP FOREIGN KEY `tile_store_account_fk`;
	]]) then
		logger.error("Failed to drop tile_store foreign key.")
		return false
	end

	-- `id` has always been assigned explicitly from map data (never relies on
	-- MySQL-generated values), so dropping AUTO_INCREMENT here does not change
	-- any existing insert behavior.
	if not db.query([[
		ALTER TABLE `houses`
			DROP PRIMARY KEY,
			MODIFY `id` int(11) NOT NULL,
			ADD CONSTRAINT `houses_pk` PRIMARY KEY (`channel_id`, `id`),
			ADD CONSTRAINT `houses_id_unique` UNIQUE (`id`);
	]]) then
		logger.error("Failed to rebuild houses primary key.")
		return false
	end

	if not db.query([[
		ALTER TABLE `house_lists`
			ADD CONSTRAINT `house_lists_channel_house_fk`
				FOREIGN KEY (`channel_id`, `house_id`) REFERENCES `houses` (`channel_id`, `id`)
				ON DELETE CASCADE;
	]]) then
		logger.error("Failed to re-add house_lists foreign key.")
		return false
	end

	if not db.query([[
		ALTER TABLE `tile_store`
			ADD CONSTRAINT `tile_store_channel_house_fk`
				FOREIGN KEY (`channel_id`, `house_id`) REFERENCES `houses` (`channel_id`, `id`)
				ON DELETE CASCADE;
	]]) then
		logger.error("Failed to re-add tile_store foreign key.")
		return false
	end

	return true
end
