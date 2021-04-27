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

keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = "I offer quite a lot of food. Ask me for a {trade} if you're hungry"})

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|! What do you need? If it's {food}, you've come to the right place.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Yep, take a good look.")
npcHandler:addModule(FocusModule:new())
