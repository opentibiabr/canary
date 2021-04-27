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

keywordHandler:addKeyword({'furniture'}, StdModule.say, {npcHandler = npcHandler, text = "Well, as you can see, I sell furniture. Ask me for a {trade} if you're interested to see my wares."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Nydala. I run this store."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "It is |TIME|. Do you need a clock for your house?"})

npcHandler:setMessage(MESSAGE_GREET, "Welcome to Carlin Furniture Store, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Have a look. Most furniture comes in handy kits. Just use them in your house to assemble the furniture. Do you want to see only a certain {type} of furniture?")
npcHandler:addModule(FocusModule:new())
