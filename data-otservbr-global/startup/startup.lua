if configManager.getString(configKeys.WORLD_CONFIGURATION) == "world" then
	-- Player storage migrations remain execution state in every mode.
	dofile(DATA_DIRECTORY .. "/startup/tables/storage_keys_update.lua")
else
	dofile(DATA_DIRECTORY .. "/startup/tables/load.lua")
end
dofile(DATA_DIRECTORY .. "/startup/others/load.lua")
