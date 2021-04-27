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

local voices = { {text = 'Gems of all kinds! Precious jewellery!'} }
npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setMessage(MESSAGE_GREET, "Feel welcome to my gem store, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Bye, bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Bye, bye.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Here, take a look.")
npcHandler:addModule(FocusModule:new())
