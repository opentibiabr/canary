-- Run from the repository root: lua tests/world_layers/legacy_test.lua
local enabled = false
DATA_DIRECTORY = "data-otservbr-global"
Game = {
	isWorldObjectDeclared = function(id)
		return enabled and (id == "black_knight.entry" or id == "black_knight.exit")
	end,
	canApplyLegacyWorld = function(file, name, key, occurrence, responsibility)
		assert(file == DATA_DIRECTORY .. "/startup/tables/teleport.lua")
		assert(name == "TeleportUnique" and occurrence == "item" and responsibility == "attributes.uid")
		return not enabled or (key ~= "38012" and key ~= "38013")
	end,
}
ITEM_ATTRIBUTE_UNIQUEID = 1
logger = {
	warn = function() end,
	error = function()
		error("unexpected loader error")
	end,
}

local assigned = {}
Tile = function()
	return {
		getItemCountById = function()
			return 1
		end,
		getItemById = function()
			return {
				getId = function()
					return 1949
				end,
				setAttribute = function(_, _, id)
					assigned[id] = true
				end,
			}
		end,
	}
end

dofile("data-otservbr-global/startup/others/functions.lua")
TeleportUnique = {
	[38001] = { itemId = 1949, itemPos = {} },
	[38012] = { itemId = 1949, itemPos = {}, worldObject = "black_knight.entry" },
	[38013] = { itemId = 1949, itemPos = {}, worldObject = "black_knight.exit" },
}

local registered = {}
MoveEvent = function()
	return {
		uid = function(_, id)
			registered[id] = true
		end,
		register = function() end,
	}
end

for _, active in ipairs({ false, true }) do
	enabled = active
	assigned, registered = {}, {}
	loadLuaMapUnique(TeleportUnique)
	dofile("data-otservbr-global/scripts/movements/others/teleport.lua")
	assert(assigned[38001] and registered[38001], "unmigrated portals must retain legacy behavior")
	for _, id in ipairs({ 38012, 38013 }) do
		assert((assigned[id] == true) == not active, "native objects must not receive legacy UID assignment")
		assert((registered[id] == true) == not active, "native objects must not receive legacy movement callbacks")
	end
end
-- Sharing an AID does not transfer ownership of the other occurrence.
local items = {}
local claims = {}
ITEM_ATTRIBUTE_ACTIONID = 2
ItemAction = { [12107] = { itemId = 2772, itemPos = { { x = 1 }, { x = 2 } } } }
Tile = function(position)
	local item = {
		getId = function()
			return 2772
		end,
		setAttribute = function(_, attribute, value)
			items[position.x] = { attribute, value }
		end,
	}
	return {
		getItemCountById = function()
			return 1
		end,
		getItemById = function()
			return item
		end,
	}
end
Game.canApplyLegacyWorld = function(file, name, key, occurrence, responsibility)
	assert(file == DATA_DIRECTORY .. "/startup/tables/item.lua" and name == "ItemAction")
	assert(key == "12107" and responsibility == "attributes.aid")
	claims[occurrence] = true
	return occurrence ~= "1.item"
end
loadLuaMapAction(ItemAction)
assert(claims["1.item"] and claims["2.item"], "each occurrence must ask for ownership independently")
assert(not items[1] and items[2][2] == 12107, "a shared AID must not suppress unclaimed occurrences")

-- World startup must not populate compatibility tables for gameplay consumers.
local executeFile = dofile
configKeys = { WORLD_CONFIGURATION = 1 }
for _, mode in ipairs({ "legacy", "world", "mixed" }) do
	configManager = {
		getString = function()
			return mode
		end,
	}
	local loaded = {}
	dofile = function(file)
		loaded[file] = true
	end
	executeFile(DATA_DIRECTORY .. "/startup/startup.lua")
	assert(loaded[DATA_DIRECTORY .. "/startup/others/load.lua"])
	assert((loaded[DATA_DIRECTORY .. "/startup/tables/load.lua"] == true) == (mode ~= "world"))
	assert((loaded[DATA_DIRECTORY .. "/startup/tables/storage_keys_update.lua"] == true) == (mode == "world"))
end
dofile = executeFile
print("World legacy activation, fallback and occurrence routing passed")
