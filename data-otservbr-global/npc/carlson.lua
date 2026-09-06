local internalNpcName = "Carlson"
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
	lookHead = 38,
	lookBody = 113,
	lookLegs = 105,
	lookFeet = 86,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "sailor",
}
npcConfig.speechBubble = SPEECHBUBBLE_SAILOR

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
local function addTravelKeyword(keyword, text, cost, destination)
	local travelKeyword = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "Do you want to sail " .. text, cost = cost })
	travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, cost = cost, destination = destination })
	travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "We would like to serve you some time.", reset = true })
end

addTravelKeyword("tibia", "back to Tibia?", 0, Position(32235, 31674, 7))
addTravelKeyword("senja", "Senja for |TRAVELCOST|?", 20, Position(32128, 31664, 7))
addTravelKeyword("folda", "Folda for |TRAVELCOST|?", 20, Position(32046, 31578, 7))

-- Basic
keywordHandler:addKeyword({ "passage" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Folda}, {Senja} or {Tibia}?" })

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "ferries" }, StdModule.say, { npcHandler = npcHandler, text = "Our ferries are strong enough to stand the high waves of the Nordic Ocean." })
keywordHandler:addKeyword({ "ferry" }, StdModule.say, { npcHandler = npcHandler, text = "Our ferries are strong enough to stand the high waves of the Nordic Ocean." })
keywordHandler:addKeyword({ "ice islands" }, StdModule.say, { npcHandler = npcHandler, text = "We serve the routes to Senja, Folda, and Vega, and back to Tibia." })
keywordHandler:addKeyword({ "vega" }, StdModule.say, { npcHandler = npcHandler, text = "This island is Vega." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Carlson from the Nordic Tibia Ferries." })
keywordHandler:addKeyword({ "anderson" }, StdModule.say, { npcHandler = npcHandler, text = "The four of us are the captains of the Nordic Tibia Ferries." })
keywordHandler:addKeyword({ "carlson" }, StdModule.say, { npcHandler = npcHandler, text = "The four of us are the captains of the Nordic Tibia Ferries." })
keywordHandler:addKeyword({ "nielson" }, StdModule.say, { npcHandler = npcHandler, text = "The four of us are the captains of the Nordic Tibia Ferries." })
keywordHandler:addKeyword({ "svenson" }, StdModule.say, { npcHandler = npcHandler, text = "The four of us are the captains of the Nordic Tibia Ferries." })
keywordHandler:addKeyword({ "captain" }, StdModule.say, { npcHandler = npcHandler, text = "We are ferrymen. We transport goods and passengers to the Ice Islands." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "We are ferrymen. We transport goods and passengers to the Ice Islands." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
