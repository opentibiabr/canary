-- Isolated flow test. Run with Lua or pass this file to test_grave_danger_flow.py.
local constants = 0
setmetatable(_G, {
	__index = function(t, key)
		if key:match("^[A-Z][A-Z_0-9]+$") then
			constants = constants + 1
			rawset(t, key, constants)
			return constants
		end
	end,
})
local positionMethods = {}
function Position(x, y, z)
	return setmetatable({ x = x, y = y, z = z }, { __index = positionMethods })
end
function positionMethods:sendMagicEffect() end
function positionMethods:getDistance(other)
	return math.max(math.abs(self.x - other.x), math.abs(self.y - other.y))
end
local world = 0
local rosters = { [0] = {}, [1] = {} }
local mType = {}
function mType:register(definition)
	self.definition = definition
end
Game = {
	createMonsterType = function()
		return mType
	end,
	getSpectators = function()
		return rosters[world]
	end,
	getTimeInWords = function(n)
		return tostring(n)
	end,
}
function Condition(kind)
	return {
		setParameter = function(self, key, value)
			self[key] = value
		end,
		setOutfit = function(self, outfit)
			self.outfit = outfit
		end,
	}
end
function doTargetCombatHealth(boss, player, kind, low, high)
	assert(boss:getWorldId() == player.world)
	assert(low == -2000 and high == -2000)
	player.hits = player.hits + 1
end
local function player(id, x)
	return {
		world = world,
		hits = 0,
		pos = Position(x, 31473, 13),
		getGuid = function()
			return id
		end,
		getPosition = function(self)
			return self.pos
		end,
		addCondition = function(self, c)
			self.condition = c
		end,
		removeCondition = function(self, kind, conditionId, subId)
			assert(subId == 1758)
			self.condition = nil
		end,
	}
end
local function boss(id)
	local origin = world
	return {
		getId = function()
			return id
		end,
		getWorldId = function()
			return origin
		end,
	}
end
dofile("data-otservbr-global/monster/quests/grave_danger/bosses/duke_krule.lua")
local rolls = { 1, 2, 1, 2 }
local roll = 0
math.random = function()
	roll = roll + 1
	return rolls[roll] or 1
end
local a, b, c = player(1, 33455), player(2, 33456), player(3, 33460)
rosters[0] = { a, b, c }
local first = boss(10)
mType.onSpawn(first)
assert(mType.onThink(first, 1000) == false) -- Keep native attacks/summons running.
assert(a.hits == 0 and not a.condition)
mType.onThink(first, 3000)
assert(a.hits == 1 and b.hits == 1 and c.hits == 0)
assert(a.condition.outfit.lookType == 49 and b.condition.outfit.lookType == 286)
assert(a.condition[CONDITION_PARAM_TICKS] == 8000)
local oldRoll = roll
mType.onThink(first, 500)
assert(a.hits == 1 and roll == oldRoll)
b.pos.x = 33458
mType.onThink(first, 500)
assert(a.hits == 1 and b.hits == 1)
b.pos.x = 33456 -- Approach after the transformation, not only at its first instant.
mType.onThink(first, 1000)
assert(a.hits == 2 and b.hits == 2 and roll == oldRoll)
world = 1
local d = player(4, 33455)
rosters[1] = { d }
local second = boss(10) -- Same ID in another world must remain independent.
mType.onSpawn(second)
mType.onThink(second, 4000)
assert(d.condition and d.hits == 0)
world = 0
mType.onThink(first, 6000)
assert(a.condition == nil and b.condition == nil)
local hitsBeforeRest = a.hits
mType.onThink(first, 11000)
assert(not a.condition and a.hits == hitsBeforeRest)
mType.onThink(first, 1000)
assert(a.condition and roll > oldRoll + 1)
-- A delayed callback cannot produce multiple catch-up hits.
local previousHits = a.hits
mType.onThink(first, 4000)
assert(a.hits <= previousHits + 1)
mType.onDisappear(first, first)
assert(a.condition == nil and b.condition == nil and c.condition == nil)
assert(d.condition ~= nil)
world = 1
mType.onDisappear(second, second)
assert(d.condition == nil)

Storage = { Quest = { U12_20 = { GraveDanger = { Bosses = {} } } } }
for _, name in ipairs({ "LordAzaram", "DukeKrule", "BaelocNictros", "EarlOsam", "CountVlarkorth", "KingZelos" }) do
	Storage.Quest.U12_20.GraveDanger.Bosses[name] = { Timer = 1 }
end
local capturedConfig
function BossLever(config)
	capturedConfig = config
	return { position = function() end, register = function() end }
end
dofile("data-otservbr-global/scripts/quests/grave_danger_quest/actions_duke_krule.lua")
assert(capturedConfig.timeToFightAgain == 72000)
assert(#capturedConfig.playerPositions == 5)
for _, slot in ipairs(capturedConfig.playerPositions) do
	assert(slot.teleport.x == 33456 and slot.teleport.y == 31480 and slot.teleport.z == 13)
end
local move = { aid = function() end, register = function() end }
function MoveEvent()
	return move
end
dofile("data-otservbr-global/scripts/quests/grave_danger_quest/movements_enter_tps.lua")
local now = os.time()
local entrant = {
	isPlayer = function()
		return true
	end,
	getStorageValue = function(self)
		return self.legacy or -1
	end,
	getBossCooldown = function(self)
		return self.cooldown or 0
	end,
	say = function()
		error("The cooldown message must not be spoken in the game world")
	end,
	teleportTo = function(self, pos)
		self.destination = pos
	end,
	sendTextMessage = function(self, _, text)
		self.message = text
	end,
}
local back = Position(1, 2, 3)
entrant.cooldown = now + 72000
move.onStepIn(entrant, { actionid = 14563 }, nil, back)
assert(entrant.destination == back and entrant.message:find("20:00:00", 1, true))
entrant.cooldown = 0
entrant.legacy = now + 72000
assert(capturedConfig.onUseExtra(entrant) == false)
move.onStepIn(entrant, { actionid = 14563 }, nil, back)
assert(entrant.destination == back)
entrant.legacy = now - 1
assert(capturedConfig.onUseExtra(entrant) == true)
move.onStepIn(entrant, { actionid = 14563 }, nil, back)
assert(entrant.destination.x == 33456 and entrant.destination.y == 31499)
print("Duke Krule: elemental phases, damage, cleanup, world isolation, entry and cooldown OK")

world = 0
rosters[0] = {}
local legacyBoss = boss(99)
legacyBoss.getWorldId = nil
mType.onSpawn(legacyBoss)
assert(mType.onThink(legacyBoss, 4000) == false)
