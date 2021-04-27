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

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "Barbarians are stupid."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "Bronbronbronbronbron. Bronnnn!"})
keywordHandler:addKeyword({'outfit'}, StdModule.say, {npcHandler = npcHandler, text = "Can I have free outfits?"})
keywordHandler:addKeyword({'gelagos'}, StdModule.say, {npcHandler = npcHandler, text = "That's me."})
keywordHandler:addKeyword({'brother'}, StdModule.say, {npcHandler = npcHandler, text = "Ajax is even more stupid."})
keywordHandler:addKeyword({'savage'}, StdModule.say, {npcHandler = npcHandler, text = "You are as stupid as Bron."})
keywordHandler:addKeyword({'cyclops'}, StdModule.say, {npcHandler = npcHandler, text = "Any cyclops is smarter than Bron."})

npcHandler:setMessage(MESSAGE_GREET, "Hehehe.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Hope you die and lose it.")
npcHandler:addModule(FocusModule:new())
