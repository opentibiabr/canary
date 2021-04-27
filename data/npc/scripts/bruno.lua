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

keywordHandler:addKeyword({'offer'}, StdModule.say, {npcHandler = npcHandler, text = "Well, I sell freshly caught fish. You like some? Of course, you can buy more than one at once. *grin* Just ask me for a {trade}."})
keywordHandler:addKeyword({'buy'}, StdModule.say, {npcHandler = npcHandler, text = "Well, I sell freshly caught fish. You like some? Of course, you can buy more than one at once. *grin* Just ask me for a {trade}."})
keywordHandler:addKeyword({'fish'}, StdModule.say, {npcHandler = npcHandler, text = "Well, I sell freshly caught fish. You like some? Of course, you can buy more than one at once. *grin* Just ask me for a {trade}."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Bruno."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "My job is to catch fish and to sell them here."})
keywordHandler:addKeyword({'marlene'}, StdModule.say, {npcHandler = npcHandler, text = "Ah yes, my lovely wife. God forgive her, but she can't stop talking. So my work is a great rest for my poor ears. *laughs loudly*"})
keywordHandler:addKeyword({'graubart'}, StdModule.say, {npcHandler = npcHandler, text = "I like this old salt. I learned much from him. Whatever. You like some fish? *grin*"})

npcHandler:setMessage(MESSAGE_GREET, "Ahoi, |PLAYERNAME|. You want to buy some fresh fish?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and come again!")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Buy all the fish you want. It's fresh and healthy, promised.")
npcHandler:addModule(FocusModule:new())
