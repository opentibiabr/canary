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

-- Travel
local function addTravelKeyword(keyword, cost, destination, condition)
	if condition then
		keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sorry but I don\'t sail there.'}, condition)
	end

	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. keyword:titleCase() .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('edron', 160, Position(33175, 31764, 6))
addTravelKeyword('venore', 150, Position(32954, 32022, 6))
addTravelKeyword('port hope', 80, Position(32527, 32784, 6))
addTravelKeyword('liberty bay', 90, Position(32285, 32892, 6))
addTravelKeyword('darashia', 100, Position(33289, 32480, 6))
addTravelKeyword('yalahar', 230, Position(32816, 31272, 6), function(player) return player:getStorageValue(Storage.SearoutesAroundYalahar.Ankrahmun) ~= 1 and player:getStorageValue(Storage.SearoutesAroundYalahar.TownsCounter) < 5 end)

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(33082, 32879, 6), Position(33085, 32879, 6), Position(33085, 32881, 6)}})

-- Basic
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I'm known all over the world as Captain Sinbeard"})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I'm the captain of this sailing ship"})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = "I'm the captain of this sailing ship"})
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler, text = "My ship is the fastest in the whole world."})
keywordHandler:addKeyword({'line'}, StdModule.say, {npcHandler = npcHandler, text = "My ship is the fastest in the whole world."})
keywordHandler:addKeyword({'company'}, StdModule.say, {npcHandler = npcHandler, text = "My ship is the fastest in the whole world."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = "My ship is the fastest in the whole world."})
keywordHandler:addKeyword({'god'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope}, {Yalahar} or {Edron}? Or to {Travora} - the island between the worlds?"})
keywordHandler:addKeyword({'passanger'}, StdModule.say, {npcHandler = npcHandler, text = "We would like to welcome you on board."})
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope}, {Yalahar} or {Edron}? Or to {Travora} - the island between the worlds?"})
keywordHandler:addKeyword({'route'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope}, {Yalahar} or {Edron}? Or to {Travora} - the island between the worlds?"})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope}, {Yalahar} or {Edron}? Or to {Travora} - the island between the worlds?"})
keywordHandler:addKeyword({'town'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope}, {Yalahar} or {Edron}? Or to {Travora} - the island between the worlds?"})
keywordHandler:addKeyword({'destination'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope}, {Yalahar} or {Edron}? Or to {Travora} - the island between the worlds?"})
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope}, {Yalahar} or {Edron}? Or to {Travora} - the island between the worlds?"})
keywordHandler:addKeyword({'go'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Darashia}, {Venore}, {Liberty Bay}, {Port Hope}, {Yalahar} or {Edron}? Or to {Travora} - the island between the worlds?"})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry but I don't sail there."})
keywordHandler:addKeyword({'carlin'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry but I don't sail there."})
keywordHandler:addKeyword({'ab\'dendriel'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry but I don't sail there."})
keywordHandler:addKeyword({'ankrahmun'}, StdModule.say, {npcHandler = npcHandler, text = "That's where we are."})

npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, Sir |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Recommend us if you were satisfied with our service.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")
npcHandler:addModule(FocusModule:new())
