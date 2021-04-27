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

local voices = { {text = 'Passages to Thais and Krailos! Visit the strange lands!'} }
npcHandler:addModule(VoiceModule:new(voices))

-- Travel
local function addTravelKeyword(keyword, cost, destination, action)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. keyword:titleCase() .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, discount = 'postman', destination = destination}, nil, action)
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('thais', 150, Position(32311, 32210, 6))
addTravelKeyword('krailos', 180, Position(33493, 31712, 6))
addTravelKeyword('travora', 1000, Position(32055, 32368, 6))
addTravelKeyword('issavi', 130, Position(33902, 31462, 6))

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(33487, 31986, 7), Position(33486, 31984, 7)}})

-- Basic
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Ah, you may not have heard of me. I am Captain Gulliver, the first Oramondian for a hundred years to have sailed through the mist to your strange lands.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of the \'Sea Goddess\', the splendid and beautiful ship you see over there.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of the \'Sea Goddess\', the splendid and beautiful ship you see over there.'})
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler, text = 'The \'Sea Goddess\' is the most beautiful in Oramond, a whole new model of ship, elegant, sure and swift. There\'s no weather she can\'t take!'})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = 'Ah, your lands are quite a sight! I have only visited Thais so far, but I think of navigating to more cities, when the time - and public demand - comes.'})
keywordHandler:addKeyword({'good'}, StdModule.say, {npcHandler = npcHandler, text = 'I will gladly take on board everything you wish to transport. No pets, though.'})
keywordHandler:addKeyword({'passenger'}, StdModule.say, {npcHandler = npcHandler, text = '<bows> I would be delighted to have you on board.'})

keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = 'You would like to book a passage for {Thais} or {Krailos}?'})
keywordHandler:addKeyword({'route'}, StdModule.say, {npcHandler = npcHandler, text = 'You would like to book a passage for {Thais} or {Krailos}?'})
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, text = 'You would like to book a passage for {Thais} or {Krailos}?'})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'You would like to book a passage for {Thais} or {Krailos}?'})
keywordHandler:addKeyword({'town'}, StdModule.say, {npcHandler = npcHandler, text = 'You would like to book a passage for {Thais} or {Krailos}?'})
keywordHandler:addKeyword({'destination'}, StdModule.say, {npcHandler = npcHandler, text = 'You would like to book a passage for {Thais} or {Krailos}?'})
keywordHandler:addKeyword({'go'}, StdModule.say, {npcHandler = npcHandler, text = 'You would like to book a passage for {Thais} or {Krailos}?'})

keywordHandler:addKeyword({'oramond'}, StdModule.say, {npcHandler = npcHandler, text = 'This is the only safe landing place on Oramond. The cliffs surrounding the isle are too dangerous, you see.'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome on board, Sir |PLAYERNAME|. Where can I {sail} you today?')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye. Recommend us if you were satisfied with our service.')

npcHandler:addModule(FocusModule:new())
