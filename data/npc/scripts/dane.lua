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

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the owner of this place of relaxation."})
keywordHandler:addKeyword({'wave cellar'}, StdModule.say, {npcHandler = npcHandler, text = "It's pretty, isn't it?"})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I am Dane."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "It is exactly |TIME|."})
keywordHandler:addKeyword({'offer'}, StdModule.say, {npcHandler = npcHandler, text = "I can offer you milk, water, and lemonade."})
keywordHandler:addKeyword({'alcohol'}, StdModule.say, {npcHandler = npcHandler, text = "Alcohol makes people too aggressive. We don't need such stuff in Carlin."})
keywordHandler:addKeyword({'beer'}, StdModule.say, {npcHandler = npcHandler, text = "Alcohol makes people too aggressive. We don't need such stuff in Carlin."})
keywordHandler:addKeyword({'wine'}, StdModule.say, {npcHandler = npcHandler, text = "Alcohol makes people too aggressive. We don't need such stuff in Carlin."})

npcHandler:setMessage(MESSAGE_GREET, "Welcome to the wave cellar, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Please come back from time to time.")
npcHandler:addModule(FocusModule:new())
