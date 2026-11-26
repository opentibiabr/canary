-- Run from the repository root: lua tests/lua/test_bank_command_amounts.lua
-- Optional first argument: a baseline copy of the bank talk-action script.
-- The command handlers, string helpers and money validator are production Lua;
-- Bank calls and player inventory/balance are controlled at the binding boundary.

dofile("data/libs/functions/string.lua")
Player = {}
configKeys = {}
configManager = {
	getNumber = function()
		return 0
	end,
	getBoolean = function()
		return false
	end,
}
dofile("data/libs/functions/functions.lua")

MESSAGE_LOOK = 1
local actions = {}
function TalkAction(words)
	local action = {}
	function action:separator() end
	function action:groupType() end
	function action:register()
		actions[words] = self
	end
	return action
end

local calls = {}
local succeeds = true
local player = { money = 1234, messages = {} }
function player:sendTextMessage(_, message)
	table.insert(self.messages, message)
end
function player:getMoney()
	return self.money
end
function player:transferMoneyTo(name, amount)
	table.insert(calls, { operation = "transfer", name = name, amount = amount })
	return succeeds
end

Bank = {}
for _, operation in ipairs({ "deposit", "withdraw" }) do
	Bank[operation] = function(_, amount)
		table.insert(calls, { operation = operation, amount = amount })
		return succeeds
	end
end
function Bank.balance()
	return 500
end
Game = {}
function Game.getNormalizedPlayerName(name)
	return name == "Receiver" and "Receiver" or nil
end

dofile(arg and arg[1] or "data/scripts/talkactions/player/bank.lua")

local passed, failed = 0, 0
local function test(name, callback)
	calls = {}
	player.messages = {}
	succeeds = true
	local ok, reason = pcall(callback)
	if ok then
		passed = passed + 1
	else
		failed = failed + 1
		io.stderr:write(name .. ": " .. tostring(reason) .. "\n")
	end
end

local function invoke(command, amount)
	local parameter = command == "transfer" and ("Receiver, " .. amount) or amount
	assert(actions["!" .. command].onSay(player, "!" .. command, parameter) == true)
end

for _, command in ipairs({ "deposit", "withdraw", "transfer" }) do
	for _, amount in ipairs({ "", "invalid", "0", "-1", "1.5", "-1.5", "4294967296", "1e309", "-1e309" }) do
		test(command .. " rejects " .. amount, function()
			invoke(command, amount)
			assert(#calls == 0, "invalid amount reached a monetary operation")
			assert(player.messages[1] == "Invalid amount.")
		end)
	end
	for _, amount in ipairs({ "1", "100", "4294967295" }) do
		test(command .. " accepts " .. amount, function()
			invoke(command, amount)
			assert(#calls == 1 and calls[1].operation == command)
			assert(calls[1].amount == tonumber(amount))
			if command == "transfer" then
				assert(calls[1].name == "Receiver")
			end
			assert(not player.messages[1]:find("Invalid", 1, true))
		end)
	end
	test(command .. " retains insufficient funds handling", function()
		succeeds = false
		invoke(command, "10")
		assert(#calls == 1)
		assert(player.messages[1] == "You don't have enough money.")
	end)
end

test("deposit all retains inventory amount", function()
	invoke("deposit", "all")
	assert(#calls == 1 and calls[1].operation == "deposit")
	assert(calls[1].amount == player.money)
end)

test("transfer retains recipient validation", function()
	assert(actions["!transfer"].onSay(player, "!transfer", "Unknown, 10"))
	assert(#calls == 0)
	assert(player.messages[1] == "A player with name Unknown does not exist.")
end)

print(string.format("Bank command amounts: %d passed, %d failed", passed, failed))
if failed > 0 then
	os.exit(1)
end
