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

local voices = { {text = 'Chchch'} }
npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({'acorn'}, StdModule.say, {npcHandler = npcHandler, text = "Chh? Chhh?? <though you don't understand squirrelish, that one seems really excited>"})

npcHandler:setMessage(MESSAGE_GREET, "Chhchh?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Chh...")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Chh...")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Chchch. Chh! <you're not sure, but it seems that squirrel wants to trade your valuable acorns for useless stones that it found and considered uneatable>")

npcHandler:addModule(FocusModule:new())
