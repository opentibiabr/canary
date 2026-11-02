-- Run from the repository root: lua tests/lua/test_soul_war_hatred_targets.lua
-- Load both production scripts; control engine registration, time, and world objects.

local function noop() end
local registrationMethods = {
	register = noop,
	id = noop,
	position = noop,
	groupType = noop,
	separator = noop,
	interval = noop,
	setOutfit = noop,
	setTicks = noop,
}
local registeredEvents = {}
local function registration(name)
	local object = setmetatable({}, { __index = registrationMethods })
	if name then
		registeredEvents[name] = object
	end
	return object
end

CreatureEvent = registration
Action = registration
MoveEvent = registration
TalkAction = registration
GlobalEvent = registration
EventCallback = registration
Condition = registration
logger = { trace = noop, debug = noop }
Player = {}
Monster = {}
MonsterType = {}

Position = setmetatable({}, {
	__call = function(_, x, y, z)
		return { x = x, y = y, z = z }
	end,
})

Zone = setmetatable({}, {
	__call = function()
		return { addArea = noop, subtractArea = noop, setRemoveDestination = noop }
	end,
})

local kv = {}
function kv:scoped()
	return self
end
KV = {
	scoped = function()
		return kv
	end,
}

COMBAT_PHYSICALDAMAGE = 1
COMBAT_FIREDAMAGE = 2
COMBAT_EARTHDAMAGE = 3
COMBAT_ENERGYDAMAGE = 4
COMBAT_ICEDAMAGE = 5
COMBAT_HOLYDAMAGE = 6
COMBAT_DEATHDAMAGE = 7

local creatures = {}
Creature = setmetatable({}, {
	__call = function(_, name)
		return creatures[name]
	end,
})

local now = 100
os.time = function()
	return now
end
local player = { counter = 1, resets = 0, damage = 0 }
function player:getGoshnarSymbolTormentCounter()
	return self.counter
end
function player:increaseGoshnarSymbolTormentCounter()
	self.counter = self.counter + 1
end
function player:resetGoshnarSymbolTormentCounter()
	self.counter = 0
	self.resets = self.resets + 1
end
function player:getName()
	return "Player"
end
function player:addHealth(amount)
	self.damage = self.damage + amount
end
function player:getPosition()
	return { sendMagicEffect = noop }
end
function player:sendTextMessage() end
Game = {
	getSpectators = function()
		return { player }
	end,
}

dofile("data-otservbr-global/lib/quests/soul_war.lua")
dofile("data-otservbr-global/scripts/quests/soul_war/soul_war_mechanics.lua")

local failures = {}
local function test(name, callback)
	local ok, err = pcall(callback)
	if not ok then
		failures[#failures + 1] = name .. ": " .. err
	end
end

test("Hatred uses its explicitly supplied boss", function()
	creatures["Goshnar's Hatred"] = {}
	Monster.onThinkGoshnarTormentCounter({}, 1000, 30, 10000, Position(1, 2, 3), "Goshnar's Hatred")
	assert(player.counter == 2 and player.resets == 0, "Hatred must increment without Megalomania present")
	assert(player.damage == -35, "the torment counter must apply its damage")
end)

test("missing Hatred resets the counter even with Megalomania present", function()
	now = now + 10
	creatures["Goshnar's Hatred"] = nil
	creatures["Goshnar's Megalomania"] = {}
	player.counter, player.resets, player.damage = 1, 0, 0
	Monster.onThinkGoshnarTormentCounter({}, 1000, 30, 10000, Position(1, 2, 3), "Goshnar's Hatred")
	assert(player.counter == 0 and player.resets == 1, "a different boss must not satisfy the named lookup")
	assert(player.damage == 0)
end)

test("omitted boss name retains Megalomania default and interval gating", function()
	now = now + 10
	player.counter, player.resets, player.damage = 1, 0, 0
	Monster.onThinkGoshnarTormentCounter({}, 1000, 36, 10000, Position(1, 2, 3))
	assert(player.counter == 2 and player.resets == 0 and player.damage == -35)
	Monster.onThinkGoshnarTormentCounter({}, 1000, 36, 10000, Position(1, 2, 3))
	assert(player.counter == 2 and player.damage == -35, "an early tick must remain a no-op")
end)

local function actor(name, isPlayer, multiplier)
	return {
		getName = function()
			return name
		end,
		isPlayer = function()
			return isPlayer
		end,
		isMonster = function()
			return not isPlayer
		end,
		getHatredDamageMultiplier = function()
			return multiplier
		end,
		addDefense = function(self, amount)
			self.defense = (self.defense or 0) + amount
		end,
	}
end

local buff = assert(registeredEvents.GoshnarsHatredBuff).onHealthChange
test("both boss attackers apply the multiplier to the player", function()
	for _, name in ipairs({ "Goshnar's Hatred", "Goshnar's Megalomania" }) do
		local primary, primaryType, secondary, secondaryType = buff(actor("Player", true), actor(name, false, 20), -100, 1, -20, 2)
		assert(primary == -120, name .. " must multiply primary damage")
		assert(primaryType == 1 and secondary == -20 and secondaryType == 2)
	end
end)

test("unrelated attackers and zero multipliers retain damage", function()
	for _, attacker in ipairs({ actor("Other Monster", false, 20), actor("Goshnar's Megalomania", false, 0) }) do
		local primary, primaryType, secondary, secondaryType = buff(actor("Player", true), attacker, -100, 1, -20, 2)
		assert(primary == -100 and primaryType == 1 and secondary == -20 and secondaryType == 2)
	end
	assert(buff(actor("Player", true), nil, -100, 1, -20, 2) == -100)
end)

test("players attacking either boss retain the defense branch", function()
	for _, name in ipairs({ "Goshnar's Hatred", "Goshnar's Megalomania" }) do
		local boss = actor(name, false, 20)
		assert(buff(boss, actor("Player", true), -100, 1, -20, 2) == -100)
		assert(boss.defense == 20)
	end
end)

assert(#failures == 0, table.concat(failures, "\n"))
print("Soul War Hatred target regression tests passed")
