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

local voices = { {text = 'Passages to Thais, Darashia, Edron, Venore, Ankrahmun, Liberty Bay and Yalahar.'} }
npcHandler:addModule(VoiceModule:new(voices))

-- Travel
local function addTravelKeyword(keyword, cost, destination, condition)
	if condition then
		keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sorry but I don\'t sail there.'}, condition)
	end

	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. keyword:titleCase() .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'We would like to serve you some time.', reset = true})
end

addTravelKeyword('edron', 150, Position(33173, 31764, 6))
addTravelKeyword('venore', 160, Position(32954, 32022, 6))
addTravelKeyword('yalahar', 260, Position(32816, 31272, 6), function(player) return player:getStorageValue(Storage.SearoutesAroundYalahar.PortHope) ~= 1 and player:getStorageValue(Storage.SearoutesAroundYalahar.TownsCounter) < 5 end)
addTravelKeyword('ankrahmun', 110, Position(33092, 32883, 6))
addTravelKeyword('darashia', 180, Position(33289, 32480, 6))
addTravelKeyword('thais', 160, Position(32310, 32210, 6))
addTravelKeyword('liberty bay', 50, Position(32285, 32892, 6))
addTravelKeyword('carlin', 120, Position(32387, 31820, 6))
addTravelKeyword('shortcut', 100, Position(32029, 32466, 7), function(player) return player:getStorageValue(Storage.TheSecretLibrary.PinkTel) == 2 and player:getStorageValue(Storage.TheSecretLibrary.Mota) == 12 end)

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(32535, 32792, 6), Position(32536, 32778, 6)}})

-- Basic
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go - {Thais}, {Darashia}, {Venore}, {Liberty Bay}, {Ankrahmun}, {Yalahar} or {Edron?}'})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want to go - {Thais}, {Darashia}, {Venore}, {Liberty Bay}, {Ankrahmun}, {Yalahar} or {Edron?}'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'Im the captain of the Poodle, the proudest ship on all oceans.'})
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler, text = 'I am the captain of this ship.'})
keywordHandler:addKeyword({'port hope'}, StdModule.say, {npcHandler = npcHandler, text = "That's where we are."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s Charles.'})
keywordHandler:addKeyword({'svargrond'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m sorry, but we don\'t serve the routes to the Ice Islands.'})

npcHandler:setMessage(MESSAGE_GREET, "Ahoy. Where can I sail you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye.")
npcHandler:addModule(FocusModule:new())
