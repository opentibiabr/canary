local serverstartup = GlobalEvent("serverstartup")
function serverstartup.onStartup()
	logger.debug("Loading map attributes")

	-- Sign table
	loadLuaMapSign(SignTable)
	logger.debug("Loaded {} signs in the map", #SignTable)
	-- Book/Document table
	loadLuaMapBookDocument(BookDocumentTable)

	-- Action and unique tables
	-- Chest table
	loadLuaMapAction(ChestAction)
	loadLuaMapUnique(ChestUnique)
	-- Corpse table
	loadLuaMapAction(CorpseAction)
	loadLuaMapUnique(CorpseUnique)
	-- Doors key table
	loadLuaMapAction(KeyDoorAction)
	-- Doors level table
	loadLuaMapAction(LevelDoorAction)
	-- Doors quest table
	loadLuaMapAction(QuestDoorAction)
	loadLuaMapUnique(QuestDoorUnique)
	-- Item table
	loadLuaMapAction(ItemAction)
	loadLuaMapUnique(ItemUnique)
	-- Item daily reward table
	-- This is temporary disabled > loadLuaMapAction(DailyRewardAction)
	-- Item unmovable table
	loadLuaMapAction(ItemUnmovableAction)
	-- Lever table
	loadLuaMapAction(LeverAction)
	loadLuaMapUnique(LeverUnique)
	-- Teleport (magic forcefields) table
	loadLuaMapAction(TeleportAction)
	loadLuaMapUnique(TeleportUnique)
	-- Teleport item table
	loadLuaMapAction(TeleportItemAction)
	loadLuaMapUnique(TeleportItemUnique)
	-- Tile table
	loadLuaMapAction(TileAction)
	loadLuaMapUnique(TileUnique)
	-- Tile pick table
	loadLuaMapAction(TilePickAction)
	-- Create new item on map
	CreateMapItem(CreateItemOnMap)
	-- Update old quest storage keys
	updateKeysStorage(QuestKeysUpdate)

	logger.debug("Loaded all actions in the map")
	logger.debug("Loaded all uniques in the map")

	for i = 1, #startupGlobalStorages do
		Game.setStorageValue(startupGlobalStorages[i], 0)
	end

	local time = os.time()
	db.asyncQuery("TRUNCATE TABLE `players_online`")

	local resetSessionsOnStartup = configManager.getBoolean(configKeys.RESET_SESSIONS_ON_STARTUP)
	if AUTH_TYPE == "session" then
		if resetSessionsOnStartup then
			db.query("TRUNCATE TABLE `account_sessions`")
		else
			db.query("DELETE FROM `account_sessions` WHERE `expires` <= " .. time)
		end
	end

	-- reset Daily Reward status
	db.query("UPDATE `players` SET `isreward` = " .. DAILY_REWARD_NOTCOLLECTED)

	-- reset storages and allow purchase of boost in the store
	db.query("UPDATE `player_storage` SET `value` = 0 WHERE `player_storage`.`key` = 51052")

	-- delete canceled and rejected guilds
	db.asyncQuery("DELETE FROM `guild_wars` WHERE `status` = 2")
	db.asyncQuery("DELETE FROM `guild_wars` WHERE `status` = 3")

	-- Delete guilds that are pending for 3 days
	db.asyncQuery("DELETE FROM `guild_wars` WHERE `status` = 0 AND (`started` + 72 * 60 * 60) <= " .. os.time())

	db.asyncQuery("DELETE FROM `players` WHERE `deletion` != 0 AND `deletion` < " .. time)
	db.asyncQuery("DELETE FROM `ip_bans` WHERE `expires_at` != 0 AND `expires_at` <= " .. time)
	db.asyncQuery("DELETE FROM `market_history` WHERE `inserted` <= \z
	" .. (time - configManager.getNumber(configKeys.MARKET_OFFER_DURATION)))

	-- Ferumbras Ascendant quest
	for i = 1, #GlobalStorage.FerumbrasAscendant.Habitats do
		local storage = GlobalStorage.FerumbrasAscendant.Habitats[i]
		Game.setStorageValue(storage, 0)
	end
end

serverstartup:register()
