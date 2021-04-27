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

local voices = { {text = 'By direct edict of the honorable Henricus, we are ordered to give passage for all recruits to Thais.'} }
npcHandler:addModule(VoiceModule:new(voices))

-- Travel
local travelKeyword = keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a passage to Thais for |TRAVELCOST|?', cost = 210, discount = 'postman'})
	travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, cost = 210, discount = 'postman', destination = Position(32310, 32210, 6)})
	travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'By direct edict of the honorable Henricus himself... well, you know.', reset = true})
keywordHandler:addAliasKeyword({'town'})

-- Kick
keywordHandler:addKeyword({'kick'}, StdModule.kick, {npcHandler = npcHandler, destination = {Position(33495, 32564, 7), Position(33495, 32563, 7), Position(33496, 32562, 7)}})

-- Basic
keywordHandler:addKeyword({'sail'}, StdModule.say, {npcHandler = npcHandler, text = "I can bring you back to {Thais} if you are weary or you can stay and fight. What shall it be?"})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Chelop and I am a captain of this {inquisition} ship."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "Can't you see? I'm captain of the Pesadilla, the proud {inquisition} ship which anchors here."})
keywordHandler:addKeyword({'inquisition'}, StdModule.say, {npcHandler = npcHandler, text = "By edict of the honorable Henricus himself, we are ordered to give passage to all recruits of the Roshamuul mission for a small fee."})
keywordHandler:addKeyword({'roshamuul'}, StdModule.say, {npcHandler = npcHandler, text = "This is the island you are currently on, just in case you forgot."})

npcHandler:setMessage(MESSAGE_GREET, "Welcome on board, recruit |PLAYERNAME|. Where can I {sail} you today?")
npcHandler:setMessage(MESSAGE_FAREWELL, "On behalf of the inquisition, I bid you farewell.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye then.")
npcHandler:addModule(FocusModule:new())
