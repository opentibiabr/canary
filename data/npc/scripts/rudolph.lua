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

npcHandler:setMessage(MESSAGE_GREET, "Oh, a customer. Hello |PLAYERNAME|. If you'd like to see my wonderful self-tailored clothes, ask me for a {trade}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Oh, good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh, good bye.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my wares.")

npcHandler:addModule(FocusModule:new())
