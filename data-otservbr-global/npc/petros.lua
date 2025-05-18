local internalNpcName = "Petros"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 79,
	lookBody = 10,
	lookLegs = 127,
	lookFeet = 127,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

-- Travel
local function addTravelKeyword(keyword, cost, destination, condition)
	if condition then
		keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry but I don't sail there." }, condition)
	end

	local travelKeyword = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "Do you seek a passage to " .. keyword:titleCase() .. " for |TRAVELCOST|?", cost = cost, discount = "postman" })
	travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, cost = cost, discount = "postman", destination = destination })
	travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "We would like to serve you some time.", reset = true })
end

addTravelKeyword("venore", 180, Position(32954, 32022, 6))
addTravelKeyword("port hope", 50, Position(32527, 32784, 6))
addTravelKeyword("liberty bay", 140, Position(32285, 32892, 6))
addTravelKeyword("ankrahmun", 150, Position(33092, 32883, 6))
addTravelKeyword("yalahar", 210, Position(32816, 31272, 6), function(player)
	return player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.Darashia) ~= 1 and player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.TownsCounter) < 5
end)
addTravelKeyword("gray island", 160, Position(33196, 31984, 7))
addTravelKeyword("krailos", 200, Position(33493, 31712, 6))
addTravelKeyword("issavi", 130, Position(33902, 31462, 6))

-- Kick
keywordHandler:addKeyword({ "kick" }, StdModule.kick, { npcHandler = npcHandler, destination = { Position(33288, 32474, 6), Position(33291, 32474, 6), Position(33293, 32471, 6) } })

-- Basic
keywordHandler:addKeyword({ "sail" }, StdModule.say, { npcHandler = npcHandler, text = "My boat is ready to bring you to {Venore}, {Port Hope}, {Liberty Bay}, {Yalahar}, {Gray Island}, {Ankrahmun}, {Krailos} or {Issavi}. Or to {Travora} - a place between the worlds." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the captain of this ship." })
keywordHandler:addKeyword({ "passage" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go - {Krailos}, {Venore}, {Port Hope}, {Liberty Bay}, {Ankrahmun}, {Yalahar} or {Gray Island}?" })
keywordHandler:addKeyword({ "darashia" }, StdModule.say, { npcHandler = npcHandler, text = "That's where we are." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "It's Petros." })

npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
