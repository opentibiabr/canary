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

local voices = { {text = 'Courageous adventurers, come buy your weapons and armors here!'} }
npcHandler:addModule(VoiceModule:new(voices))


npcHandler:setMessage(MESSAGE_GREET, "Hello, dear |PLAYERNAME|. Can I be of any assistance? Just tell me if you'd like to {trade} weapons or armor.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|. Do come again!.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye, |PLAYERNAME|. Do come again!.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my offers.")

npcHandler:addModule(FocusModule:new())
