-- Standalone Lua contract tests for the modular Task Board implementation.
-- Run from the repository root with: lua tests/lua/test_taskboard_module.lua

local passed, failed, errors = 0, 0, {}

local function test(name, fn)
	local ok, err = pcall(fn)
	if ok then
		passed = passed + 1
	else
		failed = failed + 1
		table.insert(errors, { name = name, err = err })
	end
end

local function assert_true(value, message)
	if not value then
		error(message or "expected true", 2)
	end
end

local function assert_equal(expected, actual, message)
	if expected ~= actual then
		error(message or string.format("expected %s, got %s", tostring(expected), tostring(actual)), 2)
	end
end

local function makeScope(storage, prefix)
	local scope = {}
	function scope:get(key)
		return storage[prefix .. "/" .. tostring(key)]
	end
	function scope:set(key, value)
		storage[prefix .. "/" .. tostring(key)] = value
		return true
	end
	function scope:scoped(key)
		return makeScope(storage, prefix .. "/" .. tostring(key))
	end
	return scope
end

local function makeReader(values, widths)
	local reader = { values = values, widths = widths or {}, position = 1, calls = {}, remaining = 0 }
	for index, value in ipairs(values) do
		reader.remaining = reader.remaining + (reader.widths[index] or 1)
	end
	function reader:getUnreadBytes()
		return self.remaining
	end
	function reader:getByte()
		table.insert(self.calls, "byte")
		local value = self.values[self.position]
		self.remaining = self.remaining - 1
		self.position = self.position + 1
		return value
	end
	function reader:getU16()
		table.insert(self.calls, "u16")
		local value = self.values[self.position]
		self.remaining = self.remaining - 2
		self.position = self.position + 1
		return value
	end
	return reader
end

local sentMessages = {}
local registeredCallbacks = {}
local registeredCreatureEvents = {}
NetworkMessage = function()
	local message = { events = {} }
	local function add(operation, value)
		table.insert(message.events, { operation = operation, value = value })
	end
	function message:addByte(value)
		add("byte", value)
	end
	function message:addU16(value)
		add("u16", value)
	end
	function message:addU32(value)
		add("u32", value)
	end
	function message:addU64(value)
		add("u64", value)
	end
	function message:addString(value)
		add("string", value)
	end
	function message:sendToPlayer()
		table.insert(sentMessages, self)
	end
	return message
end

EventCallback = function(name)
	local callback = { name = name }
	function callback:register()
		registeredCallbacks[self.name] = self
	end
	return callback
end

CreatureEvent = function(name)
	local event = { name = name }
	function event:register()
		registeredCreatureEvents[self.name] = self
	end
	return event
end

logger = { debug = function() end }
MESSAGE_EVENT_ADVANCE = 18
PLAYERSEX_FEMALE = 1
CONST_SLOT_AMMO = 10

local function monster(name, raceId, stars)
	return {
		name = function()
			return name
		end,
		raceId = function()
			return raceId
		end,
		BestiaryStars = function()
			return stars
		end,
		isRewardBoss = function()
			return false
		end,
	}
end

Game = {
	getMonsterTypes = function()
		return {
			alpha = monster("Alpha", 100, 1),
			bravo = monster("Bravo", 101, 2),
			charlie = monster("Charlie", 102, 3),
			delta = monster("Delta", 103, 1),
			echo = monster("Echo", 104, 2),
			foxtrot = monster("Foxtrot", 105, 3),
			golf = monster("Golf", 106, 1),
			hotel = monster("Hotel", 107, 2),
		}
	end,
}

local storage = {}
local player = {
	client = { version = 1525 },
	taskPoints = 500,
	thirdSlotUnlocked = false,
	items = {},
	stashItems = {},
	experience = 0,
	equippedAmmo = nil,
	bestiaryBonusKills = 0,
	bestiaryUnlocked = false,
	raceIconOverlays = {},
	iconRefreshes = 0,
	loginSession = 1000,
}
function player:getName()
	return "Task Board Test"
end
function player:getId()
	return 42
end
function player:getLevel()
	return 50
end
function player:getLastLoginSaved()
	return self.loginSession
end
function player:getClient()
	return self.client
end
function player:kv()
	return makeScope(storage, "root")
end
function player:getTaskHuntingPoints()
	return self.taskPoints
end
function player:addTaskHuntingPoints(amount)
	self.taskPoints = self.taskPoints + amount
	return self.taskPoints
end
function player:removeTaskHuntingPoints(amount)
	if self.taskPoints < amount then
		return false
	end
	self.taskPoints = self.taskPoints - amount
	return true
end
function player:taskHuntingThirdSlot(enabled)
	if enabled == nil then
		return self.thirdSlotUnlocked
	end
	self.thirdSlotUnlocked = enabled
	return true
end
function player:addExperience(amount)
	self.experience = self.experience + amount
end
function player:setRaceIconOverlay(raceId, icon, enabled)
	enabled = enabled ~= false
	local overlays = self.raceIconOverlays[raceId]
	if enabled then
		overlays = overlays or {}
		self.raceIconOverlays[raceId] = overlays
		if overlays[icon] then
			return false
		end
		overlays[icon] = true
		return true
	end
	if not overlays or not overlays[icon] then
		return false
	end
	overlays[icon] = nil
	if next(overlays) == nil then
		self.raceIconOverlays[raceId] = nil
	end
	return true
end
function player:clearRaceIconOverlays(icon)
	local changed = false
	for raceId, overlays in pairs(self.raceIconOverlays) do
		if overlays[icon] then
			overlays[icon] = nil
			changed = true
		end
		if next(overlays) == nil then
			self.raceIconOverlays[raceId] = nil
		end
	end
	return changed
end
function player:refreshVisibleCreatureIcons()
	self.iconRefreshes = self.iconRefreshes + 1
end
function player:getItemCount(itemId)
	return self.items[itemId] or 0
end
function player:getStashItemCount(itemId)
	return self.stashItems[itemId] or 0
end
function player:removeItem(itemId, amount)
	if self:getItemCount(itemId) < amount then
		return false
	end
	self.items[itemId] = self.items[itemId] - amount
	return true
end
function player:addItem(itemId, amount)
	self.items[itemId] = self:getItemCount(itemId) + amount
	return true
end
function player:removeStashItem(itemId, amount)
	if self:getStashItemCount(itemId) < amount then
		return false
	end
	self.stashItems[itemId] = self:getStashItemCount(itemId) - amount
	return true
end
function player:addItemStash(itemId, amount)
	self.stashItems[itemId] = self:getStashItemCount(itemId) + amount
	return true
end
function player:getSlotItem(slot)
	if slot == CONST_SLOT_AMMO then
		return self.equippedAmmo
	end
	return nil
end
function player:addBestiaryKill(_, amount)
	self.bestiaryBonusKills = self.bestiaryBonusKills + (amount or 1)
	return true
end
function player:isMonsterBestiaryUnlocked()
	return self.bestiaryUnlocked
end

local api = {}
for _, component in ipairs({ "settings", "diagnostics", "catalog", "state", "rules", "wire", "admin", "actions", "soulpit", "lifecycle" }) do
	dofile("data/modules/scripts/taskboard/" .. component .. ".lua")(api)
end
api.getLootBonus = api.rules.getLootBonus
api.getDamageBonus = api.rules.getDamageBonus
api.getLifeLeechBonus = api.rules.getLifeLeechBonus
api.onMonsterKilled = api.rules.onMonsterKilled
rawset(_G, "Taskboard", api)
dofile("data/scripts/eventcallbacks/creature/on_combat_taskboard.lua")
dofile("data/scripts/eventcallbacks/player/on_kill_taskboard.lua")
dofile("data/scripts/eventcallbacks/player/on_login_complete_taskboard.lua")

test("numeric boundaries reject invalid non-finite values", function()
	local nan = 0 / 0
	assert_equal(0, api.clampByte(nan))
	assert_equal(0xFFFF, api.clampU16(math.huge))
	assert_equal(0, api.clampU32(-math.huge))
	assert_equal(api.difficulty.adept, api.normalizeDifficulty(nan, api.difficulty.adept))
	assert_true(api.getWeeklyResetTimestamp(nan) > os.time())
end)

test("catalog retries after an empty startup snapshot", function()
	local originalGetMonsterTypes = Game.getMonsterTypes
	local calls = 0
	Game.getMonsterTypes = function()
		calls = calls + 1
		if calls == 1 then
			return {}
		end
		return originalGetMonsterTypes()
	end

	local succeeded, failure = pcall(function()
		api.catalog.ready = false
		api.catalog.rebuild()
		assert_equal(false, api.catalog.ready)
		assert_true(api.catalog.isValidRace(100))
		assert_true(calls >= 2)
	end)

	Game.getMonsterTypes = originalGetMonsterTypes
	api.catalog.rebuild()
	assert_true(succeeded, failure)
end)

