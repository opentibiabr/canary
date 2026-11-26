-- Run: lua tests/lua/test_primal_pod_position.lua [source-root]
-- Runs the real death callback and pod helper with controlled world services.
local sourceRoot = arg[1] or "."
local passed, failed = 0, 0
local state
local deathEvent

local function test(name, callback)
	local ok, err = pcall(callback)
	if ok then
		passed = passed + 1
	else
		failed = failed + 1
		print("FAIL: " .. name .. ": " .. err)
	end
end

local function equal(actual, expected)
	assert(actual == expected, "expected " .. tostring(expected) .. ", got " .. tostring(actual))
end

Position = function(x, y, z)
	return { x = x or 0, y = y or 0, z = z or 0 }
end
ITEM_PRIMAL_POD = 42000
configKeys = {
	TOGGLE_HAZARDSYSTEM = "enabled",
	HAZARD_PODS_DROP_MULTIPLIER = "podChance",
	HAZARD_PODS_TIME_TO_SPAWN = "spawnDelay",
}
configManager = {
	getBoolean = function(key)
		return state[key]
	end,
	getNumber = function(key)
		return state[key]
	end,
}
local player = {
	getClosestFreePosition = function(_, position, radius, reachable)
		equal(position, state.deathPosition)
		equal(radius, 4)
		equal(reachable, true)
		return state.freePosition
	end,
}
Hazard = {
	new = function()
		return {
			register = function() end,
			isInZone = function()
				return state.inside
			end,
			getHazardPlayerAndPoints = function()
				return player, state.points
			end,
		}
	end,
}
Zone = {
	getByName = function()
		return { subtractArea = function() end }
	end,
}
local function event()
	return { id = function() end, register = function() end }
end
MoveEvent = event
ZoneEvent = event
CreatureEvent = function(name)
	equal(name, "PrimalHazardDeath")
	deathEvent = event()
	return deathEvent
end

Game = {
	createItem = function(id, count, position)
		equal(id, ITEM_PRIMAL_POD)
		equal(count, 1)
		table.insert(state.attempts, position)
		if state.creationFails or position.x == 0 then
			return nil
		end
		local pod = { position = position, attributes = {} }
		function pod:setCustomAttribute(key, value)
			self.attributes[key] = value
		end
		function pod:getPosition()
			return self.position
		end
		table.insert(state.pods, pod)
		return pod
	end,
}
addEvent = function(callback, delay, position)
	table.insert(state.events, { callback = callback, delay = delay, position = position })
end
math.random = function()
	return 1
end

dofile(sourceRoot .. "/data-otservbr-global/scripts/systems/hazard_primal.lua")

local function reset()
	state = {
		enabled = true,
		podChance = 1,
		spawnDelay = 5000,
		inside = true,
		points = 1,
		hazard = true,
		rewardBoss = false,
		deathPosition = Position(33520, 32760, 13),
		freePosition = Position(33521, 32760, 13),
		attempts = {},
		pods = {},
		events = {},
	}
end

local function kill()
	local monster = {
		getPosition = function()
			return state.deathPosition
		end,
		getMonster = function(self)
			return self
		end,
		hazard = function()
			return state.hazard
		end,
		getType = function()
			return {
				isRewardBoss = function()
					return state.rewardBoss
				end,
			}
		end,
		getDamageMap = function()
			return { [1] = { total = 100 } }
		end,
	}
	equal(deathEvent.onDeath(monster), true)
end

local function checkPod(position)
	equal(#state.attempts, 1)
	equal(state.attempts[1], position)
	equal(#state.pods, 1)
	assert(state.pods[1].attributes.HazardSystem_PodTimer > 0)
	equal(#state.events, 1)
	equal(state.events[1].position, position)
	equal(state.events[1].delay, 5000)
end

test("free reachable tile is retained", function()
	reset()
	kill()
	checkPod(state.freePosition)
end)

test("no free tile creates and schedules pod on the defeated monster tile", function()
	reset()
	state.freePosition = Position()
	kill()
	checkPod(state.deathPosition)
end)

test("failed fallback creation does not schedule an absent pod", function()
	reset()
	state.freePosition = Position()
	state.creationFails = true
	kill()
	equal(#state.attempts, 1)
	equal(state.attempts[1], state.deathPosition)
	equal(#state.pods, 0)
	equal(#state.events, 0)
end)

for _, guard in ipairs({ "enabled", "inside", "hazard" }) do
	test("pod remains blocked when " .. guard .. " is false", function()
		reset()
		state[guard] = false
		kill()
		equal(#state.attempts, 0)
		equal(#state.events, 0)
	end)
end

test("reward bosses are still excluded", function()
	reset()
	state.rewardBoss = true
	kill()
	equal(#state.attempts, 0)
end)

test("players without hazard points remain excluded", function()
	reset()
	state.points = 0
	kill()
	equal(#state.attempts, 0)
end)

print(string.format("%d passed, %d failed", passed, failed))
os.exit(failed == 0 and 0 or 1)
