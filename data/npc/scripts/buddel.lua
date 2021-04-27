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
local function addTravelKeyword(keyword, text, destination, condition)
	if condition then
		keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'No, no, no, you even are no barb....barba...er.. one of us!!!! Talk to the Jarl first! '}, condition)
	end

	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = text, cost = 50, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = 50, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'You shouldn\'t miss the experience.', reset = true})
end

addTravelKeyword('okolnir', 'It\'s nice there. Except of the ice dragons which are not very companionable.', Position(32225, 31381, 7), function(player) return player:getStorageValue(Storage.BarbarianTest.Questline) < 8 end)
addTravelKeyword('helheim', 'T\'at is a small island to the east.', Position(32462, 31174, 7), function(player) return player:getStorageValue(Storage.BarbarianTest.Questline) < 8 end)
addTravelKeyword('tyrsung', '*HICKS* Big, big island east of here. Venorian hunters settled there ..... I could bring you north of their camp.', Position(32333, 31227, 7), function(player) return player:getStorageValue(Storage.BarbarianTest.Questline) < 8 end)
addTravelKeyword('camp', 'Both of you look like you could defend yourself! If you want to go there, ask me for a passage.', Position(32021, 31294, 7), function(player) return player:getStorageValue(Storage.BarbarianTest.Questline) < 8 end)

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, text = 'Get out o\' here!*HICKS*', destination = {Position(32255, 31193, 7), Position(32256, 31193, 7), Position(32257, 31193, 7)}})

keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = "Where are we at the moment? Is this Svargrond? Ahh yes!*HICKS* Where do you want to go?"})
keywordHandler:addKeyword({'trip'}, StdModule.say, {npcHandler = npcHandler, text = "Where are we at the moment? Is this Svargrond? Ahh yes!*HICKS* Where do you want to go?"})
keywordHandler:addKeyword({'go'}, StdModule.say, {npcHandler = npcHandler, text = "Where are we at the moment? Is this Svargrond? Ahh yes!*HICKS* Where do you want to go?"})
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = "Where are we at the moment? Is this Svargrond? Ahh yes!*HICKS* Where do you want to go?"})

npcHandler:addModule(FocusModule:new())
