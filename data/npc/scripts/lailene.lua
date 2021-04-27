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

keywordHandler:addKeyword({'brotherhood of bones'}, StdModule.say, {npcHandler = npcHandler, text = "... what?! Uh - no, no. Of course I wouldn't have anything to do with... them."})

npcHandler:setMessage(MESSAGE_GREET, "What do you want in my magical robe store? I doubt I have anything that's of interest to you.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See ya, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "See ya, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Here.")
npcHandler:addModule(FocusModule:new())
