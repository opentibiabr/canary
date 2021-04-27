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

addTravelKeyword('thais', 130, Position(32310, 32210, 6))
addTravelKeyword('carlin', 80, Position(32387, 31820, 6))
addTravelKeyword('gray island', 150, Position(33196, 31984, 7))
addTravelKeyword('edron', 70, Position(33175, 31764, 6))
addTravelKeyword('venore', 90, Position(32954, 32022, 6))
addTravelKeyword('yalahar', 160, Position(32816, 31272, 6), function(player) return player:getStorageValue(Storage.SearoutesAroundYalahar.AbDendriel) ~= 1 and player:getStorageValue(Storage.SearoutesAroundYalahar.TownsCounter) < 5 end)

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(32724, 31669, 6), Position(32726, 31665, 6)}})

-- Basic
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Captain Seagull from the Royal Tibia Line."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the captain of this sailing-ship."})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = "I am the captain of this sailing-ship."})
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'line'}, StdModule.say, {npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'company'}, StdModule.say, {npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'route'}, StdModule.say, {npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = "The Royal Tibia Line connects all seaside towns of Tibia."})
keywordHandler:addKeyword({'good'}, StdModule.say, {npcHandler = npcHandler, text = "We can transport everything you want."})
keywordHandler:addKeyword({'passanger'}, StdModule.say, {npcHandler = npcHandler, text = "We would like to welcome you on board."})
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Carlin}, {Venore}, {Yalahar}, {Edron} or {Gray Island}?"})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = "WWhere do you want to go? To {Thais}, {Carlin}, {Venore}, {Yalahar}, {Edron} or {Gray Island}?"})
keywordHandler:addKeyword({'town'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Carlin}, {Venore}, {Yalahar}, {Edron} or {Gray Island}?"})
keywordHandler:addKeyword({'destination'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Carlin}, {Venore}, {Yalahar}, {Edron} or {Gray Island}?"})
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Carlin}, {Venore}, {Yalahar}, {Edron} or {Gray Island}?"})
keywordHandler:addKeyword({'go'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go? To {Thais}, {Carlin}, {Venore}, {Yalahar}, {Edron} or {Gray Island}?"})
keywordHandler:addKeyword({'ice'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve the routes to the Ice Islands."})
keywordHandler:addKeyword({'senja'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve the routes to the Ice Islands."})
keywordHandler:addKeyword({'folda'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve the routes to the Ice Islands."})
keywordHandler:addKeyword({'vega'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve the routes to the Ice Islands."})
keywordHandler:addKeyword({'ankrahmun'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve this route."})
keywordHandler:addKeyword({'tiquanda'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve this route."})
keywordHandler:addKeyword({'port hope'}, StdModule.say, {npcHandler = npcHandler, text = "I'm sorry, but we don't serve this route."})
keywordHandler:addKeyword({'darashia'}, StdModule.say, {npcHandler = npcHandler, text = "I'm not sailing there. This route is afflicted by a ghost ship! However I've heard that Captain Fearless from Venore sails there."})
keywordHandler:addKeyword({'darama'}, StdModule.say, {npcHandler = npcHandler, text = "I'm not sailing there. This route is afflicted by a ghost ship! However I've heard that Captain Fearless from Venore sails there."})
keywordHandler:addKeyword({'ghost'}, StdModule.say, {npcHandler = npcHandler, text = "Many people who sailed to Darashia never returned because they were attacked by a ghostship! I'll never sail there!"})
keywordHandler:addKeyword({'ab\'dendriel'}, StdModule.say, {npcHandler = npcHandler, text = "This is Ab\'Dendriel. Where do you want to go?"})

npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Recommend us if you were satisfied with our service.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")
npcHandler:addModule(FocusModule:new())
