local internalNpcName = "Captain Pelagia"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 155,
	lookHead = 94,
	lookBody = 0,
	lookLegs = 114,
	lookFeet = 85,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'Passages to Edron, Darashia, Oramond, Thais and Venore.'}
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
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. keyword:titleCase() .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('venore', 120, Position(32954, 32022, 6)) -- {x = 32954, y = 32022, z = 6}
addTravelKeyword('edron', 110, Position(33176, 31765, 6)) -- {x = 33176, y = 31765, z = 6}
addTravelKeyword('oramond', 70, Position(33479, 31985, 7)) -- {x = 33479, y = 31985, z = 7}
addTravelKeyword('darashia', 120, Position(33289, 32481, 6)) -- {x = 33289, y = 32481, z = 6}
addTravelKeyword('thais', 130, Position(32310, 32210, 6)) --
addTravelKeyword('issavi', 130, Position(33902, 31464, 6))

-- Darashia
local travelNode = keywordHandler:addKeyword({'darashia'}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to Darashia for |TRAVELCOST|?', cost = 0, discount = 'postman'})
	local childTravelNode = travelNode:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'I warn you! This route is haunted by a ghostship. Do you really want to go there?'})
		childTravelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = 0, discount = 'postman', destination = function(player) return math.random(10) == 1 and Position(33324, 32173, 6) or Position(33289, 32481, 6) end})
		childTravelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'We would like to serve you some time.'})
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, reset = true, text = 'We would like to serve you some time.'})

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(33498, 31711, 6)}})

-- Basic
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Edron}, {Darashia}, {Oramond} or {Venore}?'})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go? To {Edron}, {Darashia}, {Oramond} or {Venore}?'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of this ship.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of this ship.'})
keywordHandler:addKeyword({'venore'}, StdModule.say, {npcHandler = npcHandler, text = 'This is Venore. Where do you want to go?'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'My name is Captain Pelagia from the Royal Tibia Line.'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome on board, |PLAYERNAME|. Where can I {sail} you today?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye. Recommend us if you were satisfied with our service.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye then.')

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
