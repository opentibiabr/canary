local function loadMapAttributes()
	logger.debug("Loading map attributes")

	-- Sign table
	loadLuaMapSign(SignTable)
	logger.debug("Loaded {} signs in the map", #SignTable)

	-- Book/Document table
	loadLuaMapBookDocument(BookDocumentTable)

	-- Action and unique tables
	loadMapActionsAndUniques()

	logger.debug("Loaded all actions and uniques in the map")
end

local function loadMapActionsAndUniques()
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
	-- This is temporarily disabled > loadLuaMapAction(DailyRewardAction)
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
end

local function resetGlobalStorages()
	for i = 1, #startupGlobalStorages do
		Game.setStorageValue(startupGlobalStorages[i], 0)
	end
end

local function resetFerumbrasAscendantQuestHabitats()
	-- Ferumbras Ascendant quest
	for i = 1, #GlobalStorage.FerumbrasAscendant.Habitats do
		local storage = GlobalStorage.FerumbrasAscendant.Habitats[i]
		Game.setStorageValue(storage, 0)
	end
end

local serverstartup = GlobalEvent("serverstartup")

function serverstartup.onStartup()
	loadMapAttributes()
	resetGlobalStorages()
	resetFerumbrasAscendantQuestHabitats()
end

serverstartup:register()
