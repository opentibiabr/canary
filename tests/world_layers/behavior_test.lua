-- Gameplay characterization; native dispatcher/context tests are separate.
local behavior
WorldBehavior = function(id, version)
	assert(id == "quest.gated_door" and version == 1)
	behavior = { register = function() end }
	return behavior
end
MESSAGE_EVENT_ADVANCE = 1
dofile("data-otservbr-global/scripts/world_behaviors/quest_gated_door.lua")

local level, storage, doorId, transformations, denied = 20, 1, 1662, 0, 0
local available, canTransform = true, true
local player = {
	getLevel = function()
		return level
	end,
	getStorageValue = function(_, key)
		assert(key == 60001)
		return storage
	end,
	sendTextMessage = function(_, kind, message)
		assert(kind == MESSAGE_EVENT_ADVANCE and message == "Denied")
		denied = denied + 1
	end,
}
local door = {
	transform = function(_, itemId)
		transformations = transformations + 1
		if canTransform then
			doorId = itemId
		end
		return true
	end,
	getId = function()
		return doorId
	end,
}
local parameters = { requiredLevel = 20, storageKey = 60001, requiredValue = 1, openDoorItemId = 1663, deniedMessage = "Denied" }
local context = {
	parameter = function(_, key)
		return parameters[key]
	end,
	relation = function(_, name)
		assert(name == "door")
		return {
			getObject = function()
				return available and {
					getItem = function()
						return door
					end,
				} or nil
			end,
		}
	end,
}
level = 19
assert(behavior.onUse(context, player) == false and transformations == 0)
level, storage = 20, 0
assert(behavior.onUse(context, player) == false and transformations == 0 and denied == 2)
storage, available = 1, false
assert(behavior.onUse(context, player) == false and transformations == 0)
available, canTransform = true, false
assert(behavior.onUse(context, player) == false and doorId == 1662)
canTransform = true
assert(behavior.onUse(context, player) == true and doorId == 1663)
print("World quest-gated door allow, deny, missing target and failed transformation passed")
