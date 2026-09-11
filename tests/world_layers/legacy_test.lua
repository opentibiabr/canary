-- Run from the repository root: lua tests/world_layers/legacy_test.lua
local enabled = false
Game = {
	isWorldObjectDeclared = function(id)
		return enabled and (id == "black_knight.entry" or id == "black_knight.exit")
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
print("World layer legacy activation and fallback passed")
