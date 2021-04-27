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

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the archsorcerer of Carlin. I keep the secrets of our order."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Lea."})
--keywordHandler:addKeyword({'spell'}, StdModule.say, {npcHandler = npcHandler, text = "Sorry, I only sell spells to sorcerers."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "Time is a force we sorcerers will master one day."})
keywordHandler:addKeyword({'sorcerer'}, StdModule.say, {npcHandler = npcHandler, text = "Any sorcerer dedicates his whole life to the study of the arcane arts."})
keywordHandler:addKeyword({'power'}, StdModule.say, {npcHandler = npcHandler, text = "We sorcerers wield arcane powers beyond comprehension of men."})
keywordHandler:addKeyword({'arcane'}, StdModule.say, {npcHandler = npcHandler, text = "We sorcerers wield arcane powers beyond comprehension of men."})

npcHandler:setMessage(MESSAGE_GREET, "Greetings, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care on your journeys.")
npcHandler:addModule(FocusModule:new())
