-- Configuration adapters preserve the existing gameplay rules. Native dispatch,
-- item ownership and persistence are exercised by separate C++ contracts.
DATA_DIRECTORY = "data-otservbr-global"
MESSAGE_EVENT_ADVANCE, ITEM_ATTRIBUTE_TEXT, CONST_SLOT_BACKPACK = 1, 2, 3
local registered = {}
WorldBehavior = function(id, version)
	assert(version == 1)
	local behavior = { register = function() end }
	registered[id] = behavior
	return behavior
end
local function copy(value)
	if type(value) ~= "table" then
		return value
	end
	local result = {}
	for key, child in pairs(value) do
		result[key] = copy(child)
	end
	return result
end
local function context(parameters, relations)
	return {
		parameter = function(_, name)
			return copy(parameters[name])
		end,
		object = function()
			return {
				getInitialItemId = function()
					return 2472
				end,
			}
		end,
		relation = function(_, name)
			return {
				getPosition = function()
					return relations[name]
				end,
			}
		end,
	}
end

local moves, effects = {}, {}
local player = {
	teleportTo = function(_, position)
		moves[#moves + 1] = position
	end,
	getPosition = function()
		return {
			sendMagicEffect = function(_, effect)
				effects[#effects + 1] = effect
			end,
		}
	end,
}
player.getPlayer = function()
	return player
end
local creature = {
	getPlayer = function()
		return nil
	end,
}
local destination = { x = 100, y = 110, z = 7 }
dofile(DATA_DIRECTORY .. "/scripts/world_behaviors/player_teleport.lua")
local teleport = registered["world.player_teleport"]
local teleportContext = context({ effect = 11 }, { destination = destination })
assert(teleport.onStepIn(teleportContext, creature) and #moves == 0)
assert(teleport.onStepIn(teleportContext, player) and moves[1] == destination and effects[1] == 11)
assert(teleport.onUse(teleportContext, player) and #moves == 2)
assert(not teleport.onUse(context({ effect = 11 }, {}), player) and #moves == 2)

local exists, removed, created = true, 0, 0
Tile = function(position)
	assert(position == destination)
	return {
		getItemById = function(_, id)
			assert(id == 1221)
			return exists and {
				remove = function()
					exists = false
					removed = removed + 1
				end,
			} or nil
		end,
	}
end
Game = {
	createItem = function(id, count, position)
		assert(id == 1221 and count == 1 and position == destination)
		exists, created = true, created + 1
	end,
}
dofile(DATA_DIRECTORY .. "/scripts/world_behaviors/tile_mechanism.lua")
local mechanism = registered["world.tile_mechanism"]
local mechanismContext = context({ targetItem = 1221 }, { target = destination })
assert(mechanism.onStepIn(mechanismContext, creature) and removed == 0)
assert(mechanism.onStepIn(mechanismContext, player) and removed == 1)
assert(mechanism.onStepIn(mechanismContext, player) and removed == 1)
assert(mechanism.onStepOut(mechanismContext, player) and created == 1)
assert(mechanism.onStepOut(mechanismContext, player) and created == 1)

local awarded, text, achievements, messages, storages, kv = {}, {}, {}, {}, {}, {}
local hasRoom = true
checkWeightAndBackpackRoom = function()
	return hasRoom
end
getItemWeight = function()
	return 1
end
getItemName = function(id)
	return "item" .. tostring(id)
end
getItemDescriptions = function()
	return { article = "a", name = "gem", plural = "gems" }
end
ItemType = function(id)
	return {
		isKey = function()
			return id == 2088
		end,
		getId = function()
			return id
		end,
		isStackable = function()
			return true
		end,
		getCharges = function()
			return 0
		end,
	}
end
logger = {
	warn = function()
		error("Unexpected missing reward storage")
	end,
}
local function newItem(id, count)
	if not id then
		return nil
	end -- The legacy handler also calls addItem(nil).
	awarded[#awarded + 1] = { id, count }
	return {
		setAttribute = function(_, attribute, value)
			assert(attribute == ITEM_ATTRIBUTE_TEXT)
			text[#text + 1] = value
		end,
		setActionId = function(_, value)
			text[#text + 1] = value
		end,
		addItem = function(_, child, quantity)
			return newItem(child, quantity)
		end,
	}
end
player.addItem = function(_, id, count)
	return newItem(id, count)
end
player.addAchievement = function(_, name)
	achievements[#achievements + 1] = name
end
player.sendTextMessage = function(_, kind, message)
	assert(kind == MESSAGE_EVENT_ADVANCE)
	messages[#messages + 1] = message
end
player.getStorageValue = function(_, key)
	assert(key)
	return storages[key] or -1
end
player.setStorageValue = function(_, key, value)
	storages[key] = value
end
player.getSlotItem = function()
	return {
		getEmptySlots = function()
			return 1
		end,
	}
end
player.getFreeCapacity = function()
	return 10000
end
player.questKV = function(_, name)
	assert(name == "test")
	return {
		get = function(_, key)
			return kv[key]
		end,
		set = function(_, key, value)
			kv[key] = value
		end,
	}
end
os.time = function()
	return 1000
end
dofile(DATA_DIRECTORY .. "/scripts/world_behaviors/quest_reward.lua")
local reward = registered["quest.reward"]
local parameters = { storage = 60001, timerStorage = 60002, time = 2, reward = { { itemId = 3031, count = 3 } }, rewardText = "An old note", achievement = "Annihilator" }
assert(reward.onUse(context(parameters), player, {}) and #awarded == 1)
assert(awarded[1][1] == 3031 and awarded[1][2] == 3 and text[1] == "An old note" and achievements[1] == "Annihilator")
assert(storages[60001] == 1 and storages[60002] == 8200 and messages[1] == "You have found 3 gems.")
assert(reward.onUse(context(parameters), player, {}) and #awarded == 1)
assert(messages[#messages] == "The item2472 is empty.")
storages, hasRoom = {}, false
assert(reward.onUse(context(parameters), player, {}) and #awarded == 1 and storages[60001] == nil)
hasRoom = true
parameters.randomReward = { { itemId = 3035, count = 2 } }
parameters.useKV, parameters.questName = true, "test"
assert(reward.onUse(context(parameters), player, {}) and awarded[2][1] == 3035)
assert(parameters.reward[1].itemId == 3031, "Random selection must not mutate declarative configuration")
assert(kv.completed == true and kv["params.questName"] == 8200, "Preserve the existing timer key until a separate gameplay fix")
parameters = { storage = 60010, container = 1987, keyAction = 4500, reward = { { itemId = 2088, count = 1 } } }
assert(reward.onUse(context(parameters), player, {}) and awarded[3][1] == 1987 and awarded[4][1] == 2088)
assert(text[#text] == 4500 and storages[60010] == 1)
print("World migration behavior characterization passed")
