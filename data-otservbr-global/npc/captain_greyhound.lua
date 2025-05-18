local internalNpcName = "Captain Greyhound"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 129,
	lookHead = 96,
	lookBody = 113,
	lookLegs = 95,
	lookFeet = 115,
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

addTravelKeyword("thais", 110, Position(32310, 32210, 6))
addTravelKeyword("ab'dendriel", 80, Position(32734, 31668, 6))
addTravelKeyword("edron", 110, Position(33175, 31764, 6))
addTravelKeyword("venore", 130, Position(32954, 32022, 6))
addTravelKeyword("svargrond", 110, Position(32341, 31108, 6))
addTravelKeyword("yalahar", 185, Position(32816, 31272, 6), function(player)
	return player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.Carlin) ~= 1 and player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.TownsCounter) < 5
end)

-- Kick
keywordHandler:addKeyword({ "kick" }, StdModule.kick, { npcHandler = npcHandler, destination = { Position(32384, 31815, 6), Position(32387, 31815, 6), Position(32390, 31815, 6) } })

-- Basic
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Captain Greyhound from the Royal Tibia Line." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the captain of this sailing-ship." })
keywordHandler:addKeyword({ "captain" }, StdModule.say, { npcHandler = npcHandler, text = "I am the captain of this sailing-ship." })
keywordHandler:addKeyword({ "ship" }, StdModule.say, { npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia." })
keywordHandler:addKeyword({ "line" }, StdModule.say, { npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia." })
keywordHandler:addKeyword({ "company" }, StdModule.say, { npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia." })
keywordHandler:addKeyword({ "route" }, StdModule.say, { npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia." })
keywordHandler:addKeyword({ "good" }, StdModule.say, { npcHandler = npcHandler, text = "We can transport everything you want." })
keywordHandler:addKeyword({ "passenger" }, StdModule.say, { npcHandler = npcHandler, text = "We would like to welcome you on board." })
keywordHandler:addKeyword({ "trip" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Ab'Dendriel}, {Venore}, {Svargrond}, {Yalahar} or {Edron?}" })
keywordHandler:addKeyword({ "passage" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Ab'Dendriel}, {Venore}, {Svargrond}, {Yalahar} or {Edron?}" })
keywordHandler:addKeyword({ "town" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Ab'Dendriel}, {Venore}, {Svargrond}, {Yalahar} or {Edron?}" })
keywordHandler:addKeyword({ "destination" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Ab'Dendriel}, {Venore}, {Svargrond}, {Yalahar} or {Edron?}" })
keywordHandler:addKeyword({ "sail" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Ab'Dendriel}, {Venore}, {Svargrond}, {Yalahar} or {Edron?}" })
keywordHandler:addKeyword({ "go" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Ab'Dendriel}, {Venore}, {Svargrond}, {Yalahar} or {Edron?}" })
keywordHandler:addKeyword({ "ice" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but we don't serve the routes to the Ice Islands." })
keywordHandler:addKeyword({ "senja" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but we don't serve the routes to the Ice Islands." })
keywordHandler:addKeyword({ "folda" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but we don't serve the routes to the Ice Islands." })
keywordHandler:addKeyword({ "vega" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but we don't serve the routes to the Ice Islands." })
keywordHandler:addKeyword({ "darashia" }, StdModule.say, { npcHandler = npcHandler, text = "I'm not sailing there. This route is afflicted by a ghost ship! However I've heard that Captain Fearless from Venore sails there." })
keywordHandler:addKeyword({ "darama" }, StdModule.say, { npcHandler = npcHandler, text = "I'm not sailing there. This route is afflicted by a ghost ship! However I've heard that Captain Fearless from Venore sails there." })
keywordHandler:addKeyword({ "ghost" }, StdModule.say, { npcHandler = npcHandler, text = "Many people who sailed to Darashia never returned because they were attacked by a ghostship! I'll never sail there!" })
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "This is Carlin. Where do you want to go?" })

npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Recommend us if you were satisfied with our service.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
