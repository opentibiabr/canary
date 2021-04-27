local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
	npcHandler:onThink()
end

local voices = { {text = 'Feel the wind in your hair during one of my carpet rides!'} }
npcHandler:addModule(VoiceModule:new(voices))

-- Travel
local function addTravelKeyword(keyword, cost, destination, action, condition)
	if condition then
		keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sorry but I don\'t sail there.'}, condition)
	end

	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. keyword:titleCase() .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, discount = 'postman', destination = destination}, nil, action)
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('darashia', 60, Position(33270, 32441, 6))
addTravelKeyword('svargrond', 40, Position(32253, 31097, 4))
addTravelKeyword('kazordoon', 80, Position(32588, 31941, 0))
addTravelKeyword('zao', 60, Position(32983, 31539, 1))
addTravelKeyword('femor hills', 60, Position(32536, 31837, 4))
addTravelKeyword('edron', 60, Position(33193, 31784, 3))

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(33958, 31512, 1), Position(33959, 31512, 1)}})

-- Basic
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills} or to {Edron} if you like. Where do you want to go?'})
keywordHandler:addKeyword({'route'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills} or to {Edron} if you like. Where do you want to go?'})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills} or to {Edron} if you like. Where do you want to go?'})
keywordHandler:addKeyword({'town'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills} or to {Edron} if you like. Where do you want to go?'})
keywordHandler:addKeyword({'destination'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills} or to {Edron} if you like. Where do you want to go?'})
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills} or to {Edron} if you like. Where do you want to go?'})
keywordHandler:addKeyword({'go'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Svargrond}, to {Kazordoon}, to {Zao}, to the {Femor Hills} or to {Edron} if you like. Where do you want to go?'})

npcHandler:setMessage(MESSAGE_GREET, 'Ah, the wind brings in another visitor. Welcome, dear guest. Are you looking for a {passage} with my carpet?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye. Recommend us if you were satisfied with our service.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye then.')

npcHandler:addModule(FocusModule:new())
