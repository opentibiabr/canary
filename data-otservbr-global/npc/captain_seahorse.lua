local internalNpcName = "Captain Seahorse"
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
	lookHead = 19,
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
local function addTravelKeyword(keyword, cost, destination, action)
	local travelKeyword = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = "Do you seek a seek a passage to " .. keyword:titleCase() .. " for |TRAVELCOST|?", cost = cost, discount = "postman" })
	travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, cost = cost, discount = "postman", destination = destination }, nil, action)
	travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "We would like to serve you some time.", reset = true })
end

addTravelKeyword("venore", 40, Position(32954, 32022, 6), function(player)
	if player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission01) == 3 then
		player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission01, 4)
	end
end)
addTravelKeyword("thais", 160, Position(32310, 32210, 6))
addTravelKeyword("carlin", 110, Position(32387, 31820, 6))
addTravelKeyword("krailos", 185, Position(33493, 31712, 6))
addTravelKeyword("ab'dendriel", 70, Position(32734, 31668, 6))
addTravelKeyword("gray island", 190, Position(33196, 31984, 7))
addTravelKeyword("port hope", 150, Position(32527, 32784, 6))
addTravelKeyword("liberty bay", 170, Position(32285, 32892, 6))
addTravelKeyword("ankrahmun", 160, Position(33092, 32883, 6))
addTravelKeyword("cormaya", 20, Position(33288, 31956, 6))
addTravelKeyword("oramond", 200, Position(33479, 31985, 7))

-- Kick
keywordHandler:addKeyword({ "kick" }, StdModule.kick, { npcHandler = npcHandler, destination = { Position(33174, 31773, 6), Position(33175, 31771, 6), Position(33177, 31772, 6) } })

-- Basic
keywordHandler:addKeyword({ "sail" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Krailos}, {Thais}, {Carlin}, {Ab'Dendriel}, {Venore}, {Port Hope}, {Ankrahmun}, {Liberty Bay}, {Gray Island} or the isle {Cormaya}?" })
keywordHandler:addKeyword({ "passage" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Krailos}, {Thais}, {Carlin}, {Ab'Dendriel}, {Venore}, {Port Hope}, {Ankrahmun}, {Liberty Bay}, {Gray Island} or the isle {Cormaya}?" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Captain Seahorse from the Royal Tibia Line." })
keywordHandler:addKeyword({ "edron" }, StdModule.say, { npcHandler = npcHandler, text = "This is Edron. Where do you want to go?" })
keywordHandler:addKeyword({ "yalahar" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but we don't serve this route. However, I heard that Wyrdin here in Edron is looking for adventurers to go on a trip to Yalahar for him." })

npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, |PLAYERNAME|. Where may I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Recommend us if you were satisfied with our service.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