test("bounty pools match the official bestiary difficulty groups", function()
	local originalGetMonsterTypes = Game.getMonsterTypes
	Game.getMonsterTypes = function()
		local monsters = {}
		for stars = 0, 5 do
			monsters["difficulty-" .. stars] = monster("Difficulty " .. stars, 200 + stars, stars)
		end
		return monsters
	end

	local expectedRaceIds = {
		[api.difficulty.beginner] = { 202 },
		[api.difficulty.adept] = { 202, 203 },
		[api.difficulty.expert] = { 203, 204 },
		[api.difficulty.master] = { 204, 205 },
	}
	local succeeded, failure = pcall(function()
		api.catalog.rebuild()
		for difficulty = api.difficulty.beginner, api.difficulty.master do
			local pool = api.catalog.getPool(difficulty)
			local expected = expectedRaceIds[difficulty]
			assert_equal(#expected, #pool)
			for index, raceId in ipairs(expected) do
				assert_equal(raceId, pool[index].raceId)
			end
		end
	end)

	Game.getMonsterTypes = originalGetMonsterTypes
	api.catalog.rebuild()
	assert_true(succeeded, failure)
end)

test("taskboard kill callback does not depend on a corpse", function()
	local originalOnMonsterKilled = api.rules.onMonsterKilled
	local originalTaskboardOnMonsterKilled = api.onMonsterKilled
	local calls = {}
	api.rules.onMonsterKilled = function(killer, raceId)
		table.insert(calls, { killer = killer, raceId = raceId })
	end
	api.onMonsterKilled = api.rules.onMonsterKilled

	local succeeded, failure = pcall(function()
		local callback = registeredCallbacks.TaskboardPlayerOnKill
		assert_true(callback ~= nil)
		callback.playerOnKill(player, {
			getType = function()
				return Game.getMonsterTypes().alpha
			end,
		})
		assert_equal(1, #calls)
		assert_equal(player, calls[1].killer)
		assert_equal(100, calls[1].raceId)
	end)

	api.rules.onMonsterKilled = originalOnMonsterKilled
	api.onMonsterKilled = originalTaskboardOnMonsterKilled
	assert_true(succeeded, failure)
end)

test("persisted state replaces non-finite values with safe defaults", function()
	local nan = 0 / 0
	local unsafeStorage = {
		["root/task-board/meta/next-weekly-reset"] = math.huge,
		["root/task-board/general/bounty-points"] = math.huge,
		["root/task-board/bounty/difficulty"] = nan,
		["root/task-board/bounty/daily-rerolls"] = nan,
		["root/task-board/bounty/last-reroll-claim"] = -math.huge,
		["root/task-board/bounty/task-count"] = math.huge,
		["root/task-board/weekly/difficulty"] = nan,
		["root/task-board/wheel/multiplier"] = math.huge,
	}
	local unsafePlayer = {
		getLevel = function()
			return 50
		end,
		kv = function()
			return makeScope(unsafeStorage, "root")
		end,
	}

	local state = api.state.load(unsafePlayer)
	local expectedDifficulty = api.getDifficultyForLevel(50)
	assert_equal(0, state.meta.nextWeeklyReset)
	assert_equal(0, state.general.bountyPoints)
	assert_equal(expectedDifficulty, state.bounty.difficulty)
	assert_equal(0, state.bounty.dailyRerolls)
	assert_equal(0, state.bounty.lastRerollClaim)
	assert_equal(0, #state.bounty.tasks)
	assert_equal(expectedDifficulty, state.weekly.difficulty)
	assert_equal(1, state.wheel.multiplier)

	state.meta.nextWeeklyReset = nan
	state.general.bountyPoints = nan
	state.bounty.lastRerollClaim = math.huge
	state.wheel.multiplier = nan
	assert_equal(true, api.state.save(unsafePlayer, state))
	assert_equal(0, unsafeStorage["root/task-board/meta/next-weekly-reset"])
	assert_equal(0, unsafeStorage["root/task-board/general/bounty-points"])
	assert_equal(0, unsafeStorage["root/task-board/bounty/last-reroll-claim"])
	assert_equal(1, unsafeStorage["root/task-board/wheel/multiplier"])
end)

test("non-finite bounty chances fall back to disabled", function()
	local originalGetPool = api.catalog.getPool
	local originalRandom = math.random
	local originalGoldChance = api.config.bounty.goldTaskChance
	local originalSilverChance = api.config.bounty.silverTaskChance
	local originalPreferredChance = api.config.bounty.preferredRaceChance
	local originalUnwantedChance = api.config.bounty.unwantedRaceSkipChance
	local nan = 0 / 0
	api.config.bounty.goldTaskChance = nan
	api.config.bounty.silverTaskChance = math.huge
	api.config.bounty.preferredRaceChance = nan
	api.config.bounty.unwantedRaceSkipChance = math.huge
	api.catalog.getPool = function()
		return { { raceId = 100 }, { raceId = 101 }, { raceId = 102 }, { raceId = 103 } }
	end
	math.random = function(_, maximum)
		return maximum
	end
	local state = api.state.load(player)
	state.bounty.preferences = {
		{ unlocked = true, preferredRace = 100, unwantedRace = 101 },
	}

	local generated, generationError = pcall(api.rules.generateBounty, player, state)
	api.catalog.getPool = originalGetPool
	math.random = originalRandom
	api.config.bounty.goldTaskChance = originalGoldChance
	api.config.bounty.silverTaskChance = originalSilverChance
	api.config.bounty.preferredRaceChance = originalPreferredChance
	api.config.bounty.unwantedRaceSkipChance = originalUnwantedChance
	assert_true(generated, generationError)
	assert_equal(103, state.bounty.tasks[1].raceId)
	local selectedUnwanted = false
	for _, task in ipairs(state.bounty.tasks) do
		selectedUnwanted = selectedUnwanted or task.raceId == 101
		assert_equal(api.taskKind.normal, task.marker)
	end
	assert_true(selectedUnwanted)
end)

test("active tasks define viewer-specific creature icons", function()
	local originalOverlays = player.raceIconOverlays
	player.raceIconOverlays = {}
	local state = api.state.load(player)
	state.bounty.tasks = {
		{ raceId = 100, required = 10, current = 2, state = api.taskState.selected },
	}
	state.weekly.selectionPending = false
	state.weekly.kills = {
		{ raceId = 101, required = 20, current = 4, completed = false },
		{ raceId = 102, required = 20, current = 20, completed = true },
	}

	local succeeded, failure = pcall(function()
		assert_equal(true, api.rules.syncCreatureIcons(player, state))
		assert_equal(true, player.raceIconOverlays[100][api.creatureIcon.bountyTaskMonster])
		assert_equal(true, player.raceIconOverlays[101][api.creatureIcon.weeklyTaskMonster])
		assert_equal(nil, player.raceIconOverlays[102])

		state.bounty.tasks[1].state = api.taskState.completed
		state.weekly.kills[1].completed = true
		assert_equal(true, api.rules.syncCreatureIcons(player, state))
		assert_equal(nil, player.raceIconOverlays[100])
		assert_equal(nil, player.raceIconOverlays[101])
	end)
	player.raceIconOverlays = originalOverlays
	assert_true(succeeded, failure)
end)

test("task board registers creature icon initialization on login", function()
	assert_true(registeredCreatureEvents.TaskboardLogin ~= nil)
	assert_true(type(registeredCreatureEvents.TaskboardLogin.onLogin) == "function")
end)

test("completed login restores bounty and weekly client state", function()
	local callback = registeredCallbacks.TaskboardPlayerOnLoginComplete
	assert_true(callback ~= nil)
	sentMessages = {}
	callback.playerOnLoginComplete(player)
	assert_equal(8, #sentMessages)
	assert_equal(api.packet.serverTaskboard, sentMessages[1].events[1].value)
	assert_equal(api.window.bounty, sentMessages[1].events[2].value)
	assert_equal(api.packet.serverTaskboard, sentMessages[5].events[1].value)
	assert_equal(api.window.weekly, sentMessages[5].events[2].value)
end)

test("rookgaard players cannot use or benefit from task board systems", function()
	local originalEnsure = api.state.ensure
	local originalLoad = api.state.load
	local originalSave = api.state.save
	local stateReads = 0
	local stateWrites = 0
	api.state.ensure = function()
		stateReads = stateReads + 1
		error("rookgaard task state must not be initialized")
	end
	api.state.load = function()
		stateReads = stateReads + 1
		error("rookgaard task state must not be loaded")
	end
	api.state.save = function()
		stateWrites = stateWrites + 1
		error("rookgaard task state must not be saved")
	end

	local rookPlayer = setmetatable({
		client = player.client,
		equippedAmmo = {
			getId = function()
				return api.config.talisman.itemId
			end,
		},
		raceIconOverlays = {
			[100] = {
				[api.creatureIcon.bountyTaskMonster] = true,
				[api.creatureIcon.weeklyTaskMonster] = true,
			},
		},
		iconRefreshes = 0,
		getVocation = function()
			return {
				getId = function()
					return 0
				end,
			}
		end,
	}, { __index = player })
	local target = {
		getType = function()
			return Game.getMonsterTypes().alpha
		end,
	}
	local sentBefore = #sentMessages

	local succeeded, failure = pcall(function()
		assert_equal(true, api.lifecycle.onLogin(rookPlayer))
		assert_equal(nil, rookPlayer.raceIconOverlays[100])
		assert_equal(1, rookPlayer.iconRefreshes)

		rookPlayer.raceIconOverlays[100] = { [api.creatureIcon.bountyTaskMonster] = true }
		api.actions.handle(rookPlayer, makeReader({ api.action.openBounty }, { 1 }))
		assert_equal(nil, rookPlayer.raceIconOverlays[100])
		assert_equal(2, rookPlayer.iconRefreshes)
		assert_equal(sentBefore, #sentMessages)

		api.rules.onMonsterKilled(rookPlayer, 100)
		assert_equal(0, api.rules.getLootBonus(rookPlayer, target))
		assert_equal(0, api.rules.getDamageBonus(rookPlayer, target))
		assert_equal(0, api.rules.getLifeLeechBonus(rookPlayer, target))
		assert_equal(0, stateReads)
		assert_equal(0, stateWrites)
	end)

	api.state.ensure = originalEnsure
	api.state.load = originalLoad
	api.state.save = originalSave
	assert_true(succeeded, failure)
end)

test("staff players without a vocation can use and resync the task board", function()
	local staffStorage = {}
	local staffPlayer = setmetatable({
		client = player.client,
		kv = function()
			return makeScope(staffStorage, "root")
		end,
		getGroup = function()
			return {
				getAccess = function()
					return true
				end,
			}
		end,
		getVocation = function()
			return {
				getId = function()
					return 0
				end,
			}
		end,
	}, { __index = player })

	assert_equal(true, api.isTaskboardEligible(staffPlayer))

	sentMessages = {}
	api.actions.handle(staffPlayer, makeReader({ api.action.openBounty }, { 1 }))
	assert_equal(4, #sentMessages)
	assert_equal(api.packet.serverTaskboard, sentMessages[1].events[1].value)
	assert_equal(api.window.bounty, sentMessages[1].events[2].value)

	sentMessages = {}
	registeredCallbacks.TaskboardPlayerOnLoginComplete.playerOnLoginComplete(staffPlayer)
	assert_equal(8, #sentMessages)
	assert_equal(api.window.bounty, sentMessages[1].events[2].value)
	assert_equal(api.window.weekly, sentMessages[5].events[2].value)
end)

test("duplicate recvbyte registrations reuse one taskboard instance", function()
	local previousDirectory = rawget(_G, "CORE_DIRECTORY")
	local previousTaskboard = rawget(_G, "Taskboard")
	local previousOnRecvbyte = rawget(_G, "onRecvbyte")
	local ok, err = pcall(function()
		rawset(_G, "CORE_DIRECTORY", "data")
		rawset(_G, "Taskboard", nil)
		dofile("data/modules/scripts/taskboard/taskboard.lua")
		local firstInstance = rawget(_G, "Taskboard")
		firstInstance.config.enabled = false

		dofile("data/modules/scripts/taskboard/taskboard.lua")
		assert_equal(firstInstance, rawget(_G, "Taskboard"))
		assert_equal(false, rawget(_G, "Taskboard").config.enabled)
	end)
	rawset(_G, "CORE_DIRECTORY", previousDirectory)
	rawset(_G, "Taskboard", previousTaskboard)
	rawset(_G, "onRecvbyte", previousOnRecvbyte)
	if not ok then
		error(err, 0)
	end
end)

test("strict action parser consumes the documented u16 payloads", function()
	local reader = makeReader({ api.action.assignPreferred, 2, 101 }, { 1, 2, 2 })
	api.actions.handle(player, reader)
	assert_equal("byte", reader.calls[1])
	assert_equal("u16", reader.calls[2])
	assert_equal("u16", reader.calls[3])
	assert_equal(0, reader:getUnreadBytes())
end)

test("preference unlock consumes its u16 slot", function()
	local sentBefore = #sentMessages
	local reader = makeReader({ api.action.unlockPreference, 1 }, { 1, 2 })
	api.actions.handle(player, reader)
	assert_equal("byte", reader.calls[1])
	assert_equal("u16", reader.calls[2])
	assert_equal(0, reader:getUnreadBytes())
	assert_true(#sentMessages > sentBefore)
end)

test("bounty state exposes all five preference slots", function()
	local preferenceStorage = {}
	local preferencePlayer = {
		getLevel = function()
			return 50
		end,
		kv = function()
			return makeScope(preferenceStorage, "root")
		end,
	}

	local state = api.state.load(preferencePlayer)
	assert_equal(5, #state.bounty.preferences)
	assert_equal(true, state.bounty.preferences[1].unlocked)
	assert_equal(false, state.bounty.preferences[5].unlocked)
end)

test("preference clear consumes a u16 slot", function()
	local reader = makeReader({ api.action.clearPreferred, 0 }, { 1, 2 })
	api.actions.handle(player, reader)
	assert_equal("byte", reader.calls[1])
	assert_equal("u16", reader.calls[2])
	assert_equal(0, reader:getUnreadBytes())
end)

test("preference clear rejects an incomplete u16 slot", function()
	local sentBefore = #sentMessages
	local reader = makeReader({ api.action.clearUnwanted, 0 }, { 1, 1 })
	api.actions.handle(player, reader)
	assert_equal(sentBefore, #sentMessages)
end)

test("strict action parser rejects trailing bytes", function()
	local sentBefore = #sentMessages
	local reader = makeReader({ api.action.openBounty, 0xAA }, { 1, 1 })
	api.actions.handle(player, reader)
	assert_equal(sentBefore, #sentMessages)
end)

test("taskboard actions persist initialized state once", function()
	local originalSave = api.state.save
	local saveCalls = 0
	api.state.save = function(playerToSave, state)
		saveCalls = saveCalls + 1
		return originalSave(playerToSave, state)
	end

	local succeeded, failure = pcall(function()
		api.actions.handle(player, makeReader({ api.action.openBounty }, {}))
		assert_equal(1, saveCalls)
	end)
	api.state.save = originalSave
	assert_true(succeeded, failure)
end)

test("task completion events use the official client-event layouts", function()
	local sentBefore = #sentMessages
	api.wire.sendBountyTaskFinished(player, 100)
	api.wire.sendWeeklyTaskSpecificCreatureFinished(player, 101)
	assert_equal(sentBefore + 2, #sentMessages)

	local bounty = sentMessages[sentBefore + 1].events
	assert_equal("byte", bounty[1].operation)
	assert_equal(0x75, bounty[1].value)
	assert_equal("byte", bounty[2].operation)
	assert_equal(11, bounty[2].value)
	assert_equal("u16", bounty[3].operation)
	assert_equal(100, bounty[3].value)

	local weekly = sentMessages[sentBefore + 2].events
	assert_equal(0x75, weekly[1].value)
	assert_equal(12, weekly[2].value)
	assert_equal("u16", weekly[3].operation)
	assert_equal(101, weekly[3].value)
end)

test("task completion events are emitted only on completion transitions", function()
	local state = api.state.load(player)
	state.weekly.selectionPending = false
	state.weekly.anyCreature = { required = 10, current = 0, completed = false }
	state.weekly.kills = { { raceId = 101, required = 1, current = 0, completed = false } }
	state.bounty.tasks = {
		{ raceId = 100, required = 1, current = 0, state = api.taskState.selected },
	}
	local sentBefore = #sentMessages

	assert_equal(true, api.rules.updateBountyOnKill(player, state, 100))
	assert_equal(false, api.rules.updateBountyOnKill(player, state, 100))
	assert_equal(true, api.rules.updateWeeklyOnKill(player, state, 101))
	assert_equal(true, api.rules.updateWeeklyOnKill(player, state, 101))

	local completionEvents = 0
	for index = sentBefore + 1, #sentMessages do
		local events = sentMessages[index].events
		if events[1] and events[1].value == 0x75 then
			completionEvents = completionEvents + 1
		end
	end
	assert_equal(2, completionEvents)
end)

test("Soulpit selection rejects bytes after its single race id", function()
	local sentBefore = #sentMessages
	api.soulpit.handleSelection(player, makeReader({ 100, 0xAA }, { 2, 1 }))
	assert_equal(sentBefore, #sentMessages)
end)

test("Soulpit window requires a supported client, adapter, and catalog", function()
	local originalRaceIds = api.config.soulpit.raceIds
	local originalClient = player.client
	local originalAdapter = rawget(_G, "SoulPit")
	api.config.soulpit.raceIds = { 100 }
	rawset(_G, "SoulPit", nil)
	local sentBefore = #sentMessages
	assert_equal(false, api.soulpit.openWindow(player))
	assert_equal(sentBefore, #sentMessages)

	rawset(_G, "SoulPit", {
		startSoloFight = function()
			return true
		end,
	})
	player.client = { version = 1100 }
	assert_equal(false, api.soulpit.openWindow(player))
	assert_equal(sentBefore, #sentMessages)

	player.client = originalClient
	api.config.soulpit.raceIds = {}
	assert_equal(false, api.soulpit.openWindow(player))
	assert_equal(sentBefore, #sentMessages)

	api.config.soulpit.raceIds = originalRaceIds
	player.client = originalClient
	rawset(_G, "SoulPit", originalAdapter)
end)

test("Soulpit stays inactive while the task board module is disabled", function()
	local originalEnabled = api.config.enabled
	local originalRaceIds = api.config.soulpit.raceIds
	local originalAdapter = rawget(_G, "SoulPit")
	api.config.enabled = false
	api.config.soulpit.raceIds = { 100 }
	rawset(_G, "SoulPit", {
		startSoloFight = function()
			return true
		end,
	})
	local sentBefore = #sentMessages

	local succeeded, failure = pcall(function()
		assert_equal(false, api.soulpit.openWindow(player))
		assert_equal(sentBefore, #sentMessages)
	end)

	api.config.enabled = originalEnabled
	api.config.soulpit.raceIds = originalRaceIds
	rawset(_G, "SoulPit", originalAdapter)
	assert_true(succeeded, failure)
end)

test("Soulpit catalog filters and deduplicates configured races", function()
	local originalRaceIds = api.config.soulpit.raceIds
	api.config.soulpit.raceIds = { 101, "100", 101, 999 }
	local raceIds = api.catalog.getSoulpitRaceIds()
	assert_equal(2, #raceIds)
	assert_equal(100, raceIds[1])
	assert_equal(101, raceIds[2])
	api.config.soulpit.raceIds = originalRaceIds
end)

test("Soulpit authorization permits one exact selection", function()
	local originalRaceIds = api.config.soulpit.raceIds
	local originalAdapter = rawget(_G, "SoulPit")
	local starts = 0
	api.config.soulpit.raceIds = { 100 }
	rawset(_G, "SoulPit", {
		startSoloFight = function()
			starts = starts + 1
			return true
		end,
	})
	local state = api.state.load(player)
	state.general.soulseals = 100
	api.state.save(player, state)
	assert_equal(true, api.soulpit.openWindow(player))
	api.soulpit.handleSelection(player, makeReader({ 100 }, { 2 }))
	api.soulpit.handleSelection(player, makeReader({ 100 }, { 2 }))
	assert_equal(1, starts)

	assert_equal(true, api.soulpit.openWindow(player))
	api.soulpit.handleSelection(player, makeReader({ 101 }, { 2 }))
	api.soulpit.handleSelection(player, makeReader({ 100 }, { 2 }))
	assert_equal(1, starts)
	api.config.soulpit.raceIds = originalRaceIds
	rawset(_G, "SoulPit", originalAdapter)
end)

test("Soulpit authorization does not survive a replaced login session", function()
	local originalRaceIds = api.config.soulpit.raceIds
	local originalAdapter = rawget(_G, "SoulPit")
	local originalSession = player.loginSession
	local starts = 0
	api.config.soulpit.raceIds = { 100 }
	rawset(_G, "SoulPit", {
		startSoloFight = function()
			starts = starts + 1
			return true
		end,
	})

	local succeeded, failure = pcall(function()
		assert_equal(true, api.soulpit.openWindow(player))
		player.loginSession = originalSession + 1
		api.soulpit.handleSelection(player, makeReader({ 100 }, { 2 }))
		assert_equal(0, starts)

		player.loginSession = originalSession
		api.soulpit.handleSelection(player, makeReader({ 100 }, { 2 }))
		assert_equal(0, starts)
	end)
	api.config.soulpit.raceIds = originalRaceIds
	player.loginSession = originalSession
	rawset(_G, "SoulPit", originalAdapter)
	assert_true(succeeded, failure)
end)

test("Soulpit does not persist a debit when the encounter fails to start", function()
	local originalRaceIds = api.config.soulpit.raceIds
	local originalAdapter = rawget(_G, "SoulPit")
	local originalEnsure = api.state.ensure
	local originalSave = api.state.save
	local originalSendBalances = api.wire.sendBalances
	local state = api.state.load(player)
	state.general.soulseals = 100
	local saveCalls = 0
	local balanceCalls = 0
	local abortCalls = 0
	local startFailure = "false"

	api.config.soulpit.raceIds = { 100 }
	api.state.ensure = function()
		return state
	end
	api.state.save = function()
		saveCalls = saveCalls + 1
		error("unexpected save")
	end
	api.wire.sendBalances = function()
		balanceCalls = balanceCalls + 1
	end
	rawset(_G, "SoulPit", {
		startSoloFight = function()
			if startFailure == "error" then
				error("encounter setup failed")
			end
			return false
		end,
		abortSoloFight = function()
			abortCalls = abortCalls + 1
		end,
	})

	local succeeded, failure = pcall(function()
		for _, failureMode in ipairs({ "false", "error" }) do
			startFailure = failureMode
			assert_equal(true, api.soulpit.openWindow(player))
			api.soulpit.handleSelection(player, makeReader({ 100 }, { 2 }))
			assert_equal(100, state.general.soulseals)
		end
		assert_equal(2, abortCalls)
		assert_equal(0, saveCalls)
		assert_equal(0, balanceCalls)
	end)

	api.config.soulpit.raceIds = originalRaceIds
	api.state.ensure = originalEnsure
	api.state.save = originalSave
	api.wire.sendBalances = originalSendBalances
	rawset(_G, "SoulPit", originalAdapter)
	assert_true(succeeded, failure)
end)

test("Soulpit aborts and restores Soulseals when debit persistence fails", function()
	local originalRaceIds = api.config.soulpit.raceIds
	local originalAdapter = rawget(_G, "SoulPit")
	local originalEnsure = api.state.ensure
	local originalSave = api.state.save
	local originalSendBalances = api.wire.sendBalances
	local state = api.state.load(player)
	state.general.soulseals = 100
	local abortCalls = 0
	local balanceCalls = 0

	api.config.soulpit.raceIds = { 100 }
	api.state.ensure = function()
		return state
	end
	api.wire.sendBalances = function()
		balanceCalls = balanceCalls + 1
	end
	rawset(_G, "SoulPit", {
		startSoloFight = function()
			return true
		end,
		abortSoloFight = function()
			abortCalls = abortCalls + 1
		end,
	})

	local succeeded, failure = pcall(function()
		for _, failureMode in ipairs({ "error", "false" }) do
			local saveCalls = 0
			api.state.save = function()
				saveCalls = saveCalls + 1
				if saveCalls == 1 then
					if failureMode == "error" then
						error("storage unavailable")
					end
					return false
				end
				return true
			end

			assert_equal(true, api.soulpit.openWindow(player))
			api.soulpit.handleSelection(player, makeReader({ 100 }, { 2 }))
			assert_equal(100, state.general.soulseals)
			assert_equal(2, saveCalls)
		end
		assert_equal(2, abortCalls)
		assert_equal(0, balanceCalls)
	end)

	api.config.soulpit.raceIds = originalRaceIds
	api.state.ensure = originalEnsure
	api.state.save = originalSave
	api.wire.sendBalances = originalSendBalances
	rawset(_G, "SoulPit", originalAdapter)
	assert_true(succeeded, failure)
end)

test("Soulpit accepts only the six official difficulty costs", function()
	local originalRaceIds = api.config.soulpit.raceIds
	local originalAdapter = rawget(_G, "SoulPit")
	local originalEnsure = api.state.ensure
	local originalSave = api.state.save
	local originalSendBalances = api.wire.sendBalances
	local entry = api.catalog.get(100)
	local originalBestiaryStars = entry.monsterType.BestiaryStars
	local state = api.state.load(player)
	state.general.soulseals = 100
	local starts = 0

	api.config.soulpit.raceIds = { 100 }
	api.state.ensure = function()
		return state
	end
	api.state.save = function()
		return true
	end
	api.wire.sendBalances = function() end
	rawset(_G, "SoulPit", {
		startSoloFight = function()
			starts = starts + 1
			return true
		end,
	})

	local succeeded, failure = pcall(function()
		for difficulty = 0, 5 do
			state.general.soulseals = 100
			entry.monsterType.BestiaryStars = function()
				return difficulty
			end
			assert_equal(true, api.soulpit.openWindow(player))
			api.soulpit.handleSelection(player, makeReader({ 100 }, { 2 }))
			assert_equal(100 - ((difficulty + 1) * 10), state.general.soulseals)
		end
		state.general.soulseals = 100
		for _, difficulty in ipairs({ -1, 1.5, 6 }) do
			entry.monsterType.BestiaryStars = function()
				return difficulty
			end
			assert_equal(true, api.soulpit.openWindow(player))
			api.soulpit.handleSelection(player, makeReader({ 100 }, { 2 }))
		end
		assert_equal(6, starts)
		assert_equal(100, state.general.soulseals)
	end)

	api.config.soulpit.raceIds = originalRaceIds
	api.state.ensure = originalEnsure
	api.state.save = originalSave
	api.wire.sendBalances = originalSendBalances
	entry.monsterType.BestiaryStars = originalBestiaryStars
	rawset(_G, "SoulPit", originalAdapter)
	assert_true(succeeded, failure)
end)

test("bounty generation and kill progression persist through KV", function()
	local state = api.state.ensure(player)
	assert_equal(3, #state.bounty.tasks)
	local raceId = state.bounty.tasks[1].raceId
	state.bounty.tasks[1].required = 1
	api.state.save(player, state)
	api.actions.handle(player, makeReader({ api.action.selectBounty, 0 }, { 1, 1 }))
	api.onMonsterKilled(player, raceId)
	local afterKill = api.state.load(player)
	assert_equal(api.taskState.completed, afterKill.bounty.tasks[1].state)
end)

test("bounty difficulty changes preserve the current assignment", function()
	local originalGenerateBounty = api.rules.generateBounty
	local generationCalls = 0
	api.rules.generateBounty = function(_, state)
		generationCalls = generationCalls + 1
		state.bounty.tasks = {
			{ raceId = 103, required = 200, current = 0, state = api.taskState.notSelected },
		}
		return true
	end

	local succeeded, failure = pcall(function()
		local state = api.state.load(player)
		state.bounty.tasks = {
			{ raceId = 100, required = 100, current = 37, state = api.taskState.selected },
		}
		assert_equal(true, api.rules.chooseBountyDifficulty(player, state, api.difficulty.adept))
		assert_equal(api.difficulty.adept, state.bounty.difficulty)
		assert_equal(0, generationCalls)
		assert_equal(100, state.bounty.tasks[1].raceId)
		assert_equal(37, state.bounty.tasks[1].current)

		state.bounty.tasks[1].current = 100
		state.bounty.tasks[1].state = api.taskState.completed
		assert_equal(true, api.rules.chooseBountyDifficulty(player, state, api.difficulty.beginner))
		assert_equal(api.difficulty.beginner, state.bounty.difficulty)
		assert_equal(0, generationCalls)
		assert_equal(api.taskState.completed, state.bounty.tasks[1].state)

		state.bounty.tasks[1].state = api.taskState.notSelected
		assert_equal(true, api.rules.chooseBountyDifficulty(player, state, api.difficulty.adept))
		assert_equal(1, generationCalls)
		assert_equal(103, state.bounty.tasks[1].raceId)
	end)

	api.rules.generateBounty = originalGenerateBounty
	assert_true(succeeded, failure)
end)

test("reroll tokens replace only available bounty options", function()
	local originalGenerateBounty = api.rules.generateBounty
	local generationCalls = 0
	api.rules.generateBounty = function(_, state)
		generationCalls = generationCalls + 1
		state.bounty.tasks = {
			{ raceId = 103, required = 200, current = 0, state = api.taskState.notSelected },
		}
		return true
	end

	local succeeded, failure = pcall(function()
		local state = api.state.load(player)
		state.bounty.dailyRerolls = 2
		state.bounty.tasks = {
			{ raceId = 100, required = 100, current = 37, state = api.taskState.selected },
		}
		assert_equal(false, api.rules.rerollBounty(player, state))
		assert_equal(2, state.bounty.dailyRerolls)
		assert_equal(0, generationCalls)

		state.bounty.tasks[1].current = 100
		state.bounty.tasks[1].state = api.taskState.completed
		assert_equal(false, api.rules.rerollBounty(player, state))
		assert_equal(2, state.bounty.dailyRerolls)
		assert_equal(0, generationCalls)

		state.bounty.tasks = {
			{ raceId = 100, required = 100, current = 0, state = api.taskState.notSelected },
			{ raceId = 101, required = 100, current = 0, state = api.taskState.notSelected },
		}
		assert_equal(true, api.rules.rerollBounty(player, state))
		assert_equal(1, state.bounty.dailyRerolls)
		assert_equal(1, generationCalls)
		assert_equal(103, state.bounty.tasks[1].raceId)
	end)

	api.rules.generateBounty = originalGenerateBounty
	assert_true(succeeded, failure)
end)

test("bounty state discards unusable options and invalid preferences", function()
	local bountyStorage = {
		["root/task-board/bounty/task-count"] = 3,
		["root/task-board/bounty/task-0/race-id"] = 65000,
		["root/task-board/bounty/task-0/required"] = 5,
		["root/task-board/bounty/task-1/race-id"] = 100,
		["root/task-board/bounty/task-1/required"] = 0,
		["root/task-board/bounty/task-2/race-id"] = 101,
		["root/task-board/bounty/task-2/required"] = 5,
		["root/task-board/bounty/preference-1/unlocked"] = false,
		["root/task-board/bounty/preference-1/preferred-race"] = 65000,
		["root/task-board/bounty/preference-2/unlocked"] = false,
		["root/task-board/bounty/preference-2/preferred-race"] = 100,
	}
	local bountyPlayer = {
		getLevel = function()
			return 50
		end,
		kv = function()
			return makeScope(bountyStorage, "root")
		end,
	}

	local state = api.state.load(bountyPlayer)
	assert_equal(0, #state.bounty.tasks)
	assert_equal(true, state.bounty.preferences[1].unlocked)
	assert_equal(0, state.bounty.preferences[1].preferredRace)
	assert_equal(false, state.bounty.preferences[2].unlocked)
	assert_equal(0, state.bounty.preferences[2].preferredRace)
	state = api.state.ensure(bountyPlayer)
	assert_equal(api.config.bounty.slotCount, #state.bounty.tasks)
end)

test("bounty state keeps one coherent active assignment", function()
	local bountyStorage = {
		["root/task-board/bounty/task-count"] = 2,
		["root/task-board/bounty/task-0/race-id"] = 100,
		["root/task-board/bounty/task-0/required"] = 5,
		["root/task-board/bounty/task-0/current"] = 9,
		["root/task-board/bounty/task-0/state"] = api.taskState.selected,
		["root/task-board/bounty/task-1/race-id"] = 101,
		["root/task-board/bounty/task-1/required"] = 5,
		["root/task-board/bounty/task-1/state"] = api.taskState.notSelected,
	}
	local bountyPlayer = {
		getLevel = function()
			return 50
		end,
		kv = function()
			return makeScope(bountyStorage, "root")
		end,
	}

	local state = api.state.load(bountyPlayer)
	assert_equal(1, #state.bounty.tasks)
	assert_equal(100, state.bounty.tasks[1].raceId)
	assert_equal(5, state.bounty.tasks[1].current)
	assert_equal(api.taskState.completed, state.bounty.tasks[1].state)
end)

test("gold bounty marker multiplies bounty points", function()
	local originalGetPool = api.catalog.getPool
	local originalRandom = math.random
	local rolls = { 1, 1, 50 }
	local state = api.state.load(player)
	state.bounty.difficulty = api.difficulty.beginner
	api.catalog.getPool = function()
		return { { raceId = 100 } }
	end
	math.random = function()
		return table.remove(rolls, 1)
	end

	local generated, generationError = pcall(api.rules.generateBounty, player, state)
	api.catalog.getPool = originalGetPool
	math.random = originalRandom
	assert_true(generated, generationError)

	local task = state.bounty.tasks[1]
	assert_equal(api.taskKind.gold, task.marker)
	assert_equal(12, task.bountyPoints)
end)

test("bounty marker chances reserve ten percent for silver", function()
	local originalGetPool = api.catalog.getPool
	local originalRandom = math.random
	local rolls = { 1, 16, 50 }
	local state = api.state.load(player)
	state.bounty.difficulty = api.difficulty.beginner
	api.catalog.getPool = function()
		return { { raceId = 100 } }
	end
	math.random = function()
		return table.remove(rolls, 1)
	end

	local generated, generationError = pcall(api.rules.generateBounty, player, state)
	api.catalog.getPool = originalGetPool
	math.random = originalRandom
	assert_true(generated, generationError)
	assert_equal(api.taskKind.normal, state.bounty.tasks[1].marker)
end)

test("bounty experience rounds before the task marker multiplier", function()
	local originalGetPool = api.catalog.getPool
	local originalRandom = math.random
	local rolls = { 1, 10, 101 }
	local state = api.state.load(player)
	state.bounty.difficulty = api.difficulty.adept
	api.catalog.getPool = function()
		return { { raceId = 100 } }
	end
	math.random = function()
		return table.remove(rolls, 1)
	end

	local generated, generationError = pcall(api.rules.generateBounty, player, state)
	api.catalog.getPool = originalGetPool
	math.random = originalRandom
	assert_true(generated, generationError)

	local task = state.bounty.tasks[1]
	assert_equal(api.taskKind.silver, task.marker)
	assert_equal(19694, task.experience)
end)

test("preferred races receive their configured bounty priority", function()
	local originalGetPool = api.catalog.getPool
	local originalRandom = math.random
	local state = api.state.load(player)
	state.bounty.preferences = {
		{ unlocked = true, preferredRace = 100, unwantedRace = 0 },
	}
	api.catalog.getPool = function()
		return { { raceId = 100 }, { raceId = 101 } }
	end
	local chanceRolls = 0
	math.random = function(minimum, maximum)
		if maximum == 100 then
			chanceRolls = chanceRolls + 1
			return chanceRolls == 1 and 1 or 50
		end
		return minimum
	end

	local generated, generationError = pcall(api.rules.generateBounty, player, state)
	api.catalog.getPool = originalGetPool
	math.random = originalRandom
	assert_true(generated, generationError)
	assert_equal(100, state.bounty.tasks[1].raceId)
	assert_true(state.bounty.tasks[2].raceId ~= state.bounty.tasks[1].raceId)
end)

test("unwanted race chance applies only to bounty candidates", function()
	local originalGetPool = api.catalog.getPool
	local originalRandom = math.random
	api.catalog.getPool = function()
		return { { raceId = 100 }, { raceId = 101 }, { raceId = 102 }, { raceId = 103 } }
	end
	math.random = function(minimum)
		return minimum
	end
	local state = api.state.load(player)
	state.bounty.preferences = {
		{ unlocked = true, preferredRace = 0, unwantedRace = 100 },
	}

	local generated, generationError = pcall(api.rules.generateBounty, player, state)
	api.catalog.getPool = originalGetPool
	math.random = originalRandom
	assert_true(generated, generationError)
	for _, task in ipairs(state.bounty.tasks) do
		assert_true(task.raceId ~= 100)
	end
end)

test("bounty preferences do not alter weekly candidates", function()
	local originalGetPool = api.catalog.getPool
	local originalRandom = math.random
	api.catalog.getPool = function()
		return { { raceId = 100 }, { raceId = 101 } }
	end
	math.random = function(minimum)
		return minimum
	end
	local state = api.state.load(player)
	state.bounty.preferences = {
		{ unlocked = true, preferredRace = 0, unwantedRace = 100 },
	}
	state.weekly.difficulty = api.difficulty.beginner

	local generated, generationError = pcall(api.rules.generateWeekly, player, state, false)
	api.catalog.getPool = originalGetPool
	math.random = originalRandom
	assert_true(generated, generationError)
	assert_equal(100, state.weekly.kills[1].raceId)
end)

test("weekly creature tasks are ordered by required kills", function()
	local originalGetPool = api.catalog.getPool
	local originalRandom = math.random
	local rolls = { 1, 1, 1, 30, 10, 10 }
	api.catalog.getPool = function()
		return { { raceId = 100 }, { raceId = 101 }, { raceId = 102 } }
	end
	math.random = function(minimum)
		return table.remove(rolls, 1) or minimum
	end
	local state = api.state.load(player)
	state.weekly.difficulty = api.difficulty.beginner

	local generated, generationError = pcall(api.rules.generateWeekly, player, state, false)
	api.catalog.getPool = originalGetPool
	math.random = originalRandom
	assert_true(generated, generationError)
	assert_equal(10, state.weekly.kills[1].required)
	assert_equal(101, state.weekly.kills[1].raceId)
	assert_equal(10, state.weekly.kills[2].required)
	assert_equal(102, state.weekly.kills[2].raceId)
	assert_equal(30, state.weekly.kills[3].required)
	assert_equal(100, state.weekly.kills[3].raceId)
end)

test("weekly delivery requirements use the configured item range", function()
	local originalItems = api.config.weeklyItems
	local originalKillSlots = api.config.weekly.killSlots
	local originalItemSlots = api.config.weekly.itemSlots
	local originalRandom = math.random
	api.config.weeklyItems = { { id = 3031, min = 73, max = 73 } }
	api.config.weekly.killSlots = 0
	api.config.weekly.itemSlots = 1
	math.random = function(minimum)
		return minimum
	end

	local succeeded, failure = pcall(function()
		for difficulty = api.difficulty.beginner, api.difficulty.master do
			local state = api.state.load(player)
			state.weekly.difficulty = difficulty
			api.rules.generateWeekly(player, state, false)
			assert_equal(1, #state.weekly.items)
			assert_equal(73, state.weekly.items[1].required)
		end
	end)

	api.config.weeklyItems = originalItems
	api.config.weekly.killSlots = originalKillSlots
	api.config.weekly.itemSlots = originalItemSlots
	math.random = originalRandom
	assert_true(succeeded, failure)
end)

test("default task board items use the current Canary ids", function()
	local expectedItems = {
		{ id = 3031, name = "gold coin" },
		{ id = 3582, name = "ham" },
		{ id = 3577, name = "meat" },
		{ id = 3592, name = "grapes" },
		{ id = 3601, name = "roll" },
		{ id = 3578, name = "fish" },
		{ id = 3600, name = "bread" },
		{ id = 3586, name = "orange" },
		{ id = 3583, name = "dragon ham" },
	}
	local itemFile = assert(io.open("data/items/items.xml", "r"))
	local itemXml = itemFile:read("*a")
	itemFile:close()
	local function assertItemDefinition(itemId, expectedName)
		local itemTag = itemXml:match('<item id="' .. itemId .. '"[^>]*>')
		assert_true(itemTag ~= nil, "missing item definition for " .. itemId)
		assert_true(itemTag:find('name="' .. expectedName .. '"', 1, true) ~= nil, "unexpected item name for " .. itemId)
	end

	assert_equal(#expectedItems, #api.config.weeklyItems)
	for index, expected in ipairs(expectedItems) do
		local configured = api.config.weeklyItems[index]
		assert_equal(expected.id, configured.id)
		assert_equal(nil, configured.name)
		assertItemDefinition(expected.id, expected.name)
	end
	assertItemDefinition(api.config.talisman.itemId, "bounty talisman")
	assertItemDefinition(api.config.shopOffers[1].id, api.config.shopOffers[1].name)

	local state = api.state.load(player)
	state.weekly.selectionPending = false
	state.weekly.anyCreature = { required = 1, current = 0, completed = false }
	state.weekly.kills = {}
	state.weekly.items = { { itemId = expectedItems[1].id, required = 1, current = 0, completed = false } }
	state.weekly.killsCompleted = 0
	state.weekly.itemsCompleted = 0
	state.weekly.points = 0
	state.weekly.soulseals = 0
	local sentBefore = #sentMessages
	api.wire.sendWeekly(player, state)
	local weeklyMessage = sentMessages[sentBefore + 1]
	assert_equal("u32", weeklyMessage.events[8].operation)
	assert_equal(expectedItems[1].id, weeklyMessage.events[8].value)
end)

test("weekly catalog ignores ids missing from the loaded item types", function()
	local originalItems = api.config.weeklyItems
	local originalItemType = rawget(_G, "ItemType")
	api.config.weeklyItems = {
		{ id = 3031, min = 1, max = 1 },
		{ id = 65000, min = 1, max = 1 },
	}
	rawset(
		_G,
		"ItemType",
		setmetatable({}, {
			__call = function(_, itemId)
				return {
					getId = function()
						return itemId == 3031 and itemId or 0
					end,
					getName = function()
						return itemId == 3031 and "gold coin" or ""
					end,
				}
			end,
		})
	)

	local succeeded, failure = pcall(function()
		local items = api.catalog.getWeeklyItems()
		assert_equal(1, #items)
		assert_equal(3031, items[1].id)
	end)

	api.config.weeklyItems = originalItems
	rawset(_G, "ItemType", originalItemType)
	assert_true(succeeded, failure)
end)

test("weekly experience follows the level at task completion", function()
	local level = 50
	local experiencePlayer = {
		experience = 0,
		getLevel = function()
			return level
		end,
		kv = function()
			return makeScope({}, "weekly-experience")
		end,
		addExperience = function(self, amount)
			self.experience = self.experience + amount
		end,
	}
	local state = api.state.load(experiencePlayer)
	state.weekly.difficulty = api.difficulty.beginner
	state.weekly.selectionPending = false
	state.weekly.anyCreature = { required = 1, current = 0, completed = false }
	state.weekly.kills = {}
	state.weekly.items = {}
	state.weekly.killExperience = api.rules.calculateWeeklyExperience(level, state.weekly.difficulty, false)
	state.weekly.itemExperience = api.rules.calculateWeeklyExperience(level, state.weekly.difficulty, true)

	level = 200
	local expected = api.rules.calculateWeeklyExperience(level, state.weekly.difficulty, false)
	assert_equal(true, api.rules.updateWeeklyOnKill(experiencePlayer, state, 100))
	assert_equal(expected, state.weekly.killExperience)
	assert_equal(expected, experiencePlayer.experience)

	level = 250
	state.weekly.items = { { index = 0, itemId = 3031, required = 1, current = 0, completed = false } }
	local expectedItem = api.rules.calculateWeeklyExperience(level, state.weekly.difficulty, true)
	assert_equal(true, api.rules.ensureWeekly(experiencePlayer, state))
	assert_equal(expectedItem, state.weekly.itemExperience)
end)

test("weekly rewards refresh remaining experience after a level gain", function()
	local level = 50
	local awardCount = 0
	local experiencePlayer = {
		experience = 0,
		items = { [3031] = 1 },
		getLevel = function()
			return level
		end,
		getClient = function()
			return { version = 1525 }
		end,
		kv = function()
			return makeScope({}, "weekly-reward-level")
		end,
		addExperience = function(self, amount)
			self.experience = self.experience + amount
			awardCount = awardCount + 1
			if awardCount == 1 then
				level = 200
			end
		end,
		getItemCount = function(self, itemId)
			return self.items[itemId] or 0
		end,
		getStashItemCount = function()
			return 0
		end,
		removeItem = function(self, itemId, amount)
			self.items[itemId] = (self.items[itemId] or 0) - amount
			return true
		end,
	}

	local state = api.state.load(experiencePlayer)
	state.weekly.difficulty = api.difficulty.beginner
	state.weekly.selectionPending = false
	state.weekly.anyCreature = { required = 1, current = 0, completed = false }
	state.weekly.kills = { { raceId = 100, required = 1, current = 0, completed = false } }
	state.weekly.items = {}
	state.weekly.killExperience = api.rules.calculateWeeklyExperience(level, state.weekly.difficulty, false)
	state.weekly.itemExperience = api.rules.calculateWeeklyExperience(level, state.weekly.difficulty, true)
	local initialExperience = state.weekly.killExperience

	assert_equal(true, api.rules.updateWeeklyOnKill(experiencePlayer, state, 100))
	local refreshedExperience = api.rules.calculateWeeklyExperience(level, state.weekly.difficulty, false)
	assert_equal(initialExperience + refreshedExperience, experiencePlayer.experience)
	assert_equal(refreshedExperience, state.weekly.killExperience)
	assert_equal(api.rules.calculateWeeklyExperience(level, state.weekly.difficulty, true), state.weekly.itemExperience)

	level = 50
	awardCount = 0
	experiencePlayer.experience = 0
	experiencePlayer.items[3031] = 1
	state.weekly.anyCreature = { required = 1, current = 0, completed = false }
	state.weekly.kills = {}
	state.weekly.items = { { index = 0, itemId = 3031, required = 1, current = 0, completed = false } }
	state.weekly.killsCompleted = 0
	state.weekly.itemsCompleted = 0
	state.weekly.points = 0
	state.weekly.soulseals = 0
	state.weekly.killExperience = api.rules.calculateWeeklyExperience(level, state.weekly.difficulty, false)
	state.weekly.itemExperience = api.rules.calculateWeeklyExperience(level, state.weekly.difficulty, true)
	local deliveryExperience = state.weekly.itemExperience

	assert_equal(true, api.rules.deliverWeeklyItem(experiencePlayer, state, 0))
	assert_equal(deliveryExperience, experiencePlayer.experience)
	assert_equal(api.rules.calculateWeeklyExperience(level, state.weekly.difficulty, false), state.weekly.killExperience)
	assert_equal(api.rules.calculateWeeklyExperience(level, state.weekly.difficulty, true), state.weekly.itemExperience)
end)

test("wheel purchases persist the multiplier consumed by the Wheel", function()
	local originalTaskPoints = player.taskPoints
	local state = api.state.load(player)
	state.wheel.multiplier = 1
	state.wheel.price = 100
	player.taskPoints = 500

	assert_equal(true, api.rules.purchaseShopOffer(player, state, #api.config.shopOffers))
	assert_equal(400, player.taskPoints)
	assert_equal(2, state.wheel.multiplier)
	assert_equal(200, state.wheel.price)
	assert_equal(true, api.state.save(player, state))
	local persisted = api.state.load(player)
	assert_equal(2, persisted.wheel.multiplier)
	assert_equal(200, persisted.wheel.price)
	player.taskPoints = originalTaskPoints
end)

test("wheel state derives its price from a bounded multiplier", function()
	local wheelStorage = {
		["root/task-board/wheel/multiplier"] = 5,
		["root/task-board/wheel/price"] = 0,
	}
	local wheelPlayer = {
		getLevel = function()
			return 50
		end,
		kv = function()
			return makeScope(wheelStorage, "root")
		end,
	}
	local state = api.state.load(wheelPlayer)
	assert_equal(5, state.wheel.multiplier)
	assert_equal(1100, state.wheel.price)

	wheelStorage["root/task-board/wheel/multiplier"] = 0
	state = api.state.load(wheelPlayer)
	assert_equal(1, state.wheel.multiplier)
	assert_equal(100, state.wheel.price)

	wheelStorage["root/task-board/wheel/multiplier"] = 500
	state = api.state.load(wheelPlayer)
	assert_equal(51, state.wheel.multiplier)
	assert_equal(122600, state.wheel.price)
end)

test("wheel shop grants all fifty promotion points", function()
	local originalTaskPoints = player.taskPoints
	local state = api.state.load(player)
	state.wheel.multiplier = api.config.wheel.maximumMultiplier
	state.wheel.price = api.getWheelPrice(state.wheel.multiplier)
	player.taskPoints = state.wheel.price

	local succeeded, failure = pcall(function()
		assert_equal(true, api.rules.purchaseShopOffer(player, state, #api.config.shopOffers))
		assert_equal(0, player.taskPoints)
		assert_equal(api.config.wheel.maximumMultiplier + 1, state.wheel.multiplier)
		assert_equal(false, api.rules.purchaseShopOffer(player, state, #api.config.shopOffers))

		assert_equal(true, api.state.save(player, state))
		assert_equal(api.config.wheel.maximumMultiplier + 1, api.state.load(player).wheel.multiplier)
		sentMessages = {}
		api.wire.sendShop(player, state)
		local message = sentMessages[1]
		local eventCount = #message.events
		assert_equal("u16", message.events[eventCount - 2].operation)
		assert_equal(api.config.wheel.maximumMultiplier, message.events[eventCount - 2].value)
		assert_equal(api.offerState.bought, message.events[eventCount].value)
	end)

	player.taskPoints = originalTaskPoints
	assert_true(succeeded, failure)
end)

test("weekly reset follows the configured server-save clock", function()
	local originalConfigManager = rawget(_G, "configManager")
	local originalConfigKeys = rawget(_G, "configKeys")
	rawset(_G, "configKeys", { GLOBAL_SERVER_SAVE_TIME = 1 })
	rawset(_G, "configManager", {
		getString = function(key)
			assert_equal(1, key)
			return "05:30:00"
		end,
	})

	local succeeded, failure = pcall(function()
		local friday = os.time({ year = 2026, month = 8, day = 14, hour = 12, min = 0, sec = 0 })
		local reset = os.date("*t", api.getWeeklyResetTimestamp(friday))
		assert_equal(2, reset.wday)
		assert_equal(5, reset.hour)
		assert_equal(30, reset.min)
		assert_equal(0, reset.sec)

		local mondayBeforeReset = os.time({ year = 2026, month = 8, day = 10, hour = 4, min = 0, sec = 0 })
		reset = os.date("*t", api.getWeeklyResetTimestamp(mondayBeforeReset))
		assert_equal(10, reset.day)
		assert_equal(5, reset.hour)
		assert_equal(30, reset.min)

		local mondayAfterReset = os.time({ year = 2026, month = 8, day = 10, hour = 6, min = 0, sec = 0 })
		reset = os.date("*t", api.getWeeklyResetTimestamp(mondayAfterReset))
		assert_equal(17, reset.day)
		assert_equal(5, reset.hour)
		assert_equal(30, reset.min)
	end)
	rawset(_G, "configManager", originalConfigManager)
	rawset(_G, "configKeys", originalConfigKeys)
	assert_true(succeeded, failure)
end)

test("default crystal coin offer serializes the current appearance id", function()
	local sentBefore = #sentMessages
	local state = api.state.load(player)
	api.wire.sendShop(player, state)
	local shopMessage = sentMessages[sentBefore + 1]

	assert_equal(api.offerKind.item, shopMessage.events[4].value)
	assert_equal("u32", shopMessage.events[7].operation)
	assert_equal(3043, shopMessage.events[7].value)
end)

test("shop wire caps offers without moving the Wheel index", function()
	local originalOffers = api.config.shopOffers
	local originalTaskPoints = player.taskPoints
	local ok, err = pcall(function()
		local offers = {}
		for index = 1, 260 do
			offers[index] = {
				kind = api.offerKind.item,
				id = 2160,
				name = "offer-" .. index,
				description = "description",
				price = 100,
			}
		end
		api.config.shopOffers = offers
		player.taskPoints = 500
		local state = api.state.load(player)
		state.wheel.multiplier = 1
		state.wheel.price = 100
		local sentBefore = #sentMessages

		api.wire.sendShop(player, state)
		local message = sentMessages[sentBefore + 1]
		assert_equal(0xFF, message.events[3].value)
		local serializedOffers = 0
		local lastOffer
		for _, event in ipairs(message.events) do
			if event.operation == "string" and tostring(event.value):match("^offer%-%d+$") then
				serializedOffers = serializedOffers + 1
				lastOffer = event.value
			end
		end
		assert_equal(0xFE, serializedOffers)
		assert_equal("offer-254", lastOffer)
		assert_equal(0xFE, api.getShopOfferCount())
		assert_equal(true, api.rules.purchaseShopOffer(player, state, 0xFE))
		assert_equal(2, state.wheel.multiplier)
		assert_equal(400, player.taskPoints)
	end)
	api.config.shopOffers = originalOffers
	player.taskPoints = originalTaskPoints
	if not ok then
		error(err, 0)
	end
end)

test("invalid shop prices cannot credit task points", function()
	local originalOffers = api.config.shopOffers
	local originalTaskPoints = player.taskPoints
	local invalidPrices = { -100, 1.5, math.huge, 0 / 0, 0x100000000 }
	local succeeded, failure = pcall(function()
		player.taskPoints = 500
		for _, price in ipairs(invalidPrices) do
			api.config.shopOffers = {
				{
					kind = api.offerKind.item,
					id = 2160,
					name = "invalid price",
					description = "must remain unavailable",
					price = price,
				},
			}
			local state = api.state.load(player)
			assert_equal(api.offerState.notAvailable, api.rules.getShopOfferState(player, state, api.config.shopOffers[1]))
			assert_equal(false, api.rules.purchaseShopOffer(player, state, 0))
			assert_equal(500, player.taskPoints)
		end
	end)
	api.config.shopOffers = originalOffers
	player.taskPoints = originalTaskPoints
	assert_true(succeeded, failure)
end)

test("outfit purchases survive sex changes without a second charge", function()
	local originalOffers = api.config.shopOffers
	local originalStorage = storage
	local originalTaskPoints = player.taskPoints
	local originalSex = player.sex
	local originalOutfits = player.outfits
	local originalGetSex = player.getSex
	local originalHasOutfit = player.hasOutfit
	local originalAddOutfit = player.addOutfit
	local originalAddOutfitAddon = player.addOutfitAddon
	local ok, err = pcall(function()
		api.config.shopOffers = {
			{
				kind = api.offerKind.outfit,
				outfitId = { male = 700, female = 701 },
				addon = 0,
				price = 100,
			},
			{
				kind = api.offerKind.outfit,
				outfitId = { male = 700, female = 701 },
				addon = 1,
				price = 50,
			},
		}
		storage = {}
		player.taskPoints = 1000
		player.sex = 0
		player.outfits = {}
		player.getSex = function(self)
			return self.sex
		end
		player.hasOutfit = function(self, lookType, addon)
			local owned = self.outfits[lookType]
			return owned ~= nil and owned[addon or 0] == true
		end
		local function addOutfit(self, lookType, addon)
			self.outfits[lookType] = self.outfits[lookType] or { [0] = true }
			self.outfits[lookType][addon or 0] = true
			return true
		end
		player.addOutfit = addOutfit
		player.addOutfitAddon = addOutfit

		local state = api.state.ensure(player)
		assert_equal(true, api.rules.purchaseShopOffer(player, state, 0))
		assert_equal(true, player.outfits[700][0])
		assert_equal(true, player.outfits[701][0])
		assert_equal(900, player.taskPoints)
		assert_equal(true, api.state.save(player, state))

		player.outfits = {}
		player.sex = PLAYERSEX_FEMALE
		state = api.state.load(player)
		assert_equal(api.offerState.bought, api.rules.getShopOfferState(player, state, api.config.shopOffers[1]))
		assert_equal(api.offerState.available, api.rules.getShopOfferState(player, state, api.config.shopOffers[2]))
		assert_equal(true, api.rules.purchaseShopOffer(player, state, 1))
		assert_equal(true, player.outfits[700][1])
		assert_equal(true, player.outfits[701][1])
		assert_equal(850, player.taskPoints)
		assert_equal(true, api.state.save(player, state))

		player.outfits = {}
		state = api.state.load(player)
		assert_equal(api.offerState.bought, api.rules.getShopOfferState(player, state, api.config.shopOffers[2]))
		assert_equal(
			api.offerState.notAvailable,
			api.rules.getShopOfferState(player, state, {
				kind = api.offerKind.outfit,
				outfitId = { male = 0, female = 701 },
				addon = 0,
				price = 1,
			})
		)
	end)
	api.config.shopOffers = originalOffers
	storage = originalStorage
	player.taskPoints = originalTaskPoints
	player.sex = originalSex
	player.outfits = originalOutfits
	player.getSex = originalGetSex
	player.hasOutfit = originalHasOutfit
	player.addOutfit = originalAddOutfit
	player.addOutfitAddon = originalAddOutfitAddon
	if not ok then
		error(err, 0)
	end
end)

test("shop item rewards are delivered to the store inbox", function()
	local originalGetStoreInbox = player.getStoreInbox
	local originalCreateItem = Game.createItem
	local originalSystemTime = rawget(_G, "systemTime")
	local originalStoreAttribute = rawget(_G, "ITEM_ATTRIBUTE_STORE")
	local originalIndexWherever = rawget(_G, "INDEX_WHEREEVER")
	local originalFlagNoLimit = rawget(_G, "FLAG_NOLIMIT")
	local originalReturnNoError = rawget(_G, "RETURNVALUE_NOERROR")
	local originalTaskPoints = player.taskPoints
	local inbox = { items = {} }
	function inbox:getItems()
		return self.items
	end
	function inbox:getMaxCapacity()
		return 10
	end
	function inbox:addItemEx(item)
		item.parent = self
		table.insert(self.items, item)
		return RETURNVALUE_NOERROR
	end
	player.getStoreInbox = function()
		return inbox
	end
	Game.createItem = function(itemId, count)
		return {
			id = itemId,
			count = count,
			setOwner = function(self, owner)
				self.owner = owner
			end,
			setAttribute = function(self, attribute, value)
				self[attribute] = value
			end,
		}
	end
	rawset(_G, "systemTime", function()
		return 1234
	end)
	rawset(_G, "ITEM_ATTRIBUTE_STORE", "store")
	rawset(_G, "INDEX_WHEREEVER", -1)
	rawset(_G, "FLAG_NOLIMIT", 1)
	rawset(_G, "RETURNVALUE_NOERROR", 0)
	player.taskPoints = 500

	local succeeded, failure = pcall(function()
		local state = api.state.load(player)
		assert_equal(true, api.rules.purchaseShopOffer(player, state, 0))
		assert_equal(400, player.taskPoints)
		assert_equal(1, #inbox.items)
		assert_equal(3043, inbox.items[1].id)
		assert_equal(player, inbox.items[1].owner)
		assert_equal(1234, inbox.items[1].store)
	end)

	player.getStoreInbox = originalGetStoreInbox
	Game.createItem = originalCreateItem
	rawset(_G, "systemTime", originalSystemTime)
	rawset(_G, "ITEM_ATTRIBUTE_STORE", originalStoreAttribute)
	rawset(_G, "INDEX_WHEREEVER", originalIndexWherever)
	rawset(_G, "FLAG_NOLIMIT", originalFlagNoLimit)
	rawset(_G, "RETURNVALUE_NOERROR", originalReturnNoError)
	player.taskPoints = originalTaskPoints
	assert_true(succeeded, failure)
end)

test("paired decoration delivery rolls back a partial store inbox batch", function()
	local originalOffers = api.config.shopOffers
	local originalGetStoreInbox = player.getStoreInbox
	local originalCreateItem = Game.createItem
	local originalDecorationKit = rawget(_G, "ITEM_DECORATION_KIT")
	local originalIndexWherever = rawget(_G, "INDEX_WHEREEVER")
	local originalFlagNoLimit = rawget(_G, "FLAG_NOLIMIT")
	local originalReturnNoError = rawget(_G, "RETURNVALUE_NOERROR")
	local originalTaskPoints = player.taskPoints
	local inbox = { items = {}, additions = 0 }
	local createdItems = {}
	function inbox:getItems()
		return self.items
	end
	function inbox:getMaxCapacity()
		return 10
	end
	function inbox:addItemEx(item)
		self.additions = self.additions + 1
		if self.additions == 2 then
			return 1
		end
		item.parent = self
		table.insert(self.items, item)
		return RETURNVALUE_NOERROR
	end
	player.getStoreInbox = function()
		return inbox
	end
	Game.createItem = function(itemId)
		local item = {
			id = itemId,
			setOwner = function() end,
			setAttribute = function() end,
			setCustomAttribute = function(self, key, value)
				self[key] = value
			end,
			remove = function(self)
				if not self.parent then
					return true
				end
				for index, stored in ipairs(self.parent.items) do
					if stored == self then
						table.remove(self.parent.items, index)
						return true
					end
				end
				return false
			end,
		}
		table.insert(createdItems, item)
		return item
	end
	api.config.shopOffers = {
		{ kind = api.offerKind.decoration, id = 32795, secondId = 32796, name = "bone bed", price = 100 },
	}
	rawset(_G, "ITEM_DECORATION_KIT", 23398)
	rawset(_G, "INDEX_WHEREEVER", -1)
	rawset(_G, "FLAG_NOLIMIT", 1)
	rawset(_G, "RETURNVALUE_NOERROR", 0)
	player.taskPoints = 500

	local succeeded, failure = pcall(function()
		local state = api.state.load(player)
		assert_equal(false, api.rules.purchaseShopOffer(player, state, 0))
		assert_equal(500, player.taskPoints)
		assert_equal(0, #inbox.items)
		assert_equal(2, inbox.additions)
		assert_equal(23398, createdItems[1].id)
		assert_equal(32795, createdItems[1].unWrapId)
		assert_equal(23398, createdItems[2].id)
		assert_equal(32796, createdItems[2].unWrapId)
	end)

	api.config.shopOffers = originalOffers
	player.getStoreInbox = originalGetStoreInbox
	Game.createItem = originalCreateItem
	rawset(_G, "ITEM_DECORATION_KIT", originalDecorationKit)
	rawset(_G, "INDEX_WHEREEVER", originalIndexWherever)
	rawset(_G, "FLAG_NOLIMIT", originalFlagNoLimit)
	rawset(_G, "RETURNVALUE_NOERROR", originalReturnNoError)
	player.taskPoints = originalTaskPoints
	assert_true(succeeded, failure)
end)

test("weekly delivery restores stash before a failed backpack removal", function()
	local originalGetItemCount = player.getItemCount
	local originalRemoveItem = player.removeItem
	local originalRemoveStashItem = player.removeStashItem
	local originalAddItemStash = player.addItemStash
	local itemId = 3031
	local originalInventoryCount = player.items[itemId]
	local originalStashCount = player.stashItems[itemId]
	local state = api.state.load(player)
	state.weekly.selectionPending = false
	state.weekly.items = { { itemId = itemId, required = 5, current = 0, completed = false } }
	state.weekly.itemsCompleted = 0
	player.items[itemId] = 3
	player.stashItems[itemId] = 2
	local operations = {}

	player.getItemCount = function(self, id, subtype, ignoreEquipped, ignoreStoreInbox)
		assert_equal(-1, subtype)
		assert_equal(true, ignoreEquipped)
		assert_equal(true, ignoreStoreInbox)
		return originalGetItemCount(self, id)
	end
	player.removeStashItem = function(self, id, amount)
		table.insert(operations, "remove-stash")
		return originalRemoveStashItem(self, id, amount)
	end
	player.removeItem = function(_, _, _, subtype, ignoreEquipped, ignoreStoreInbox)
		table.insert(operations, "remove-backpack")
		assert_equal(-1, subtype)
		assert_equal(true, ignoreEquipped)
		assert_equal(true, ignoreStoreInbox)
		return false
	end
	player.addItemStash = function(self, id, amount)
		table.insert(operations, "restore-stash")
		return originalAddItemStash(self, id, amount)
	end

	local succeeded, failure = pcall(function()
		assert_equal(false, api.rules.deliverWeeklyItem(player, state, 0))
		assert_equal("remove-stash", operations[1])
		assert_equal("remove-backpack", operations[2])
		assert_equal("restore-stash", operations[3])
		assert_equal(2, player.stashItems[itemId])
		assert_equal(3, player.items[itemId])
		assert_equal(false, state.weekly.items[1].completed)
		assert_equal(0, state.weekly.itemsCompleted)
	end)

	player.getItemCount = originalGetItemCount
	player.removeItem = originalRemoveItem
	player.removeStashItem = originalRemoveStashItem
	player.addItemStash = originalAddItemStash
	player.items[itemId] = originalInventoryCount
	player.stashItems[itemId] = originalStashCount
	assert_true(succeeded, failure)
end)

test("unupgraded bounty talisman applies its baseline bonuses", function()
	local originalDamageChance = api.config.talisman.damageActivationChance
	local originalLifeLeechChance = api.config.talisman.lifeLeechActivationChance
	local originalAmmo = player.equippedAmmo
	local originalRandom = math.random
	local state = api.state.load(player)
	state.bounty.tasks = {
		{ raceId = 100, required = 10, current = 0, state = api.taskState.selected, bountyPoints = 3, experience = 0, marker = 0 },
	}
	state.upgrades.moreLoot = 0
	state.upgrades.damage = 0
	state.upgrades.lifeLeech = 0
	state.upgrades.doubleBestiary = 0
	api.state.save(player, state)
	player.equippedAmmo = {
		getId = function()
			return api.config.talisman.itemId
		end,
	}
	player.bestiaryBonusKills = 0
	player.bestiaryUnlocked = false
	api.config.talisman.damageActivationChance = 100
	api.config.talisman.lifeLeechActivationChance = 100
	math.random = function()
		return 1
	end
	local target = {
		getType = function()
			return Game.getMonsterTypes().alpha
		end,
	}

	local succeeded, failure = pcall(function()
		assert_equal(0.025, api.rules.getLootBonus(player, { raceId = 100 }))
		assert_equal(2.5, api.rules.getDamageBonus(player, target))
		assert_equal(2.5, api.rules.getLifeLeechBonus(player, target))
		api.rules.onMonsterKilled(player, 100)
		assert_equal(1, player.bestiaryBonusKills)
	end)

	api.config.talisman.damageActivationChance = originalDamageChance
	api.config.talisman.lifeLeechActivationChance = originalLifeLeechChance
	player.equippedAmmo = originalAmmo
	player.bestiaryUnlocked = false
	math.random = originalRandom
	assert_true(succeeded, failure)
end)

test("disabled taskboard suppresses every talisman effect", function()
	local originalEnabled = api.config.enabled
	local originalDamageChance = api.config.talisman.damageActivationChance
	local originalLifeLeechChance = api.config.talisman.lifeLeechActivationChance
	local originalAmmo = player.equippedAmmo
	local originalRandom = math.random
	local state = api.state.load(player)
	state.bounty.tasks = {
		{ raceId = 100, required = 10, current = 0, state = api.taskState.selected, bountyPoints = 3, experience = 0, marker = 0 },
	}
	state.upgrades.moreLoot = 1
	state.upgrades.damage = 1
	state.upgrades.lifeLeech = 1
	state.upgrades.doubleBestiary = api.config.upgrades.maxLevel
	api.state.save(player, state)
	player.equippedAmmo = {
		getId = function()
			return api.config.talisman.itemId
		end,
	}
	player.bestiaryBonusKills = 0
	player.bestiaryUnlocked = false
	api.config.talisman.damageActivationChance = 100
	api.config.talisman.lifeLeechActivationChance = 100
	api.config.enabled = false
	math.random = function()
		return 1
	end
	local target = {
		getType = function()
			return Game.getMonsterTypes().alpha
		end,
	}

	local succeeded, failure = pcall(function()
		assert_equal(0, api.rules.getLootBonus(player, { raceId = 100 }))
		assert_equal(0, api.rules.getDamageBonus(player, target))
		assert_equal(0, api.rules.getLifeLeechBonus(player, target))
		api.rules.onMonsterKilled(player, 100)
		assert_equal(0, player.bestiaryBonusKills)
		assert_equal(0, api.state.load(player).bounty.tasks[1].current)
	end)

	api.config.enabled = originalEnabled
	api.config.talisman.damageActivationChance = originalDamageChance
	api.config.talisman.lifeLeechActivationChance = originalLifeLeechChance
	player.equippedAmmo = originalAmmo
	player.bestiaryUnlocked = false
	math.random = originalRandom
	assert_true(succeeded, failure)
end)

test("talisman effects require the bounty talisman in the ammo slot", function()
	local originalConfigManager = rawget(_G, "configManager")
	local originalConfigKeys = rawget(_G, "configKeys")
	local originalKv = rawget(_G, "KV")
	local originalConcoction = rawget(_G, "Concoction")
	local state = api.state.load(player)
	state.bounty.tasks = {
		{ raceId = 100, required = 10, current = 0, state = api.taskState.selected, bountyPoints = 3, experience = 0, marker = 0 },
	}
	state.upgrades.moreLoot = 1
	state.upgrades.damage = 1
	state.upgrades.lifeLeech = 1
	state.upgrades.doubleBestiary = api.config.upgrades.maxLevel
	api.state.save(player, state)
	local target = {
		getType = function()
			return Game.getMonsterTypes().alpha
		end,
	}

	player.equippedAmmo = nil
	assert_equal(0, api.rules.getLootBonus(player, { raceId = 100 }))
	local damageBonus, lifeLeechBonus = api.rules.getCombatBonuses(player, target)
	assert_equal(0, damageBonus)
	assert_equal(0, lifeLeechBonus)
	player.bestiaryBonusKills = 0
	api.rules.onMonsterKilled(player, 100)
	assert_equal(0, player.bestiaryBonusKills)

	player.equippedAmmo = {
		getId = function()
			return api.config.talisman.itemId
		end,
	}
	local originalDamageChance = api.config.talisman.damageActivationChance
	local originalLifeLeechChance = api.config.talisman.lifeLeechActivationChance
	api.config.talisman.damageActivationChance = 100
	api.config.talisman.lifeLeechActivationChance = 100
	rawset(_G, "configKeys", { BESTIARY_KILL_MULTIPLIER = 1 })
	rawset(_G, "configManager", {
		getNumber = function()
			return 3
		end,
	})
	rawset(_G, "KV", {
		scoped = function()
			return {
				get = function()
					return true
				end,
			}
		end,
	})
	rawset(_G, "Concoction", {
		Ids = { BestiaryBetterment = 1 },
		find = function()
			return {
				active = function()
					return true
				end,
			}
		end,
	})
	local succeeded, failure = pcall(function()
		assert_true(api.rules.getLootBonus(player, { raceId = 100 }) > 0)
		damageBonus, lifeLeechBonus = api.rules.getCombatBonuses(player, target)
		api.rules.onMonsterKilled(player, 100)
		player.bestiaryUnlocked = true
		api.rules.onMonsterKilled(player, 100)
		assert_true(damageBonus > 0)
		assert_true(lifeLeechBonus > 0)
		assert_equal(12, player.bestiaryBonusKills)
	end)
	api.config.talisman.damageActivationChance = originalDamageChance
	api.config.talisman.lifeLeechActivationChance = originalLifeLeechChance
	player.equippedAmmo = nil
	player.bestiaryUnlocked = false
	rawset(_G, "configManager", originalConfigManager)
	rawset(_G, "configKeys", originalConfigKeys)
	rawset(_G, "KV", originalKv)
	rawset(_G, "Concoction", originalConcoction)
	assert_true(succeeded, failure)
end)

test("non-finite talisman activation chances remain disabled", function()
	local originalDamageChance = api.config.talisman.damageActivationChance
	local originalLifeLeechChance = api.config.talisman.lifeLeechActivationChance
	local originalAmmo = player.equippedAmmo
	local state = api.state.load(player)
	state.bounty.tasks = {
		{ raceId = 100, required = 10, current = 0, state = api.taskState.selected, bountyPoints = 3, experience = 0, marker = 0 },
	}
	state.upgrades.damage = 1
	state.upgrades.lifeLeech = 1
	api.state.save(player, state)
	player.equippedAmmo = {
		getId = function()
			return api.config.talisman.itemId
		end,
	}
	local target = {
		getType = function()
			return Game.getMonsterTypes().alpha
		end,
	}

	local succeeded, failure = pcall(function()
		api.config.talisman.damageActivationChance = math.huge
		api.config.talisman.lifeLeechActivationChance = 0 / 0
		local damageBonus, lifeLeechBonus = api.rules.getCombatBonuses(player, target)
		assert_equal(0, damageBonus)
		assert_equal(0, lifeLeechBonus)

		api.config.talisman.damageActivationChance = 0 / 0
		api.config.talisman.lifeLeechActivationChance = math.huge
		damageBonus, lifeLeechBonus = api.rules.getCombatBonuses(player, target)
		assert_equal(0, damageBonus)
		assert_equal(0, lifeLeechBonus)
	end)
	api.config.talisman.damageActivationChance = originalDamageChance
	api.config.talisman.lifeLeechActivationChance = originalLifeLeechChance
	player.equippedAmmo = originalAmmo
	assert_true(succeeded, failure)
end)

test("life leech is delegated to the native real-damage path", function()
	local originalDamageBonus = api.getDamageBonus
	local originalLifeLeechBonus = api.getLifeLeechBonus
	api.getDamageBonus = function()
		return 10
	end
	api.getLifeLeechBonus = function()
		return 10
	end

	local attacker = {
		isPlayer = function()
			return true
		end,
	}
	local target = {
		isMonster = function()
			return true
		end,
	}
	local damage = {
		primary = { value = -101 },
		secondary = { value = -1 },
		lifeLeech = 250,
	}

	local succeeded, failure = pcall(function()
		registeredCallbacks.TaskboardCreatureOnCombat.creatureOnCombat(attacker, target, damage)
		assert_equal(-111, damage.primary.value)
		assert_equal(-1, damage.secondary.value)
		assert_equal(1250, damage.lifeLeech)
	end)
	api.getDamageBonus = originalDamageBonus
	api.getLifeLeechBonus = originalLifeLeechBonus
	assert_true(succeeded, failure)
end)

test("weekly reward multiplier follows completion thresholds", function()
	local state = { weekly = { points = 100, killsCompleted = 0, itemsCompleted = 0 } }
	local expectations = {
		{ completed = 3, points = 100 },
		{ completed = 4, points = 200 },
		{ completed = 8, points = 300 },
		{ completed = 12, points = 500 },
		{ completed = 16, points = 800 },
	}
	for _, expectation in ipairs(expectations) do
		state.weekly.killsCompleted = expectation.completed
		assert_equal(expectation.points, api.rules.getWeeklyRewardPoints(state))
	end
end)

test("weekly finalization awards the multiplied task points", function()
	local awarded = 0
	local rewardPlayer = {
		addTaskHuntingPoints = function(_, amount)
			awarded = awarded + amount
		end,
	}
	local state = {
		general = { soulseals = 2 },
		weekly = { points = 125, soulseals = 3, killsCompleted = 5, itemsCompleted = 3 },
	}
	api.rules.finalizeWeekly(rewardPlayer, state)
	assert_equal(375, awarded)
	assert_equal(5, state.general.soulseals)
end)

test("weekly state derives rewards from normalized assignments", function()
	local weeklyStorage = {
		["root/task-board/weekly/difficulty"] = api.difficulty.beginner,
		["root/task-board/weekly/selection-pending"] = false,
		["root/task-board/weekly/kills-completed"] = 200,
		["root/task-board/weekly/items-completed"] = 200,
		["root/task-board/weekly/points"] = 0xFFFFFFFF,
		["root/task-board/weekly/soulseals"] = 0xFFFFFFFF,
		["root/task-board/weekly/any-creature/required"] = 10,
		["root/task-board/weekly/any-creature/current"] = 20,
		["root/task-board/weekly/any-creature/completed"] = false,
		["root/task-board/weekly/kill-count"] = 3,
		["root/task-board/weekly/kill-0/race-id"] = 100,
		["root/task-board/weekly/kill-0/required"] = 5,
		["root/task-board/weekly/kill-0/current"] = 5,
		["root/task-board/weekly/kill-0/state"] = api.taskState.selected,
		["root/task-board/weekly/kill-1/race-id"] = 65000,
		["root/task-board/weekly/kill-1/required"] = 5,
		["root/task-board/weekly/kill-1/current"] = 5,
		["root/task-board/weekly/kill-1/state"] = api.taskState.completed,
		["root/task-board/weekly/kill-2/race-id"] = 100,
		["root/task-board/weekly/kill-2/required"] = 5,
		["root/task-board/weekly/kill-2/current"] = 5,
		["root/task-board/weekly/kill-2/state"] = api.taskState.completed,
		["root/task-board/weekly/item-count"] = 2,
		["root/task-board/weekly/item-0/item-id"] = 3031,
		["root/task-board/weekly/item-0/required"] = 5,
		["root/task-board/weekly/item-0/current"] = 2,
		["root/task-board/weekly/item-0/completed"] = true,
		["root/task-board/weekly/item-1/item-id"] = 65000,
		["root/task-board/weekly/item-1/required"] = 5,
		["root/task-board/weekly/item-1/current"] = 5,
		["root/task-board/weekly/item-1/completed"] = true,
	}
	local weeklyPlayer = {
		getLevel = function()
			return 50
		end,
		kv = function()
			return makeScope(weeklyStorage, "root")
		end,
	}

	local state = api.state.load(weeklyPlayer)
	assert_equal(true, state.weekly.anyCreature.completed)
	assert_equal(10, state.weekly.anyCreature.current)
	assert_equal(1, #state.weekly.kills)
	assert_equal(true, state.weekly.kills[1].completed)
	assert_equal(1, #state.weekly.items)
	assert_equal(3031, state.weekly.items[1].itemId)
	assert_equal(true, state.weekly.items[1].completed)
	assert_equal(5, state.weekly.items[1].current)
	assert_equal(2, state.weekly.killsCompleted)
	assert_equal(1, state.weekly.itemsCompleted)
	assert_equal(125, state.weekly.points)
	assert_equal(3, state.weekly.soulseals)
end)

test("weekly wire uses the exact soulseals tail version gate", function()
	local originalClient = player.client
	local succeeded, failure = pcall(function()
		local state = api.state.ensure(player)
		api.rules.chooseWeeklyDifficulty(player, state, 0)
		api.state.save(player, state)
		sentMessages = {}
		api.wire.sendWeekly(player, state)
		local packetWithTail = sentMessages[1]
		local withTailCount = #packetWithTail.events
		player.client = { version = 1520 }
		sentMessages = {}
		api.wire.sendWeekly(player, state)
		assert_equal(withTailCount - 1, #sentMessages[1].events)
		player.client = { version = 1520, versionString = "15.20.99c34c" }
		sentMessages = {}
		api.wire.sendWeekly(player, state)
		assert_equal(withTailCount - 1, #sentMessages[1].events)
		player.client = { version = 1520, versionString = "15.20.f23bc3" }
		sentMessages = {}
		api.wire.sendWeekly(player, state)
		assert_equal(withTailCount, #sentMessages[1].events)
		player.client = { version = 1521, versionString = "15.21.0" }
		sentMessages = {}
		api.wire.sendWeekly(player, state)
		assert_equal(withTailCount, #sentMessages[1].events)
		player.client = { version = 1519 }
		sentMessages = {}
		api.wire.sendWeekly(player, state)
		assert_equal(withTailCount - 1, #sentMessages[1].events)
	end)
	player.client = originalClient
	assert_true(succeeded, failure)
end)

test("resource balances use u32 for bounty points and u64 for task points", function()
	sentMessages = {}
	local state = api.state.ensure(player)
	api.wire.sendBalances(player, state)
	assert_equal("u32", sentMessages[1].events[3].operation)
	assert_equal("u64", sentMessages[2].events[3].operation)
	assert_equal("u32", sentMessages[3].events[3].operation)
end)

test("task board balances stay off unsupported client profiles", function()
	local originalClient = player.client
	local succeeded, failure = pcall(function()
		player.client = { version = 1100 }
		sentMessages = {}
		api.wire.sendBalances(player, api.state.load(player))
		assert_equal(0, #sentMessages)
	end)
	player.client = originalClient
	assert_true(succeeded, failure)
end)

test("god helpers adjust and persist task board test state", function()
	local originalStorage = storage
	local originalTaskPoints = player.taskPoints
	local originalThirdSlot = player.thirdSlotUnlocked
	local succeeded, failure = pcall(function()
		storage = {}
		player.taskPoints = 500
		player.thirdSlotUnlocked = false

		local changed, value = api.admin.adjustBountyPoints(player, 25)
		assert_true(changed)
		assert_equal(25, value)
		assert_equal(25, api.state.load(player).general.bountyPoints)

		changed, value = api.admin.adjustBountyPoints(player, -26)
		assert_true(not changed)
		assert_equal(25, value)

		changed, value = api.admin.adjustSoulseals(player, 7)
		assert_true(changed)
		assert_equal(7, value)
		assert_equal(7, api.state.load(player).general.soulseals)

		changed, value = api.admin.adjustTaskPoints(player, 100)
		assert_true(changed)
		assert_equal(600, value)
		changed, value = api.admin.adjustTaskPoints(player, -50)
		assert_true(changed)
		assert_equal(550, value)

		changed, value = api.admin.setThirdSlot(player, true)
		assert_true(changed)
		assert_true(value)
		assert_true(api.state.load(player).general.thirdSlotUnlocked)

		changed, value = api.admin.setThirdSlot(player, false)
		assert_true(changed)
		assert_true(not value)
		assert_true(not api.state.load(player).general.thirdSlotUnlocked)

		local invalidChanged, invalidValue, reason = api.admin.adjustBountyPoints(player, 1.5)
		assert_true(not invalidChanged)
		assert_equal(nil, invalidValue)
		assert_equal("invalid amount", reason)

		invalidChanged, invalidValue, reason = api.admin.adjustBountyPoints(player, 9007199254740992)
		assert_true(not invalidChanged)
		assert_equal(nil, invalidValue)
		assert_equal("invalid amount", reason)
	end)
	storage = originalStorage
	player.taskPoints = originalTaskPoints
	player.thirdSlotUnlocked = originalThirdSlot
	assert_true(succeeded, failure)
end)

test("god helper prepares weekly delivery items without completing tasks", function()
	local originalEnsure = api.state.ensure
	local originalSendWeekly = api.wire.sendWeekly
	local originalItems = player.items
	local originalStashItems = player.stashItems
	local weeklyCalls = 0
	local state = {
		general = { thirdSlotUnlocked = false },
		weekly = {
			selectionPending = false,
			itemsCompleted = 1,
			items = {
				{ itemId = 3031, required = 10, completed = false },
				{ itemId = 3582, required = 5, completed = false },
				{ itemId = 3577, required = 20, completed = true },
			},
		},
	}

	api.state.ensure = function()
		return state
	end
	api.wire.sendWeekly = function()
		weeklyCalls = weeklyCalls + 1
	end
	player.items = { [3031] = 3, [3582] = 5 }
	player.stashItems = { [3031] = 2 }

	local succeeded, failure = pcall(function()
		local prepared, summary = api.admin.prepareWeeklyDeliveries(player)
		assert_true(prepared)
		assert_equal(2, summary.pendingTasks)
		assert_equal(1, summary.preparedTasks)
		assert_equal(1, summary.alreadyReadyTasks)
		assert_equal(5, summary.addedItems)
		assert_equal(7, player.stashItems[3031])
		assert_equal(1, state.weekly.itemsCompleted)
		assert_true(not state.weekly.items[1].completed)
		assert_true(not state.weekly.items[2].completed)
		assert_equal(1, weeklyCalls)
	end)

	api.state.ensure = originalEnsure
	api.wire.sendWeekly = originalSendWeekly
	player.items = originalItems
	player.stashItems = originalStashItems
	assert_true(succeeded, failure)
end)

test("god helper recreates missing weekly delivery assignments with current ids", function()
	local originalEnsure = api.state.ensure
	local originalSave = api.state.save
	local originalSendWeekly = api.wire.sendWeekly
	local originalItems = player.items
	local originalStashItems = player.stashItems
	local originalRandom = math.random
	local saveCalls = 0
	local weeklyCalls = 0
	local state = {
		general = { thirdSlotUnlocked = false },
		weekly = {
			selectionPending = false,
			itemsCompleted = 0,
			items = {},
		},
	}

	api.state.ensure = function()
		return state
	end
	api.state.save = function(_, stateToSave)
		saveCalls = saveCalls + 1
		assert_equal(api.config.weekly.itemSlots, #stateToSave.weekly.items)
		return true
	end
	api.wire.sendWeekly = function()
		weeklyCalls = weeklyCalls + 1
	end
	math.random = function(minimum)
		return minimum
	end
	player.items = {}
	player.stashItems = {}

	local succeeded, failure = pcall(function()
		local prepared, summary = api.admin.prepareWeeklyDeliveries(player)
		assert_true(prepared)
		assert_equal(api.config.weekly.itemSlots, summary.pendingTasks)
		assert_equal(api.config.weekly.itemSlots, summary.preparedTasks)
		assert_equal(0, summary.alreadyReadyTasks)
		assert_equal(1, saveCalls)
		assert_equal(1, weeklyCalls)
		for index = 1, api.config.weekly.itemSlots do
			local configured = api.config.weeklyItems[index]
			local generated = state.weekly.items[index]
			assert_equal(configured.id, generated.itemId)
			assert_equal(configured.min, generated.required)
			assert_equal(configured.min, player.stashItems[configured.id])
		end
	end)

	api.state.ensure = originalEnsure
	api.state.save = originalSave
	api.wire.sendWeekly = originalSendWeekly
	math.random = originalRandom
	player.items = originalItems
	player.stashItems = originalStashItems
	assert_true(succeeded, failure)
end)

test("god admin operations preserve state when persistence fails", function()
	local originalEnsure = api.state.ensure
	local originalSave = api.state.save
	local originalSendBalances = api.wire.sendBalances
	local originalTaskPoints = player.taskPoints
	local originalThirdSlot = player.thirdSlotUnlocked
	local state = { general = { thirdSlotUnlocked = false } }
	local saveCalls = 0
	local balanceCalls = 0

	api.state.ensure = function()
		return state
	end
	api.state.save = function()
		saveCalls = saveCalls + 1
		return false
	end
	api.wire.sendBalances = function()
		balanceCalls = balanceCalls + 1
	end

	local succeeded, failure = pcall(function()
		player.thirdSlotUnlocked = false
		local changed, value, reason = api.admin.setThirdSlot(player, true)
		assert_true(not changed)
		assert_equal(false, value)
		assert_equal("state could not be saved", reason)
		assert_equal(false, state.general.thirdSlotUnlocked)
		assert_equal(false, player.thirdSlotUnlocked)
		assert_equal(1, saveCalls)

		player.taskPoints = 500
		saveCalls = 0
		changed, value = api.admin.adjustTaskPoints(player, 100)
		assert_true(changed)
		assert_equal(600, value)
		assert_equal(0, saveCalls)
		assert_equal(1, balanceCalls)
	end)

	api.state.ensure = originalEnsure
	api.state.save = originalSave
	api.wire.sendBalances = originalSendBalances
	player.taskPoints = originalTaskPoints
	player.thirdSlotUnlocked = originalThirdSlot
	assert_true(succeeded, failure)
end)

print(string.format("\n%d passed, %d failed", passed, failed))
if #errors > 0 then
	print("\nFailed tests:")
	for _, entry in ipairs(errors) do
		print(string.format("  FAIL: %s\n        %s", entry.name, entry.err))
	end
	os.exit(1)
end
