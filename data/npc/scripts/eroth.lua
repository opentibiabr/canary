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

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the leader of the Cenath caste."})
keywordHandler:addKeyword({'kuridai'}, StdModule.say, {npcHandler = npcHandler, text = "The Kuridai are aggressive and victims of their instincts. Without our help they would surely die in a foolish war."})
keywordHandler:addKeyword({'crunor'}, StdModule.say, {npcHandler = npcHandler, text = "Gods are for the weak. We will master the world on our own. We need no gods."})
keywordHandler:addKeyword({'deraisim'}, StdModule.say, {npcHandler = npcHandler, text = "They lack the understanding of unity. We are keeping them together and prevent them from being slaughtered one by one."})
keywordHandler:addKeyword({'cenath'}, StdModule.say, {npcHandler = npcHandler, text = "We are the shepherds of our people. The other castes need our guidance."})
keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = "Magic comes almost naturally to the Cenath. We keep the secrets of ages."})
keywordHandler:addKeyword({'spell'}, StdModule.say, {npcHandler = npcHandler, text = "I can teach the spells 'magic shield', 'destroy field', 'creature illusion', 'chameleon', 'convince creature', and 'summon creature'."})

-- Greeting message
keywordHandler:addGreetKeyword({"ashari"}, {npcHandler = npcHandler, text = "I greet thee, outsider."})
--Farewell message
keywordHandler:addFarewellKeyword({"asgha thrazi"}, {npcHandler = npcHandler, text = "Asha Thrazi. Go, where you have to go."})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "I greet thee, outsider.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Asha Thrazi. Go, where you have to go.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Asha Thrazi.")

npcHandler:addModule(FocusModule:new())