-- Test suite for MsgContains word-boundary matching (data/npclib/npc.lua)
-- Run: luajit tests/lua/test_npc_messaging.lua

-- Minimal test harness
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

local function assert_true(val, msg)
	if not val then
		error(msg or "expected true, got " .. tostring(val), 2)
	end
end

local function assert_false(val, msg)
	if val then
		error(msg or "expected false, got " .. tostring(val), 2)
	end
end

-- Stub globals required by npc.lua
logger = { error = function() end }
Npc = setmetatable({}, {
	__call = function()
		return nil
	end,
})
TALKTYPE_PRIVATE_NP = 0
addEvent = function() end
TAG_PLAYERNAME = 1
TAG_TIME = 2
TAG_BLESSCOST = 3
TAG_PVPBLESSCOST = 4
Blessings = {
	getBlessingCost = function()
		return 0
	end,
	getPvpBlessingCost = function()
		return 0
	end,
}
function getFormattedWorldTime()
	return ""
end

-- Load MsgContains from the real source
dofile("data/npclib/npc.lua")

---------------------------------------------------------------------------
-- MsgContains tests
---------------------------------------------------------------------------

-- Exact match (first code path: direct equality)
test("MsgContains: exact match", function()
	assert_true(MsgContains("yes", "yes"))
	assert_true(MsgContains("YES", "yes"))
end)

-- Keyword at word boundaries
test("MsgContains: keyword at start of message", function()
	assert_true(MsgContains("yes please", "yes"))
end)

test("MsgContains: keyword at end of message", function()
	assert_true(MsgContains("say yes", "yes"))
end)

test("MsgContains: keyword absent", function()
	assert_false(MsgContains("hello world", "yes"))
end)

-- Word boundary rejection (prefix, suffix, embedded)
test("MsgContains: rejects keyword embedded in word", function()
	assert_false(MsgContains("eyes open", "yes"))
	assert_false(MsgContains("yesterday was fun", "yes"))
	assert_false(MsgContains("she says hello", "say"))
end)

-- THE BUG: standalone "to" with "to" also embedded in player name
test("MsgContains: standalone 'to' found despite being embedded in 'coitox'", function()
	assert_true(MsgContains("transfer 100 to coitox", "to"))
end)

test("MsgContains: 'to' only embedded in 'coitox' is rejected", function()
	assert_false(MsgContains("give coitox gold", "to"))
end)

-- Loop iteration: first occurrence embedded, second standalone
test("MsgContains: finds standalone occurrence after embedded one", function()
	assert_true(MsgContains("bypass yes please", "yes"))
end)

-- Non-alpha delimiter counts as word boundary
test("MsgContains: punctuation acts as word boundary", function()
	assert_true(MsgContains("say yes, please", "yes"))
end)

-- Multi-word keyword
test("MsgContains: multi-word keyword", function()
	assert_true(MsgContains("I want to deposit all", "deposit all"))
end)

test("MsgContains: keyword with pattern metacharacters", function()
	assert_true(MsgContains("price is 5.00 gold", "5.00"))
	assert_false(MsgContains("price is 5x00 gold", "5.00"))
end)

---------------------------------------------------------------------------
-- NPC conversation lifecycle
---------------------------------------------------------------------------
dofile("data/npclib/npc_system/keyword_handler.lua")
dofile("data/npclib/npc_system/npc_handler.lua")
dofile("data/modules/scripts/npc/npc_dialog.lua")

Player = function(player)
	return player
end
NetworkMessage = function()
	local message = { values = {} }
	function message:addByte(value)
		table.insert(self.values, value)
	end
	message.addU32 = message.addByte
	message.addString = message.addByte
	function message:sendToPlayer(player)
		table.insert(player.packets, self.values)
	end
	return message
end

for _, case in ipairs({
	{ name = "topic reset retains conversation", method = "resetNpc", open = true },
	{ name = "interaction removal closes conversation", method = "removeInteraction", open = false },
}) do
	test("NpcHandler: " .. case.name, function()
		local player = {
			packets = {},
			getId = function()
				return 1
			end,
		}
		local npc = {
			interacting = true,
			getId = function()
				return 100
			end,
			getName = function()
				return "Guide"
			end,
			getSpeechBubble = function()
				return 0
			end,
			isMerchant = function()
				return false
			end,
		}
		function npc:isInteractingWithPlayer()
			return self.interacting
		end
		function npc:removePlayerInteraction()
			self.interacting = false
		end
		Npc = function(id)
			return id == npc:getId() and npc or nil
		end
		local handler = NpcHandler:new(KeywordHandler:new())
		NpcDialog.clear(player)
		NpcDialog.add(player, npc:getId())
		NpcDialog.sendWindow(player)
		assert_true(player.packets[1][1] == 0x1C and player.packets[1][2] == 0)

		handler[case.method](handler, npc, player)
		assert_true(handler:checkInteraction(npc, player) == case.open)
		if case.open then
			assert_true(#player.packets == 1, "topic reset must not send a conversation close")
		else
			assert_true(#player.packets == 2, "ending interaction must notify the client")
			assert_true(player.packets[2][1] == 0x1C and player.packets[2][2] == 1)
		end
	end)
end

---------------------------------------------------------------------------
-- Results
---------------------------------------------------------------------------
print(string.format("\n%d passed, %d failed", passed, failed))
if #errors > 0 then
	print("\nFailed tests:")
	for _, e in ipairs(errors) do
		print(string.format("  FAIL: %s\n        %s", e.name, e.err))
	end
	os.exit(1)
end
