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

local voices = { {text = 'Buying and selling all sorts of weapons and armors!'} }
npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am buying some weapons and armors."})

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|! Do you need my services?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Visit me whenever you want to sell something.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye. Visit me whenever you want to sell something.")

npcHandler:addModule(FocusModule:new())
