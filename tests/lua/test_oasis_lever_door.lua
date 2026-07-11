-- Regression test for The Ancient Tombs Oasis lever and door action.

local registeredAction
local scheduledCallback
local scheduledArgs
local lever = { itemid = 2772, transforms = {} }
local door = { itemid = 1662, transforms = {} }
local carrot = { removed = false }

function lever:transform(itemId)
	self.itemid = itemId
	table.insert(self.transforms, itemId)
end

function door:transform(itemId)
	self.itemid = itemId
	table.insert(self.transforms, itemId)
end

function carrot:remove()
	self.removed = true
end

local positions = {}
local function positionKey(position)
	return string.format("%d:%d:%d", position.x, position.y, position.z)
end

function Position(x, y, z)
	local position = { x = x, y = y, z = z }
	function position:sendMagicEffect(_) end
	positions[positionKey(position)] = position
	return position
end

local doorPosition = Position(33122, 32765, 14)
local leverPosition = Position(33118, 32761, 14)
local hatPosition = Position(33117, 32761, 14)

function Tile(position)
	return {
		getItemById = function(_, itemId)
			local key = positionKey(position)
			if key == positionKey(leverPosition) and itemId == lever.itemid then
				return lever
			end
			if key == positionKey(doorPosition) and itemId == door.itemid then
				return door
			end
			if key == positionKey(hatPosition) and itemId == 3595 and not carrot.removed then
				return carrot
			end
			return nil
		end,
	}
end

Game = {
	createItem = function(itemId, count, position)
		assert(itemId == 3595 and count == 1 and positionKey(position) == positionKey(hatPosition))
		carrot.removed = false
		return carrot
	end,
}

function Action()
	local action = { actionIds = {} }
	function action:aid(...)
		self.actionIds = { ... }
	end
	function action:register()
		registeredAction = self
	end
	return action
end

function addEvent(callback, _, ...)
	scheduledCallback = callback
	scheduledArgs = { ... }
end

function doAreaCombatHealth(...) end

MESSAGE_EVENT_ADVANCE = 1
CONST_ME_MAGIC_GREEN = 2
CONST_ME_POFF = 3
COMBAT_PHYSICALDAMAGE = 4

local originalRandom = math.random
math.random = function(_)
	return 1
end

dofile("data-otservbr-global/scripts/quests/the_ancient_tombs/actions_oasis_lever_door.lua")

assert(registeredAction, "Oasis action was not registered")
assert(#registeredAction.actionIds == 2, "Oasis action must register lever and door action IDs")
assert(registeredAction.actionIds[1] == 12107, "Lever action ID changed unexpectedly")
assert(registeredAction.actionIds[2] == 12108, "Door action ID is not registered")

local player = {
	sendTextMessage = function(...) end,
	getPosition = function()
		return leverPosition
	end,
}

assert(registeredAction.onUse(player, lever, leverPosition, nil, leverPosition, false))
assert(lever.itemid == 2773, "Lever did not switch to its used state")
assert(door.itemid == 1663, "Door did not open")
assert(scheduledCallback, "Reset callback was not scheduled")

scheduledCallback(unpack(scheduledArgs))
assert(lever.itemid == 2772, "Lever did not reset")
assert(door.itemid == 1662, "Door did not close after the timeout")
assert(carrot.removed, "Carrot was not removed during reset")

math.random = originalRandom
print("Oasis lever/door regression test passed")
