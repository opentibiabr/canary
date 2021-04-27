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

local voices = { {text = 'Beds, chairs, tables, statues and everything you could imagine for decorating your home!'} }
npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({'furniture'}, StdModule.say, {npcHandler = npcHandler, text = "I have {beds}, {chairs}, {containers}, {decoration}, {flowers}, {instruments}, {pillows}, {pottery}, {statues}, {tapestries} and {tables}. Which of those would you like to see?"})

npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|! Do you need some equipment for your house?")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Have a look. Most furniture comes in handy kits. Just use them in your house to assemble the furniture. Do you want to see only a certain {type} of furniture?")

npcHandler:addModule(FocusModule:new())
