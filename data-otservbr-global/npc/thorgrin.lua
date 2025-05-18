local internalNpcName = "Thorgrin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 66,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Ask me for a passage..." },
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
local function addTravelKeyword(keyword, cost, destination, text, action, discount)
	local travelKeyword = keywordHandler:addKeyword({ keyword }, StdModule.say, { npcHandler = npcHandler, text = text or "Do you seek a ride to " .. keyword:titleCase() .. " for |TRAVELCOST|?", cost = cost, discount = discount or "postman" })
	travelKeyword:addChildKeyword({ "yes" }, StdModule.travel, { npcHandler = npcHandler, premium = false, cost = cost, discount = discount or "postman", destination = destination, text = "Full steam ahead!" }, nil, action)
	travelKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "Then not", reset = true })
end

addTravelKeyword("kazordoon", 210, Position(32659, 31957, 15))
addTravelKeyword("cormaya", 110, Position(33310, 31988, 15))
addTravelKeyword("gnomprona", 200, Position(33516, 32856, 14), "Would you like to travel to Gnomprona for |TRAVELCOST|?", nil, "postman")

keywordHandler:addKeyword({ "passage" }, StdModule.say, { npcHandler = npcHandler, text = "Do you want me take you to {Cormaya}, {Kazordoon} or {Gnomprona}?" })

npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|! May earth protect you on the rocky grounds. If you need a {passage} back, I can help you.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
