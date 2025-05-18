local internalNpcName = "Captain Fearless"
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

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Passages to Thais, Carlin, Ab'Dendriel, Krailos, Port Hope, Edron, Darashia, Liberty Bay, Svargrond, Gray Island, Yalahar and Ankrahmun." },
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

addTravelKeyword("thais", 170, Position(32310, 32210, 6))
addTravelKeyword("krailos", 185, Position(33493, 31712, 6)) -- {x = 33493, y = 31712, z = 6}
addTravelKeyword("carlin", 130, Position(32387, 31820, 6))
addTravelKeyword("gray island", 150, Position(33196, 31984, 7))
addTravelKeyword("ab'dendriel", 90, Position(32734, 31668, 6))
addTravelKeyword("edron", 40, Position(33173, 31764, 6))
addTravelKeyword("port hope", 160, Position(32527, 32784, 6))
addTravelKeyword("svargrond", 150, Position(32341, 31108, 6))
addTravelKeyword("liberty bay", 180, Position(32285, 32892, 6))
addTravelKeyword("yalahar", 185, Position(32816, 31272, 6), function(player)
	return player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.Venore) ~= 1 and player:getStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.SearoutesAroundYalahar.TownsCounter) < 5
end)
addTravelKeyword("ankrahmun", 150, Position(33092, 32883, 6))
addTravelKeyword("issavi", 130, Position(33900, 31463, 6))

-- Darashia
local travelNode = keywordHandler:addKeyword({ "darashia" }, StdModule.say, { npcHandler = npcHandler, text = "Do you seek a passage to Darashia for |TRAVELCOST|?", cost = 60, discount = "postman" })
local childTravelNode = travelNode:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "I warn you! This route is haunted by a ghostship. Do you really want to go there?" })
childTravelNode:addChildKeyword({ "yes" }, StdModule.travel, {
	npcHandler = npcHandler,
	premium = false,
	cost = 60,
	discount = "postman",
	destination = function(player)
		return math.random(10) == 1 and Position(33324, 32173, 6) or Position(33289, 32481, 6)
	end,
})
childTravelNode:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, reset = true, text = "We would like to serve you some time." })
travelNode:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, reset = true, text = "We would like to serve you some time." })

-- Kick
keywordHandler:addKeyword({ "kick" }, StdModule.kick, { npcHandler = npcHandler, destination = { Position(32952, 32031, 6), Position(32955, 32031, 6), Position(32957, 32032, 6) } })

-- Basic
keywordHandler:addKeyword({ "sail" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Issavi}, {krailos}, {Thais}, {Carlin}, {Ab'Dendriel}, {Port Hope}, {Edron}, {Darashia}, {Liberty Bay}, {Svargrond}, {Yalahar}, {Gray Island} or {Ankrahmun}?" })
keywordHandler:addKeyword({ "passage" }, StdModule.say, { npcHandler = npcHandler, text = "Where do you want to go? To {Issavi} {krailos}, {Thais}, {Carlin}, {Ab'Dendriel}, {Port Hope}, {Edron}, {Darashia}, {Liberty Bay}, {Svargrond}, {Yalahar}, {Gray Island} or {Ankrahmun}?" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the captain of this ship." })
keywordHandler:addKeyword({ "captain" }, StdModule.say, { npcHandler = npcHandler, text = "I am the captain of this ship." })
keywordHandler:addKeyword({ "venore" }, StdModule.say, { npcHandler = npcHandler, text = "This is Venore. Where do you want to go?" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Captain Fearless from the Royal Tibia Line." })

npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Recommend us if you were satisfied with our service.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
