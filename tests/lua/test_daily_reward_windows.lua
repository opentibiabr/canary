-- Regression tests for daily reward claim windows and legacy counter migration.
-- Run from the repository root with: luajit tests/lua/test_daily_reward_windows.lua

local passed, failed, errors = 0, 0, {}

local function test(name, fn)
	local ok, err = pcall(fn)
	if ok then
		passed = passed + 1
	else
		failed = failed + 1
		errors[#errors + 1] = { name = name, err = err }
	end
end

local function assert_equal(expected, actual)
	if expected ~= actual then
		error(string.format("expected %s, got %s", tostring(expected), tostring(actual)), 2)
	end
end

local function makeScope(storage, prefix)
	return {
		get = function(_, key)
			return storage[prefix .. "/" .. key]
		end,
		set = function(_, key, value)
			storage[prefix .. "/" .. key] = value
			return true
		end,
		scoped = function(_, key)
			return makeScope(storage, prefix .. "/" .. key)
		end,
	}
end

local HOUR = 60 * 60
local DAY = 24 * HOUR
-- S0 is a Monday 18:00 save; +36h is the Wednesday 06:00 save.
local S0 = 1791828000 -- 2026-10-12 18:00 UTC; the fixture never consults the host timezone.
local COUNTER_KEY = "daily-reward-save-count"
local globalStorage, history, scheduledEvents = {}, {}, {}
local currentPlayer, now

-- Only engine boundaries are replaced: all reward calculations, settlement,
-- player storage/KV helpers and successful collection run the production Lua.
Player = setmetatable({}, {
	__call = function(_, id)
		if currentPlayer and currentPlayer:getId() == id then
			return currentPlayer
		end
	end,
})

function Player:getId()
	return 42
end

function Player:getGuid()
	return 101
end

function Player:getName()
	return "Daily Reward Test"
end

function Player:getStorageValue(key)
	return self.storage[key] or -1
end

function Player:setStorageValue(key, value)
	self.storage[key] = value
end

function Player:kv()
	return makeScope(self.values, "player")
end

function Player:getLastLoginSaved()
	return self.lastLogin
end

function Player:getClient()
	-- Collection-state bindings are checked below; no wire serialization is needed.
	return { version = 1100 }
end

function Player:sendTextMessage(kind, text)
	self.messages[#self.messages + 1] = { kind = kind, text = text }
end

function Player:setDailyReward(state)
	self.rewardState = state
end

function Player:getPremiumDays()
	return 0
end

function Player:getStamina()
	return 2400
end

function Player:getVocation()
	return {
		getSoulGainTicks = function()
			return 60
		end,
	}
end

function Player:getPosition()
	return {
		sendMagicEffect = function(_, effect)
			self.effects[#self.effects + 1] = effect
		end,
	}
end

function Player:addPreyCards(count)
	self.preyCards = self.preyCards + count
end

Condition = function()
	return {}
end
configKeys = { LOYALTY_ENABLED = 1, FREE_PREMIUM = 2, VIP_SYSTEM_ENABLED = 3 }
configManager = {
	getBoolean = function()
		return false
	end,
}
logger = { debug = function() end }
SERVER_NAME = "Daily Reward Test"
VOCATION = { BASE_ID = { SORCERER = 1, DRUID = 2, PALADIN = 3, KNIGHT = 4, MONK = 5 } }
MESSAGE_LOGIN = 17
DAILY_REWARD_COLLECTED = 1
DAILY_REWARD_NOTCOLLECTED = 0
CONST_ME_FIREWORK_YELLOW = 1

-- Freeze the clock and monthly grant so joker changes only reflect missed windows.
os.time = function()
	return now
end
os.date = function(format)
	assert_equal("%m", format)
	return "10"
end

function addEvent(callback, delay, ...)
	scheduledEvents[#scheduledEvents + 1] = { callback = callback, delay = delay, arguments = { ... } }
	return #scheduledEvents -- Never run timers or touch a server scheduler.
end

db = {
	escapeString = function(value)
		return "'" .. value:gsub("'", "''") .. "'"
	end,
	storeQuery = function(sql)
		local key
		if sql == "SELECT `value` FROM `global_storage` WHERE `key` = 'daily-reward-save-count'" then
			key = COUNTER_KEY
		elseif sql == "SELECT `value` FROM `global_storage` WHERE `key` = " .. DailyReward.storages.lastServerSave then
			key = DailyReward.storages.lastServerSave
		else
			error("unexpected database read: " .. sql)
		end
		return globalStorage[key] ~= nil and { value = globalStorage[key] } or false
	end,
	query = function(sql)
		assert(sql:match("^INSERT INTO `daily_reward_history`"), "unexpected database write: " .. sql)
		history[#history + 1] = sql
		return true -- History is recorded in memory, never sent to a database.
	end,
}
Result = {
	getNumber = function(result, column)
		assert_equal("value", column)
		assert(not result.freed)
		return result.value
	end,
	free = function(result)
		assert(not result.freed)
		result.freed = true
	end,
}

dofile("data/libs/functions/player.lua")
dofile("data/libs/systems/daily_reward.lua")
dofile("data/modules/scripts/daily_reward/daily_reward.lua")

local function setWindow(timestamp, count)
	globalStorage[DailyReward.storages.lastServerSave] = timestamp
	globalStorage[COUNTER_KEY] = count
	now = timestamp + 60
end

local function fixture(options)
	options = options or {}
	globalStorage, history, scheduledEvents = {}, {}, {}
	DailyRewardBonus.Stamina, DailyRewardBonus.Soul = {}, {}
	setWindow(options.saveTime or S0 + 36 * HOUR, options.saveCount or 2)
	local player = setmetatable({
		storage = {},
		values = {},
		messages = {},
		effects = {},
		preyCards = 0,
		lastLogin = options.lastLogin or S0 - DAY,
	}, { __index = Player })
	currentPlayer = player
	player:setJokerTokens(options.jokers or 3)
	player:setStreakLevel(options.streak or 7)
	player:setDayStreak(2) -- The next real reward is a prey reroll, requiring no item fixtures.
	player:setNextRewardTime(options.nextRewardTime or S0 + 25 * HOUR)
	player:setDailyRewardClaimedServerSave(options.claimed)
	player:setStorageValue(DailyReward.storages.avoidDouble, S0)
	player:setStorageValue(DailyReward.storages.avoidDoubleJoker, 10)
	return player
end

local function missed(player)
	return DailyReward.getMissedDays(player, GetDailyRewardLastServerSave())
end

local function login(player)
	DailyReward.init(player:getId())
end

test("legacy 25-hour claim deadline cannot hide a completed server-save window", function()
	local player = fixture()
	assert_equal(nil, player:getDailyRewardClaimedServerSave())
	assert_equal(1, missed(player))
	login(player)
	assert_equal(2, player:getJokerTokens())
	assert_equal(7, player:getStreakLevel())
	assert_equal(1, player:kv():scoped("daily-reward"):get("claimed-server-save"))
	assert_equal(S0 + 36 * HOUR, player:getNextRewardTime())
	assert_equal("You lost 1 joker tokens to prevent losing your streak.", player.messages[1].text)
	assert_equal(DAILY_REWARD_NOTCOLLECTED, player.rewardState)
	assert_equal(false, DailyReward.isRewardTaken(player:getId()))
end)

test("legacy settlement is not charged again on repeated login", function()
	local player = fixture()
	login(player)
	login(player)
	assert_equal(0, missed(player))
	assert_equal(2, player:getJokerTokens())
	assert_equal(7, player:getStreakLevel())
	assert_equal(1, #player.messages)
end)

test("settled legacy player loses one more joker after the next unclaimed window", function()
	local player = fixture()
	login(player)
	setWindow(S0 + 60 * HOUR, 3)
	assert_equal(1, missed(player))
	login(player)
	assert_equal(1, player:getJokerTokens())
	assert_equal(7, player:getStreakLevel())
	assert_equal(2, player:getDailyRewardClaimedServerSave())
	assert_equal(2, #player.messages)
end)

test("real collection after migration records the counter and resumes tracked windows", function()
	local player = fixture()
	login(player)
	assert_equal(
		true,
		player:selectDailyReward({
			getByte = function()
				return 0 -- Shrine collection.
			end,
		})
	)
	assert_equal(1, player.preyCards)
	assert_equal(1, #history)
	assert_equal(1, #player.effects)
	assert_equal(3, player:getDayStreak())
	assert_equal(8, player:getStreakLevel())
	assert_equal(2, player:getDailyRewardClaimedServerSave())
	assert_equal(S0 + 60 * HOUR, player:getNextRewardTime())
	assert_equal(DAILY_REWARD_COLLECTED, player.rewardState)
	assert_equal(true, DailyReward.isRewardTaken(player:getId()))
	-- A delayed next save is still only the immediately available claim window.
	setWindow(S0 + 109 * HOUR, 3)
	assert_equal(0, missed(player))
	login(player)
	assert_equal(2, player:getJokerTokens())
	assert_equal(DAILY_REWARD_NOTCOLLECTED, player.rewardState)
	setWindow(S0 + 110 * HOUR, 4)
	assert_equal(1, missed(player))
	login(player)
	assert_equal(1, player:getJokerTokens())
	assert_equal(8, player:getStreakLevel())
end)

test("two quick saves count a missed legacy window even before its old deadline", function()
	local player = fixture({ saveTime = S0 + 10 * HOUR })
	assert_equal(1, missed(player))
	login(player)
	assert_equal(2, player:getJokerTokens())
	assert_equal(7, player:getStreakLevel())
	assert_equal(1, player:getDailyRewardClaimedServerSave())
end)

for _, count in ipairs({ 0, 1 }) do
	test("legacy counter " .. count .. " alone does not penalize a recent claim", function()
		local player = fixture({ saveTime = S0 + 24 * HOUR, saveCount = count })
		assert_equal(0, missed(player))
		login(player)
		assert_equal(3, player:getJokerTokens())
		assert_equal(7, player:getStreakLevel())
		assert_equal(nil, player:getDailyRewardClaimedServerSave())
		assert_equal(0, #player.messages)
	end)
end

test("elapsed-time fallback still settles gaps older than the counter", function()
	local player = fixture({ saveTime = S0 + 97 * HOUR, saveCount = 1 })
	assert_equal(3, missed(player))
	login(player)
	assert_equal(0, player:getJokerTokens())
	assert_equal(7, player:getStreakLevel())
	assert_equal(0, player:getDailyRewardClaimedServerSave())
end)

test("a missing global counter retains the elapsed-time legacy fallback", function()
	local player = fixture({ saveTime = S0 + 73 * HOUR })
	globalStorage[COUNTER_KEY] = nil
	assert_equal(0, GetDailyRewardServerSaveCount())
	assert_equal(2, missed(player))
	login(player)
	assert_equal(1, player:getJokerTokens())
	assert_equal(7, player:getStreakLevel())
	assert_equal(-1, player:getDailyRewardClaimedServerSave())
end)

test("new character keeps its starting streak until the first missed window", function()
	local player = fixture({ nextRewardTime = 0, saveCount = 10, lastLogin = 0 })
	login(player)
	assert_equal(3, player:getJokerTokens())
	assert_equal(7, player:getStreakLevel())
	assert_equal(9, player:getDailyRewardClaimedServerSave())
	assert_equal(S0 + 36 * HOUR, player:getNextRewardTime())
	assert_equal(0, missed(player))
	assert_equal(0, #player.messages)
	setWindow(S0 + 60 * HOUR, 11)
	assert_equal(1, missed(player))
	login(player)
	assert_equal(2, player:getJokerTokens())
	assert_equal(7, player:getStreakLevel())
	assert_equal(10, player:getDailyRewardClaimedServerSave())
end)

test("new character without jokers loses its starting streak only after a miss", function()
	local player = fixture({ nextRewardTime = 0, jokers = 0 })
	login(player)
	assert_equal(7, player:getStreakLevel())
	assert_equal(0, player:getJokerTokens())
	setWindow(S0 + 60 * HOUR, 3)
	login(player)
	assert_equal(0, player:getStreakLevel())
	assert_equal(0, player:getJokerTokens())
	assert_equal("You just lost your daily reward streak.", player.messages[1].text)
end)

for _, claimed in ipairs({ 10, 9 }) do
	test("tracked marker " .. claimed .. " has no missed window at counter 10", function()
		local player = fixture({ saveCount = 10, claimed = claimed, nextRewardTime = S0 - 10 * DAY })
		assert_equal(0, missed(player))
		login(player)
		assert_equal(3, player:getJokerTokens())
		assert_equal(7, player:getStreakLevel())
		assert_equal(claimed, player:getDailyRewardClaimedServerSave())
		assert_equal(0, #player.messages)
	end)
end

test("tracked multiple missed windows consume exactly their joker count", function()
	local player = fixture({ saveCount = 10, claimed = 6 })
	assert_equal(3, missed(player))
	login(player)
	assert_equal(0, player:getJokerTokens())
	assert_equal(7, player:getStreakLevel())
	assert_equal(9, player:getDailyRewardClaimedServerSave())
	assert_equal(0, missed(player))
end)

test("insufficient jokers reset a tracked streak once and settle the debt", function()
	local player = fixture({ saveCount = 10, claimed = 5 })
	assert_equal(4, missed(player))
	login(player)
	assert_equal(0, player:getJokerTokens())
	assert_equal(0, player:getStreakLevel())
	assert_equal(9, player:getDailyRewardClaimedServerSave())
	assert_equal(0, missed(player))
	login(player)
	assert_equal(1, #player.messages)
end)

test("zero is a tracked counter marker, not a missing legacy marker", function()
	local player = fixture({ claimed = 0, nextRewardTime = S0 - 10 * DAY })
	assert_equal(0, player:getDailyRewardClaimedServerSave())
	assert_equal(1, missed(player))
	login(player)
	assert_equal(2, player:getJokerTokens())
	assert_equal(7, player:getStreakLevel())
end)

test("claim at counter zero is retained and allows the immediately next window", function()
	local player = fixture({ saveCount = 0 })
	assert_equal(true, DailyReward.pickedReward(player:getId()))
	assert_equal(0, player:getDailyRewardClaimedServerSave())
	assert_equal(0, missed(player))
	setWindow(S0 + 60 * HOUR, 1)
	assert_equal(0, missed(player))
	setWindow(S0 + 84 * HOUR, 2)
	assert_equal(1, missed(player))
end)

local roundingCases = {
	{ name = "under half a day", elapsed = 12 * HOUR - 1, count = 1, expected = 0 },
	{ name = "exactly half a day", elapsed = 12 * HOUR, count = 1, expected = 1 },
	{ name = "one-day save a minute early", elapsed = DAY - 60, count = 2, expected = 1 },
	{ name = "one-day save a minute late", elapsed = DAY + 60, count = 2, expected = 1 },
	{ name = "two-day save a minute early", elapsed = 2 * DAY - 60, count = 2, expected = 2 },
	{ name = "two-day save a minute late", elapsed = 2 * DAY + 60, count = 2, expected = 2 },
}
for _, case in ipairs(roundingCases) do
	test("legacy rounding: " .. case.name, function()
		local player = fixture({ saveTime = S0 + 25 * HOUR + case.elapsed, saveCount = case.count })
		assert_equal(case.expected, missed(player))
		login(player)
		assert_equal(3 - case.expected, player:getJokerTokens())
		assert_equal(7, player:getStreakLevel())
	end)
end

print(string.format("\n%d passed, %d failed", passed, failed))
if #errors > 0 then
	for _, entry in ipairs(errors) do
		print(string.format("  FAIL: %s\n        %s", entry.name, entry.err))
	end
	os.exit(1)
end
