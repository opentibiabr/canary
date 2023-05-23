local internalNpcName = "Junkar"
local npcType = Game.createNpcType("Junkar (Robsons)")
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 66
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'So much to do. So many things to be fixed.' },
	{ text = 'Still so much work.' }
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
local function addTravelKeyword(keyword, cost, destination)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = (text or 'So you wish for a trip to ') .. keyword:titleCase() .. '? |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, text = 'Full speed ahead!', cost = cost, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Well, then you stay here, simple as that.', reset = true})
end

addTravelKeyword('kazordoon', 80, Position(32660, 31957, 15))
addTravelKeyword('thais', 80, Position(32370, 32180, 13))
addTravelKeyword('mines', 70, Position(32555, 32069, 10))

keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want me to take you? To {Kazordoon} or to {Thais}? Occasionally we can even reach the {mines} if they are cleared.'})

npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|! You are lucky that the service is running right now. Save your coal for the days to come though!")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you next time!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "<Sigh> No patience!")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
