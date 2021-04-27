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

keywordHandler:addKeyword({'mission'}, StdModule.say, {npcHandler = npcHandler, text = 'Now that we have arrived you should waste no time and fight your way to the lair of evil and destroy its master before its too late!'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Me humble name is Rapanaio. Good old goblin name meaning honest, generous and nice person, I swear!'})

npcHandler:addModule(FocusModule:new())
