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
local function addTravelKeyword(keyword, text, cost, destination, condition, action)
	if condition then
		keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Never heard about a place like this.'}, condition)
	end

	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = text, cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, text = 'Hold on!', cost = cost, discount = 'postman', destination = destination}, nil, action)
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'You shouldn\'t miss the experience.', reset = true})
end

addTravelKeyword('eclipse', 'Oh no, so the time has come? Do you really want me to fly you to this unholy place?', 110, Position(32659, 31915, 0), function(player) return player:getStorageValue(Storage.TheInquisition.Questline) ~= 4 and player:getStorageValue(Storage.TheInquisition.Questline) ~= 5 end)
addTravelKeyword('farmine', 'Do you seek a ride to Farmine for |TRAVELCOST|?', 60, Position(32983, 31539, 1), function(player) return player:getStorageValue(Storage.TheNewFrontier.Mission10) ~= 1 end)
addTravelKeyword('edron', 'Do you seek a ride to Edron for |TRAVELCOST|?', 60, Position(33193, 31783, 3), nil, function(player) if player:getStorageValue(Storage.Postman.Mission01) == 2 then player:setStorageValue(Storage.Postman.Mission01, 3) end end)
addTravelKeyword('darashia', 'Do you seek a ride to Darashia on Darama for |TRAVELCOST|?', 60, Position(33270, 32441, 6))
addTravelKeyword('svargrond', 'Do you seek a ride to Svargrond for |TRAVELCOST|?', 60, Position(32253, 31097, 4))
addTravelKeyword('kazordoon', 'Do you seek a ride to Kazordoon for |TRAVELCOST|?', 60, Position(32588, 31942, 0))
addTravelKeyword('issavi', 'Do you seek a ride to Issavi for |TRAVELCOST|?', 100, Position(33957, 31515, 0))

-- Basic
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I am known as Uzon Ibn Kalith."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am a licensed Darashian carpet pilot. I can bring you to {Darashia}, {Kazordoon}, {Svargrond} or {Edron}."})
keywordHandler:addKeyword({'caliph'}, StdModule.say, {npcHandler = npcHandler, text = "The caliph welcomes travellers to his land."})
keywordHandler:addKeyword({'kazzan'}, StdModule.say, {npcHandler = npcHandler, text = "The caliph welcomes travellers to his land."})
keywordHandler:addKeyword({'daraman'}, StdModule.say, {npcHandler = npcHandler, text = "Oh, there is so much to tell about Daraman. You better travel to Darama to learn about his teachings."})
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, text = "I would never transport this one."})
keywordHandler:addKeyword({'drefia'}, StdModule.say, {npcHandler = npcHandler, text = "So you heard about haunted Drefia? Many adventures travel there to test their skills against the undead: vampires, mummies, and ghosts."})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = "Some people claim it is hidden somewhere under the endless sands of the devourer desert in Darama."})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = "Thais is noisy and overcrowded. That's why I like Darashia more."})
keywordHandler:addKeyword({'tibia'}, StdModule.say, {npcHandler = npcHandler, text = "I have seen almost every place on the continent."})
keywordHandler:addKeyword({'continent'}, StdModule.say, {npcHandler = npcHandler, text = "I could retell the tales of my travels for hours. Sadly another flight is scheduled soon."})
keywordHandler:addKeyword({'carlin'}, StdModule.say, {npcHandler = npcHandler, text = "Just another Thais but with women to lead them."})
keywordHandler:addKeyword({'flying'}, StdModule.say, {npcHandler = npcHandler, text = "You can buy flying carpets only in Darashia."})
keywordHandler:addKeyword({'fly'}, StdModule.say, {npcHandler = npcHandler, text = "I transport travellers to the continent of Darama for a small fee. So many want to see the wonders of the desert and learn the secrets of Darama."})
keywordHandler:addKeyword({'new'}, StdModule.say, {npcHandler = npcHandler, text = "I heard too many news to recall them all."})
keywordHandler:addKeyword({'rumors'}, StdModule.say, {npcHandler = npcHandler, text = "I heard too many news to recall them all."})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = "I can fly you to {Darashia} on Darama, {Kazordoon}, {Svargrond} or {Edron} if you like. Where do you want to go?"})
keywordHandler:addKeyword({'transport'}, StdModule.say, {npcHandler = npcHandler, text = "I can fly you to {Darashia} on Darama, {Kazordoon}, {Svargrond} or {Edron} if you like. Where do you want to go?"})
keywordHandler:addKeyword({'ride'}, StdModule.say, {npcHandler = npcHandler, text = "I can fly you to {Darashia} on Darama, {Kazordoon}, {Svargrond} or {Edron} if you like. Where do you want to go?"})
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, text = "I can fly you to {Darashia} on Darama, {Kazordoon}, {Svargrond} or {Edron} if you like. Where do you want to go?"})

npcHandler:setMessage(MESSAGE_GREET, "Daraman's blessings, traveller |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Daraman's blessings")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Daraman's blessings")

npcHandler:addModule(FocusModule:new())
