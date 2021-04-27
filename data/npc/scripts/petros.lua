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

addTravelKeyword('venore', 180, Position(32954, 32022, 6))
addTravelKeyword('port hope', 50, Position(32527, 32784, 6))
addTravelKeyword('liberty bay', 140, Position(32285, 32892, 6))
addTravelKeyword('ankrahmun', 150, Position(33092, 32883, 6))
addTravelKeyword('yalahar', 210, Position(32816, 31272, 6), function(player) return player:getStorageValue(Storage.SearoutesAroundYalahar.Darashia) ~= 1 and player:getStorageValue(Storage.SearoutesAroundYalahar.TownsCounter) < 5 end)
addTravelKeyword('gray island', 160, Position(33196, 31984, 7))
addTravelKeyword('krailos', 200, Position(33493, 31712, 6))
addTravelKeyword('travora', 1000, Position(32055, 32368, 6))
addTravelKeyword('issavi', 130, Position(33902, 31462, 6))

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(33288, 32474, 6), Position(33291, 32474, 6), Position(33293, 32471, 6)}})

-- Basic
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = "My boat is ready to bring you to {Venore}, {Port Hope}, {Liberty Bay}, {Yalahar}, {Gray Island}, {Ankrahmun}, {Krailos} or {Issavi}. Or to {Travora} - a place between the worlds."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of this ship.'})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = "Where do you want to go - {Krailos}, {Venore}, {Port Hope}, {Liberty Bay}, {Ankrahmun}, {Yalahar} or {Gray Island}?"})
keywordHandler:addKeyword({'darashia'}, StdModule.say, {npcHandler = npcHandler, text = "That's where we are."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s Petros.'})

npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye")

npcHandler:addModule(FocusModule:new())
