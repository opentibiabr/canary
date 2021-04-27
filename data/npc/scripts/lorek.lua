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
local function addTravelKeyword(keyword, text, cost, destination, condition)
	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to ' .. (text or keyword:titleCase()) .. ' for |TRAVELCOST|?', cost = cost}, condition and function(player) return player:getPawAndFurRank() >= 3 end or nil)
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = cost, destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'Maybe another time.', reset = true})
end

addTravelKeyword('west', 'the west end of Port Hope', 7, Position(32558, 32780, 7))
addTravelKeyword('centre', 'the centre of Port Hope', 7, Position(32628, 32771, 7))
addTravelKeyword('darama', nil, 30, Position(32987, 32729, 7))
addTravelKeyword('center', 'the centre of Port Hope', 0, Position(32628, 32771, 7))
addTravelKeyword('chor', nil, 30, Position(32968, 32799, 7), true)
addTravelKeyword('banuta', nil, 30, Position(32826, 32631, 7), true)
addTravelKeyword('mountain', nil, 30, Position(32987, 32729, 7), true)
addTravelKeyword('mountain pass', nil, 30, Position(32987, 32729, 7), true)


-- Basic
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, text = "I heard he is some scary magician or so."})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'I can travel you to west, centre, darama, chor or banuta.'})

npcHandler:addModule(FocusModule:new())
