local internalNpcName = "Ziyad"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 146,
	lookHead = 114,
	lookBody = 49,
	lookLegs = 94,
	lookFeet = 49,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'Feel the wind in your hair during one of my carpet rides!'}
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
local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function addTravelKeyword(keyword, text, cost, destination, condition, action)
	if condition then
		keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Never heard about a place like this.'}, condition)
	end

	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. keyword:titleCase() .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, discount = 'postman', destination = destination}, nil, action)
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('farmine', 'Do you seek a ride to Farmine for |TRAVELCOST|?', 60, Position(32983, 31539, 1), function(player) return player:getStorageValue(TheNewFrontier.Mission10[1]) ~= 2 end)
addTravelKeyword('zao', 'Do you seek a ride to Farmine for |TRAVELCOST|?', 60, Position(32983, 31539, 1), function(player) return player:getStorageValue(TheNewFrontier.Mission10[1]) ~= 2 end)
addTravelKeyword('darashia', 'Darashia on Darama', 40, Position(33270, 32441, 6))
addTravelKeyword('darama', 'Darashia on Darama', 40, Position(33270, 32441, 6))
addTravelKeyword('kazordoon', 'Kazordoon', 70, Position(32588, 31941, 0))
addTravelKeyword('kazor', 'Kazordoon', 70, Position(32588, 31941, 0))
addTravelKeyword('femor hills', 'the Femor Hills', 60, Position(32536, 31837, 4))
addTravelKeyword('hills', 'the Femor Hills', 60, Position(32536, 31837, 4))
addTravelKeyword('svargrond', 'Svargrond', 60, Position(32253, 31097, 4))
addTravelKeyword('edron', 'Edron', 60, Position(33193, 31784, 3))
addTravelKeyword('issavi', 'Issavi', 100, Position(33957, 31515, 0))

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(33958, 31512, 1), Position(33959, 31512, 1)}})

-- Basic
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills}, to {Edron} or to {Issavi} if you like. Where do you want to go?'})
keywordHandler:addKeyword({'route'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills}, to {Edron} or to {Issavi} if you like. Where do you want to go?'})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills}, to {Edron} or to {Issavi} if you like. Where do you want to go?'})
keywordHandler:addKeyword({'fly'}, StdModule.say, {npcHandler = npcHandler, text ='I can fly you to {Darashia}, {Edron}, {Issavi}, {Svargrond}, {Kazordoon}, {Zao} or to {Femor Hills} if you like. Where do you want to go?'})
keywordHandler:addKeyword({'town'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills}, to {Edron} or to {Issavi} if you like. Where do you want to go?'})
keywordHandler:addKeyword({'destination'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills}, to {Edron} or to {Issavi} if you like. Where do you want to go?'})
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills}, to {Edron} or to {Issavi} if you like. Where do you want to go?'})
keywordHandler:addKeyword({'go'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills}, to {Edron} or to {Issavi} if you like. Where do you want to go?'})

npcHandler:setMessage(MESSAGE_GREET, 'Ah, the wind brings in another visitor. Welcome, dear guest. Are you looking for a {passage} with my carpet?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye. Recommend us if you were satisfied with our service.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye then.')

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
