-- Compatibility routing only. World values live in world/*.json.
local legacyWorldTables = {
	ChestAction = "chest.lua",
	ChestUnique = "chest.lua",
	CorpseAction = "corpse.lua",
	CorpseUnique = "corpse.lua",
	CreateItemOnMap = "create_item.lua",
	KeyDoorAction = "door_key.lua",
	LevelDoorAction = "door_level.lua",
	QuestDoorAction = "door_quest.lua",
	QuestDoorUnique = "door_quest.lua",
	ItemAction = "item.lua",
	ItemUnique = "item.lua",
	DailyRewardAction = "item_daily_reward.lua",
	ItemUnmovableAction = "item_unmovable.lua",
	LeverAction = "lever.lua",
	LeverUnique = "lever.lua",
	TeleportAction = "teleport.lua",
	TeleportUnique = "teleport.lua",
	TeleportItemAction = "teleport_item.lua",
	TeleportItemUnique = "teleport_item.lua",
	TileAction = "tile.lua",
	TileUnique = "tile.lua",
	TilePickAction = "tile_pick.lua",
	BookDocumentTable = "writeable.lua",
	SignTable = "writeable.lua",
}

local function legacyWorldSource(tablename)
	for name, file in pairs(legacyWorldTables) do
		if rawget(_G, name) == tablename then
			return { file = DATA_DIRECTORY .. "/startup/tables/" .. file, name = name }
		end
	end
	return { file = DATA_DIRECTORY .. "/startup/others/functions.lua", name = "<custom>" }
end

local function allowLegacyWorld(source, index, occurrence, responsibility, item, position, itemId)
	return Game.canApplyLegacyWorld(source.file, source.name, tostring(index), occurrence, responsibility, itemId or (item and item:getId()) or 0, position, item)
end

-- This function load the table "CreateItemOnMap"from script "create_item.lua"
-- Basically it works to create items on the map without the need to edit the map
function CreateMapItem(tablename)
	local source = legacyWorldSource(tablename)
	for index, value in pairs(tablename) do
		for i = 1, #value.itemPos do
			local tile = Tile(value.itemPos[i])
			-- Checks if the position is valid
			if tile then
				if tile:getItemCountById(index) == 0 and allowLegacyWorld(source, index, tostring(i) .. ".item", "creation", nil, value.itemPos[i], index) then
					Game.createItem(index, 1, value.itemPos[i])
				end
			end
		end
	end
	logger.debug("Created all items in the map")
end

-- These functions load the action/unique tables on the map
function loadLuaMapAction(tablename)
	local source = legacyWorldSource(tablename)
	-- It load actions
	for index, value in pairs(tablename) do
		for i = 1, #value.itemPos do
			local tile = Tile(value.itemPos[i])
			local item
			-- Checks if the position is valid
			if tile then
				-- Checks that you have no items created
				if not value.itemId == false and tile:getItemCountById(value.itemId) == 0 then
					logger.error("[loadLuaMapAction] - Wrong item id {} found", value.itemId)
					logger.warn("Action id: {}, position {}", index, tile:getPosition():toString())
					goto continue
				end

				if value.itemId ~= false and tile:getItemCountById(value.itemId) > 0 then
					item = tile:getItemById(value.itemId)
				end

				-- If he found the item, add the action id.
				if item and value.itemId ~= false and allowLegacyWorld(source, index, tostring(i) .. ".item", "attributes.aid", item, value.itemPos[i]) then
					item:setAttribute(ITEM_ATTRIBUTE_ACTIONID, index)
				end
				if value.itemId == false and tile:getTopDownItem() and allowLegacyWorld(source, index, tostring(i) .. ".topDown", "attributes.aid", tile:getTopDownItem(), value.itemPos[i]) then
					tile:getTopDownItem():setAttribute(ITEM_ATTRIBUTE_ACTIONID, index)
				end
				if value.itemId == false and tile:getTopTopItem() and allowLegacyWorld(source, index, tostring(i) .. ".topTop", "attributes.aid", tile:getTopTopItem(), value.itemPos[i]) then
					tile:getTopTopItem():setAttribute(ITEM_ATTRIBUTE_ACTIONID, index)
				end
				if value.itemId == false and tile:getGround() and allowLegacyWorld(source, index, tostring(i) .. ".ground", "attributes.aid", tile:getGround(), value.itemPos[i]) then
					tile:getGround():setAttribute(ITEM_ATTRIBUTE_ACTIONID, index)
				end
			end
			::continue::
		end
	end
end

function loadLuaMapUnique(tablename)
	local source = legacyWorldSource(tablename)
	-- It load uniques
	for index, value in pairs(tablename) do
		local tile = Tile(value.itemPos)
		local item
		-- Checks if the position is valid
		if tile then
			-- Checks that you have no items created
			if not value.itemId == false and tile:getItemCountById(value.itemId) == 0 then
				logger.error("[loadLuaMapUnique] - Wrong item id {} found", value.itemId)
				logger.warn("Unique id: {}, position {}", index, tile:getPosition():toString())
				goto continue
			end
			if tile:getItemCountById(value.itemId) < 1 or value.itemId == false then
				logger.warn("[loadLuaMapUnique] - Wrong item id {} found", value.itemId)
				logger.warn("Unique id: {}, position {}, item id: wrong", index, tile:getPosition():toString())
				goto continue
			end
			item = tile:getItemById(value.itemId)
			-- If he found the item, add the unique id
			if item and allowLegacyWorld(source, index, "item", "attributes.uid", item, value.itemPos) then
				item:setAttribute(ITEM_ATTRIBUTE_UNIQUEID, index)
			end
		end

		::continue::
	end
end

function loadLuaMapSign(tablename)
	local source = legacyWorldSource(tablename)
	-- It load signs on map table
	for index, value in pairs(tablename) do
		local tile = Tile(value.itemPos)
		local item
		-- Checks if the position is valid
		if tile then
			-- Checks that you have no items created
			if tile:getItemCountById(value.itemId) == 0 then
				logger.error("[loadLuaMapSign] - Wrong item id {} found", value.itemId)
				logger.warn("Sign id: {}, position {}, item id: wrong", index, tile:getPosition():toString())
				goto continue
			end
			if tile:getItemCountById(value.itemId) == 1 then
				item = tile:getItemById(value.itemId)
			end
			-- If he found the item, add the text
			if item and allowLegacyWorld(source, index, "item", "attributes.text", item, value.itemPos) then
				item:setAttribute(ITEM_ATTRIBUTE_TEXT, value.text)
			end
		end
		::continue::
	end
end

function loadLuaMapBookDocument(tablename)
	local source = legacyWorldSource(tablename)
	-- Index 1: total valid, index 2: total loaded
	local totals = { 0, 0 }
	for index, value in ipairs(tablename) do
		local tile = Tile(value.position)
		-- Check position (some items dont have a know position yet defined, lets ignore them)
		if value.position then
			totals[1] = totals[1] + 1
			-- Check if is a valid tile
			if tile then
				-- Try find the container on the map if containerId is set
				local container = (value.containerId and tile:getItemById(value.containerId) or nil)
				-- Check if cotainerId is not set or if containerId is set also if the container exists
				if not value.containerId or value.containerId and container then
					local item
					-- Check if the item need to be in a container
					if container then
						if not allowLegacyWorld(source, index, "item", "creation", nil, value.position, value.itemId) then
							goto continue
						end
						-- Create the item inside the container
						item = container:addItem(value.itemId, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
					else
						-- Try first find the item on the map (in some cases the item is already on the map)
						item = tile:getItemById(value.itemId)
						-- Create the item at map position if dont was found
						if not item then
							if not allowLegacyWorld(source, index, "item", "creation", nil, value.position, value.itemId) then
								goto continue
							end
							item = Game.createItem(value.itemId, 1, value.position)
						end
					end
					-- If the item exists, add the text
					if item then
						if allowLegacyWorld(source, index, "item", "attributes.text", item, value.position) then
							item:setAttribute(ITEM_ATTRIBUTE_TEXT, value.text)
						end
						totals[2] = totals[2] + 1
					else
						logger.warn("[loadLuaMapBookDocument] - Item not found! Index: {}, itemId: {}", index, value.itemId)
						goto continue
					end
				else
					logger.warn("[loadLuaMapBookDocument] - Container not found! Index: {}, containerId: {}", index, value.containerId)
					goto continue
				end
			else
				logger.warn("[loadLuaMapBookDocument] - Tile not found! Index: {}, position: x: {} y: {} z: {}", index, value.position.x, value.position.y, value.position.z)
				goto continue
			end
		end
		::continue::
	end
	if totals[1] == totals[2] then
		logger.debug("Loaded {} books and documents in the map", totals[2])
	else
		logger.debug("Loaded {} of {} books and documents in the map", totals[2], totals[1])
	end
end

function updateKeysStorage(tablename)
	-- It updates old storage keys from quests for all players
	local newUpdate = tablename[0].latest
	local oldUpdate = getGlobalStorage(GlobalStorage.KeysUpdate)
	if newUpdate <= oldUpdate then
		return true
	end

	logger.info("Updating quest keys storages...")
	if oldUpdate < 1 then
		oldUpdate = 1
	end
	for u = oldUpdate, newUpdate do
		for i = 1, #tablename[u] do
			db.query("UPDATE `player_storage` SET `key` = '" .. tablename[u][i].new .. "' WHERE `key` = '" .. tablename[u][i].old .. "';")
		end
	end
	setGlobalStorage(GlobalStorage.KeysUpdate, newUpdate)
	logger.info("Storage Keys Updated")
end
