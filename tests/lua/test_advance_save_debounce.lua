-- Regression tests for the delayed player save after a level advancement.
-- Run from the repository root with: luajit tests/lua/test_advance_save_debounce.lua

SKILL_LEVEL = 0

local registeredEvent
local scheduleCount = 0
local nextEventId = false
local scheduledEvent = {}
local unpackArguments = table.unpack or unpack

function CreatureEvent(name)
	assert(name == "UpdatePlayerOnAdvancedLevel")

	registeredEvent = {
		register = function(self)
			self.registered = true
		end,
	}
	return registeredEvent
end

function addEvent(callback, delay, ...)
	scheduleCount = scheduleCount + 1
	scheduledEvent.callback = callback
	scheduledEvent.delay = delay
	scheduledEvent.arguments = { ... }
	return nextEventId
end

local player = {
	id = 101,
	guid = 202,
	saves = 0,
}

function player:getId()
	return self.id
end

function player:getGuid()
	return self.guid
end

function player:getMaxHealth()
	return 100
end

function player:addHealth() end

function player:getMaxMana()
	return 50
end

function player:addMana() end

function player:getFinalLowLevelBonus() end

function player:save()
	self.saves = self.saves + 1
end

function Player(id)
	if id == player.id then
		return player
	end
end

dofile("data/scripts/creaturescripts/player/update_player_on_advanced_level.lua")

assert(registeredEvent.registered)

registeredEvent.onAdvance(player, SKILL_LEVEL, 20, 21)
assert(scheduleCount == 1)
assert(player.saves == 1)

nextEventId = 1
registeredEvent.onAdvance(player, SKILL_LEVEL, 21, 22)
assert(scheduleCount == 2)
assert(player.saves == 1)

registeredEvent.onAdvance(player, SKILL_LEVEL, 22, 23)
assert(scheduleCount == 2)

scheduledEvent.callback(unpackArguments(scheduledEvent.arguments))
assert(player.saves == 2)

print("\n1 passed, 0 failed")
