-- Run: lua tests/lua/test_wyrdin_keywords.lua [source-root]
-- Executes the NPC dialogue callbacks with controlled engine services and storage.
local sourceRoot = arg[1] or "."
local passed, failed = 0, 0

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

local mission = {
	[1] = "mission",
	KingTibianus = "king",
	Leeland = "leeland",
	Angus = "angus",
	Wyrdin = "wyrdin",
	Telas = "telas",
	Humgolf = "humgolf",
	LeelandKeyword = "leeland-word",
	AngusKeyword = "angus-word",
	WyrdinKeyword = "wyrdin-word",
	TelasKeyword = "telas-word",
	HumgolfKeyword = "humgolf-word",
}
Storage = { Quest = { U8_54 = { TheNewFrontier = { Questline = "quest", Mission05 = mission } } } }
Npc = {}
dofile(sourceRoot .. "/data/npclib/npc.lua")

local handlers = {}
Game = {
	createNpcType = function()
		return { register = function() end }
	end,
}
KeywordHandler = {
	new = function()
		return {}
	end,
}
FocusModule = {
	new = function()
		return {}
	end,
}
NpcHandler = {
	new = function()
		local handler = { topic = 0, interacting = true }
		function handler:checkInteraction()
			return self.interacting
		end
		function handler:getTopic()
			return self.topic
		end
		function handler:setTopic(_, topic)
			self.topic = topic
		end
		function handler:say() end
		function handler:setMessage() end
		function handler:setCallback(_, callback)
			self.callback = callback
		end
		function handler:addModule() end
		table.insert(handlers, handler)
		return handler
	end,
}
Player = function(player)
	return player
end

local function player(values)
	local result = { values = values }
	function result:getId()
		return 1
	end
	function result:getStorageValue(key)
		return self.values[key] or -1
	end
	function result:setStorageValue(key, value)
		self.values[key] = value
	end
	return result
end

dofile(sourceRoot .. "/data-otservbr-global/npc/ongulf.lua")
dofile(sourceRoot .. "/data-otservbr-global/npc/wyrdin.lua")
local ongulf, wyrdin = handlers[1], handlers[2]
-- Select the upper bound so an unsupported fourth outcome cannot hide in randomness.
math.random = function(_, upper)
	return upper
end

local function say(handler, character, message)
	handler.callback({}, character, 0, message)
end

local words = { "plea", "bluff", "flatter" }

test("new assignment always has a supported dialogue", function()
	local character = player({ quest = 13 })
	ongulf.topic = 0
	say(ongulf, character, "mission")
	equal(character.values.quest, 14)
	assert(words[character.values[mission.WyrdinKeyword]], "assigned an unsupported Wyrdin keyword")
	wyrdin.topic = 0
	say(wyrdin, character, "farmine")
	say(wyrdin, character, words[character.values[mission.WyrdinKeyword]])
	equal(character.values[mission.Wyrdin], 3)
end)

test("legacy fourth keyword can complete the existing farmine dialogue", function()
	local character = player({ quest = 14, wyrdin = 1, ["wyrdin-word"] = 4 })
	wyrdin.topic = 0
	say(wyrdin, character, "farmine")
	equal(wyrdin.topic, 2)
	assert(words[character.values[mission.WyrdinKeyword]], "legacy keyword was not repaired")
	say(wyrdin, character, words[character.values[mission.WyrdinKeyword]])
	equal(character.values[mission.Wyrdin], 3)
end)

for keyword, word in ipairs(words) do
	test("existing " .. word .. " assignment remains valid", function()
		local character = player({ quest = 14, wyrdin = 1, ["wyrdin-word"] = keyword })
		wyrdin.topic = 0
		say(wyrdin, character, "farmine")
		equal(character.values[mission.WyrdinKeyword], keyword)
		say(wyrdin, character, word)
		equal(character.values[mission.Wyrdin], 3)
	end)
end

test("plea still requires the farmine topic", function()
	local character = player({ quest = 14, wyrdin = 1, ["wyrdin-word"] = 1 })
	wyrdin.topic = 0
	say(wyrdin, character, "plea")
	equal(character.values[mission.Wyrdin], 1)
end)

for _, state in ipairs({ 2, 3 }) do
	test("failed or completed negotiations are not reset: " .. state, function()
		local character = player({ quest = 14, wyrdin = state, ["wyrdin-word"] = 4 })
		say(wyrdin, character, "farmine")
		equal(character.values[mission.WyrdinKeyword], 4)
		equal(character.values[mission.Wyrdin], state)
	end)
end

test("other quest stages are not repaired", function()
	local character = player({ quest = 15, wyrdin = 1, ["wyrdin-word"] = 4 })
	say(wyrdin, character, "farmine")
	equal(character.values[mission.WyrdinKeyword], 4)
end)

test("non-interacting players cannot repair storage", function()
	local character = player({ quest = 14, wyrdin = 1, ["wyrdin-word"] = 4 })
	wyrdin.interacting = false
	say(wyrdin, character, "farmine")
	equal(character.values[mission.WyrdinKeyword], 4)
	wyrdin.interacting = true
end)

print(string.format("%d passed, %d failed", passed, failed))
os.exit(failed == 0 and 0 or 1)
