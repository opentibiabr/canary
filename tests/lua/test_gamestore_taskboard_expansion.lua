-- Standalone Game Store contract tests for the Task Board expansion.
-- Run from the repository root with: lua tests/lua/test_gamestore_taskboard_expansion.lua

package.path = "data/libs/?.lua;" .. package.path

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

local function assertTrue(value, message)
	if not value then
		error(message or "expected true", 2)
	end
end

local function assertEqual(expected, actual, message)
	if expected ~= actual then
		error(message or string.format("expected %s, got %s", tostring(expected), tostring(actual)), 2)
	end
end

package.loaded["gamestore.senders"] = {}
GameStore = require("gamestore.constants")

local playerMethods = require("gamestore.player")
local purchases = require("gamestore.purchases")

test("weekly expansion offer uses the official product contract", function()
	local category = dofile("data/modules/scripts/gamestore/catalog/extras_usefull_things.lua")
	local offer
	for _, candidate in ipairs(category.offers) do
		if candidate.type == GameStore.OfferTypes.OFFER_TYPE_WEEKLY_TASK_EXPANSION then
			offer = candidate
			break
		end
	end

	assertTrue(offer ~= nil)
	assertEqual("Permanent Weekly Task Expansion", offer.name)
	assertEqual(750, offer.price)
	assertEqual(GameStore.SubActions.WEEKLY_TASK_EXPANSION, offer.id)
end)

test("weekly expansion availability follows the Task Board state", function()
	local unlocked = false
	local testPlayer = {}
	rawset(_G, "Taskboard", {
		expansion = {
			isUnlocked = function(player)
				assertEqual(testPlayer, player)
				return unlocked
			end,
		},
	})
	local offer = { type = GameStore.OfferTypes.OFFER_TYPE_WEEKLY_TASK_EXPANSION }

	local availability = playerMethods.canBuyOffer(testPlayer, offer)
	assertEqual(0, availability.disabled)
	assertEqual("", availability.disabledReason)

	unlocked = true
	availability = playerMethods.canBuyOffer(testPlayer, offer)
	assertEqual(1, availability.disabled)
	assertEqual("You already have the Permanent Weekly Task Expansion.", availability.disabledReason)
end)

test("weekly expansion purchase delegates to the Task Board module", function()
	local calls = 0
	local testPlayer = {}
	rawset(_G, "Taskboard", {
		expansion = {
			unlock = function(player)
				assertEqual(testPlayer, player)
				calls = calls + 1
				return true
			end,
		},
	})

	purchases.processWeeklyTaskExpansion(testPlayer)
	assertEqual(1, calls)
end)

test("weekly expansion offer is disabled when Task Board is unavailable", function()
	rawset(_G, "Taskboard", nil)
	local offer = { type = GameStore.OfferTypes.OFFER_TYPE_WEEKLY_TASK_EXPANSION }
	local availability = playerMethods.canBuyOffer({}, offer)
	assertEqual(1, availability.disabled)
	assertEqual("Task Board is unavailable.", availability.disabledReason)

	local ok, err = pcall(purchases.processWeeklyTaskExpansion, {})
	assertEqual(false, ok)
	assertTrue(type(err) == "table")
	assertEqual("Task Board is unavailable.", err.message)
end)

print(string.format("\n%d passed, %d failed", passed, failed))
if #errors > 0 then
	print("\nFailed tests:")
	for _, entry in ipairs(errors) do
		print(string.format("  FAIL: %s\n        %s", entry.name, entry.err))
	end
	os.exit(1)
end
